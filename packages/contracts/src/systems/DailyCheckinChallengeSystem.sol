// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

import { System } from "@latticexyz/world/src/System.sol";
import { WakeupObjective, Creator, Timezone } from "../codegen/index.sol";

contract DailyCheckinChallengeSystem is System {
  using AlarmSchedule for AlarmSchedule.Schedule;

  uint constant public SUBMISSION_WINDOW = 15 minutes;

  mapping(bytes32 => AlarmSchedule) schedules;

  function enter(
    bytes32 wakeupObjective, 
    uint numWeeks, 
    uint8[] memory challengeDays
  ) public returns (uint32) {
    require(WakeupObjective.get(wakeupObjective), "Not a wakeup challenge");
    
    uint timezone = Timezone.get(wakeupObjective);
    uint alarmTime = AlarmTime.get(wakeupObjective);


    address creator = Creator.get(wakeupObjective);

    // Create new schedule

  }
}