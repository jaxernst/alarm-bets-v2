// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

import { System } from "@latticexyz/world/src/System.sol";
import { TargetWakeupObjective, AlarmTime, Timezone, DaysOfWeek } from "../codegen/index.sol";
import { _nextDeadlineTimestamp } from "../library/ScheduleUtils.sol";

contract AlarmScheduleSystem is System {
  function nextDeadlineTimestamp(bytes32 challengeEntity) public view returns (uint) {
    uint8[] memory alarmDays = DaysOfWeek.get(challengeEntity);
    bytes32 targetWakeupObjective = TargetWakeupObjective.get(challengeEntity);
    uint32 alarmTime = AlarmTime.get(targetWakeupObjective);
    int8 timezoneOffset = Timezone.get(targetWakeupObjective);

    return _nextDeadlineTimestamp(alarmTime, alarmDays, timezoneOffset);
  }
}
