// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

function _alarmScheduleParamsValid(
  uint8[] calldata alarmDays,
  uint32 alarmTime,
  int8 timezoneOffsetHrs
) pure returns (bool) {
  return _validateDaysArr(alarmDays) && alarmTime < 1 days && -12 < timezoneOffsetHrs && timezoneOffsetHrs < 12;
}

function _inSubmissionWindow(uint32 submissionWindow, uint32 alarmTime, int8 timezoneOffset) view returns (bool) {
  if (_deadlinePassedToday(uint32(block.timestamp), alarmTime, timezoneOffset)) {
    return false;
  }

  return
    (_nextDeadlineInterval(uint32(block.timestamp), alarmTime, timezoneOffset) - block.timestamp) < submissionWindow;
}

function _nextAlarmDay(uint8[] memory alarmDays, uint8 currentDay) pure returns (uint8) {
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

function _nextDeadlineInterval(uint32 timestamp, uint32 alarmTime, int8 timezoneOffset) pure returns (uint32) {
  uint32 lastMidnight = _lastMidnightTimestamp(timestamp, timezoneOffset);
  if (_deadlinePassedToday(timestamp, alarmTime, timezoneOffset)) {
    return lastMidnight + 1 days + alarmTime;
  } else {
    return lastMidnight + alarmTime;
  }
}

function _lastDeadlineInterval(uint32 timestamp, uint32 alarmTime, int8 timezoneOffset) pure returns (uint32) {
  uint32 lastMidnight = _lastMidnightTimestamp(timestamp, timezoneOffset);
  if (_deadlinePassedToday(timestamp, alarmTime, timezoneOffset)) {
    return lastMidnight + alarmTime;
  } else {
    return lastMidnight - 1 days + alarmTime;
  }
}

function _deadlinePassedToday(uint32 timestamp, uint32 alarmTime, int8 timezoneOffset) pure returns (bool) {
  uint _now = _offsetTimestamp(timestamp, timezoneOffset);
  return (_now % 1 days) > alarmTime;
}

// 1 = Sunday, 7 = Saturday
function _dayOfWeek(uint32 timestamp) pure returns (uint8 dayOfWeek) {
  uint32 _days = timestamp / 1 days;
  dayOfWeek = uint8(((_days + 4) % 7) + 1);
}

/**
 * @notice 'midnight' is timezone specific so we must offset the timestamp before taking the modulus.
 * this is like pretending UTC started in the user's timezone instead of GMT.
 */
function _lastMidnightTimestamp(uint32 timestamp, int8 timezoneOffset) pure returns (uint32) {
  uint32 localTimestamp = _offsetTimestamp(timestamp, timezoneOffset);
  uint32 lastMidnightLocal = localTimestamp - (localTimestamp % 1 days);
  return _offsetTimestamp(lastMidnightLocal, -timezoneOffset);
}

function _offsetTimestamp(uint32 timestamp, int8 offset) pure returns (uint32) {
  return uint32(int32(timestamp) + offset * int32(3600));
}

function _validateDaysArr(uint8[] calldata daysActive) pure returns (bool) {
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
