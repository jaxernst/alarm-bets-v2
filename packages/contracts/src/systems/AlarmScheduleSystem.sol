// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

import { System } from "@latticexyz/world/src/System.sol";
import { AlarmSchedule } from "../codegen/index.sol";

contract AlarmScheduleSystem is System {
  modifier started(bytes32 entity) {
    require(AlarmSchedule.getActivationTimestamp(entity) > 0, "NOT_STARTED");
    _;
  }

  modifier notExpired(bytes32 entity) {
    require(AlarmSchedule.getExpiration(entity) > block.timestamp, "EXPIRED");
    _;
  }

  function newAlarmSchedule(
    bytes32 entity,
    uint32 alarmTime,
    uint32 submissionWindow,
    int8 timezoneOffsetHrs,
    uint32 expiration,
    uint8[] memory alarmDays
  ) public {
    require(AlarmSchedule.getAlarmTime(entity) == 0, "ALARM_SCHEDULE_EXISTS");
    require(_validateDaysArr(alarmDays), "INVALID_DAYS");
    require(alarmTime < 1 days, "INVALID_ALARM_TIME");
    require(-12 < timezoneOffsetHrs && timezoneOffsetHrs < 12, "INVALID_TIMEZONE_OFFSET");

    // The 'activation' occurs at the next alarm deadline interval. This interval occurs at next timestamp
    // which the alarmTime (in local timezone) will occur
    uint32 activationTimestamp = _nextDeadlineInterval(uint32(block.timestamp), alarmTime, timezoneOffsetHrs);

    // Initialize the schedule for the entity mud
    AlarmSchedule.set(
      entity,
      alarmTime,
      submissionWindow,
      timezoneOffsetHrs,
      activationTimestamp,
      0, // lastEntryTime
      0, // alarmEntries
      expiration,
      alarmDays
    );
  }

  function recordEntry(bytes32 entity) public started(entity) notExpired(entity) {
    uint32 currentTime = uint32(block.timestamp);
    uint32 lastEntryTime = AlarmSchedule.getLastEntryTime(entity);
    uint32 submissionWindow = AlarmSchedule.getSubmissionWindow(entity);
    uint32 timeSinceLastEntry = currentTime - lastEntryTime;

    // Require that the user has waited at least 1 day since last entry (with margin for the submission window)
    require(timeSinceLastEntry >= 1 days - submissionWindow, "ALREADY_SUBMITTED_TODAY");

    require(inSubmissionWindow(entity), "NOT_IN_SUBMISSION_WINDOW");

    AlarmSchedule.setLastEntryTime(entity, uint32(block.timestamp));
    AlarmSchedule.setAlarmEntries(entity, AlarmSchedule.getAlarmEntries(entity) + 1);
  }

  function inSubmissionWindow(bytes32 entity) public view started(entity) notExpired(entity) returns (bool) {
    uint32 alarmTime = AlarmSchedule.getAlarmTime(entity);
    int8 timezoneOffset = AlarmSchedule.getTimezoneOffset(entity);

    if (_deadlinePassedToday(uint32(block.timestamp), alarmTime, timezoneOffset)) {
      return false;
    }

    return
      (_nextDeadlineInterval(uint32(block.timestamp), alarmTime, timezoneOffset) - block.timestamp) <
      AlarmSchedule.getSubmissionWindow(entity);
  }

  function expired(bytes32 entity) public view started(entity) returns (bool) {
    return block.timestamp > AlarmSchedule.getExpiration(entity);
  }

  /**
   * Determine how many total alarm deadlines have been missed for this schedule.
   * This is done by calculating the number of whole weeks that have passed since
   * activation, then calculating how many additional (remainder) alarms days to add,
   * and comparing that with the total entry count.
   *
   * @notice missedDeadlines can still be called after expiration, but will stop counting after the expiration timestamp
   */
  function missedDeadlines(bytes32 entity) internal view started(entity) returns (uint numMissedDeadlines) {
    uint32 alarmTime = AlarmSchedule.getAlarmTime(entity);
    int8 timezoneOffset = AlarmSchedule.getTimezoneOffset(entity);
    uint32 activationTimestamp = AlarmSchedule.getActivationTimestamp(entity);
    uint8[] memory alarmDays = AlarmSchedule.getAlarmDays(entity);
    uint alarmEntries = AlarmSchedule.getAlarmEntries(entity);

    if (block.timestamp < activationTimestamp) return 0;

    uint32 latestTimestamp = block.timestamp > AlarmSchedule.getExpiration(entity)
      ? AlarmSchedule.getExpiration(entity)
      : uint32(block.timestamp);

    uint32 lastDeadline = _lastDeadlineInterval(latestTimestamp, alarmTime, timezoneOffset);
    uint32 daysPassed = (lastDeadline - activationTimestamp) / 1 days;
    uint32 weeksPassed = daysPassed / 7;
    uint32 remainderDays = daysPassed % 7;

    // Get expected entries for full weeks passed
    uint expectedEntriesForFullWeeks = weeksPassed * alarmDays.length;

    // Figure out additional expected entries for remainder days based on which
    // of those remainder days are alarm days
    uint8 alarmsInRemainderDays = 0;
    uint8 startDayOfWeek = _dayOfWeek(_offsetTimestamp(lastDeadline - (remainderDays * 1 days), timezoneOffset));
    uint8 endDayOfWeek = _dayOfWeek(_offsetTimestamp(lastDeadline, timezoneOffset));
    for (uint j = 0; j < alarmDays.length; j++) {
      // I'm sorry
      if (
        (alarmDays[j] >= startDayOfWeek && alarmDays[j] <= endDayOfWeek) ||
        (startDayOfWeek > endDayOfWeek && (alarmDays[j] >= startDayOfWeek || alarmDays[j] <= endDayOfWeek))
      ) {
        alarmsInRemainderDays++;
      }
    }

    uint totalExpectedEntries = expectedEntriesForFullWeeks + alarmsInRemainderDays;
    return totalExpectedEntries - alarmEntries;
  }

  function timeToNextDeadline(bytes32 entity) public view started(entity) returns (uint) {
    return nextDeadlineTimestamp(entity) - block.timestamp;
  }

  function nextDeadlineTimestamp(bytes32 entity) public view started(entity) notExpired(entity) returns (uint) {
    uint32 alarmTime = AlarmSchedule.getAlarmTime(entity);
    int8 timezoneOffset = AlarmSchedule.getTimezoneOffset(entity);
    uint8[] memory alarmDays = AlarmSchedule.getAlarmDays(entity);

    uint32 referenceTimestamp = _lastDeadlineInterval(uint32(block.timestamp), alarmTime, timezoneOffset);
    uint8 curDay = _dayOfWeek(_offsetTimestamp(referenceTimestamp, timezoneOffset));
    uint8 nextDay = _nextAlarmDay(alarmDays, curDay);

    uint8 daysAway;
    if (nextDay > curDay) {
      daysAway = nextDay - curDay;
    } else {
      daysAway = 7 - curDay + _nextAlarmDay(alarmDays, 0);
    }

    return referenceTimestamp + uint(daysAway) * 1 days;
  }

  function _nextAlarmDay(uint8[] memory alarmDays, uint8 currentDay) private pure returns (uint8) {
    /**
     * Iterate over the alarmDays and take the first day that that's greater than today
     * If there are none, return the earliest alarmDay (lowest index)
     */
    for (uint i; i < alarmDays.length; i++) {
      if (alarmDays[i] > currentDay) {
        return alarmDays[i];
      }
    }

    return alarmDays[0];
  }

  function _nextDeadlineInterval(
    uint32 timestamp,
    uint32 alarmTime,
    int8 timezoneOffset
  ) private pure returns (uint32) {
    uint32 lastMidnight = _lastMidnightTimestamp(timestamp, timezoneOffset);
    if (_deadlinePassedToday(timestamp, alarmTime, timezoneOffset)) {
      return lastMidnight + 1 days + alarmTime;
    } else {
      return lastMidnight + alarmTime;
    }
  }

  function _lastDeadlineInterval(
    uint32 timestamp,
    uint32 alarmTime,
    int8 timezoneOffset
  ) private pure returns (uint32) {
    uint32 lastMidnight = _lastMidnightTimestamp(timestamp, timezoneOffset);
    if (_deadlinePassedToday(timestamp, alarmTime, timezoneOffset)) {
      return lastMidnight + alarmTime;
    } else {
      return lastMidnight - 1 days + alarmTime;
    }
  }

  function _deadlinePassedToday(uint32 timestamp, uint32 alarmTime, int8 timezoneOffset) private pure returns (bool) {
    uint _now = _offsetTimestamp(timestamp, timezoneOffset);
    return (_now % 1 days) > alarmTime;
  }

  // 1 = Sunday, 7 = Saturday
  function _dayOfWeek(uint32 timestamp) private pure returns (uint8 dayOfWeek) {
    uint32 _days = timestamp / 1 days;
    dayOfWeek = uint8(((_days + 4) % 7) + 1);
  }

  /**
   * @notice 'midnight' is timezone specific so we must offset the timestamp before taking the modulus.
   * this is like pretending UTC started in the user's timezone instead of GMT.
   */
  function _lastMidnightTimestamp(uint32 timestamp, int8 timezoneOffset) private pure returns (uint32) {
    uint32 localTimestamp = _offsetTimestamp(timestamp, timezoneOffset);
    uint32 lastMidnightLocal = localTimestamp - (localTimestamp % 1 days);
    return _offsetTimestamp(lastMidnightLocal, -timezoneOffset);
  }

  function _offsetTimestamp(uint32 timestamp, int8 offset) private pure returns (uint32) {
    return uint32(int32(timestamp) + offset * int32(3600));
  }

  function _validateDaysArr(uint8[] memory daysActive) private pure returns (bool) {
    if (daysActive.length > 7 || daysActive.length == 0) {
      return false;
    }
    uint8 lastDay;
    for (uint i; i < daysActive.length; i++) {
      uint8 day = daysActive[i];
      if (day == 0 || day > 7 || lastDay > day) {
        return false;
      }
      lastDay = day;
    }
    return true;
  }
}
