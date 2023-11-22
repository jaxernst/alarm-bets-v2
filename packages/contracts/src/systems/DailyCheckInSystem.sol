// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

import { System } from "@latticexyz/world/src/System.sol";
import { WakeupObjective, Creator, Timezone, AlarmTime, Suns, DailyCheckInState, DailyCheckInStateData } from "../codegen/index.sol";
import { AlarmSchedule } from "../library/AlarmSchedule.sol";

contract DailyCheckInSystem is System {
  using AlarmSchedule for AlarmSchedule.Schedule;

  uint public constant SUBMISSION_WINDOW = 15 minutes;
  uint public constant SUN_REWARD_PER_DAY = 10;

  mapping(bytes32 => AlarmSchedule.Schedule) schedules;

  function enter(bytes32 wakeupObjective, uint32 numWeeks, uint8[] memory challengeDays) public returns (uint32) {
    require(WakeupObjective.get(wakeupObjective), "Not a wakeup challenge");

    int8 timezoneHrs = Timezone.get(wakeupObjective);
    uint alarmTime = AlarmTime.get(wakeupObjective);
    address creator = Creator.get(wakeupObjective);
    require(creator == _msgSender(), "Not creator");

    uint costSuns = numWeeks * challengeDays.length;
    uint balanceSuns = Suns.get(wakeupObjective);
    require(balanceSuns >= costSuns, "Insufficient Sun balance");
    Suns.set(wakeupObjective, balanceSuns - costSuns);

    uint expiration = block.timestamp + numWeeks * 1 weeks;

    _startSchedule(wakeupObjective, alarmTime, challengeDays, int(timezoneHrs) * 1 hours);
    DailyCheckInState.set(wakeupObjective, true, creator, expiration);
  }

  function confirmWakeup(bytes32 wakeupObjective) public {
    DailyCheckInStateData memory s = DailyCheckInState.get(wakeupObjective);
    require(s.confirmationSubmitter == _msgSender(), "Not confirmation submitter");
    require(s.expirationTime > block.timestamp, "Challenge expired");
    require(schedules[wakeupObjective].inSubmissionWindow(), "Not in submission window");

    schedules[wakeupObjective].recordEntry();
  }

  function completeChallenge(bytes32 wakeupObjective) public {
    DailyCheckInStateData memory s = DailyCheckInState.get(wakeupObjective);
    require(s.confirmationSubmitter == _msgSender(), "Not creator");
    require(s.expirationTime <= block.timestamp, "Challenge period not over");

    uint balanceSuns = Suns.get(wakeupObjective);

    uint numConfirmations = schedules[wakeupObjective].entries();

    // Reward the wakeup objective and mark challenge as inactive
    Suns.set(wakeupObjective, balanceSuns + numConfirmations * SUN_REWARD_PER_DAY);
    DailyCheckInState.setActive(wakeupObjective, false);
  }

  function _startSchedule(
    bytes32 wakeupObjective,
    uint alarmTime,
    uint8[] memory challengeDays,
    int timezoneSeconds
  ) private {
    {
      // Create new schedule
      schedules[wakeupObjective].init(alarmTime, challengeDays, SUBMISSION_WINDOW, timezoneSeconds);
      schedules[wakeupObjective].start();
    }
  }
}
