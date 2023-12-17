// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

import { getUniqueEntity } from "@latticexyz/world-modules/src/modules/uniqueentity/getUniqueEntity.sol";
import { System } from "@latticexyz/world/src/System.sol";
import { WakeupObjective, Creator, AlarmTime, Timezone, Suns, Level, WakeupConfirmations, BaseReward, StartTime } from "../codegen/index.sol";

contract WakeupObjectiveCreationSystem is System {
  function newObjective(uint32 wakeupTime, int8 playerTimezoneHrs) public returns (bytes32) {
    bytes32 entity = getUniqueEntity();

    WakeupObjective.set(entity, true);
    Creator.set(entity, _msgSender());
    AlarmTime.set(entity, wakeupTime);
    Timezone.set(entity, playerTimezoneHrs);
    StartTime.set(entity, block.timestamp);

    uint32 baseReward = getBaseReward(wakeupTime);

    Suns.set(entity, baseReward);
    BaseReward.set(entity, baseReward);
    Level.set(entity, 1);

    return entity;
  }

  /**
   * Wakeup based reward:
   *  - linear interpolation between 50 (at 5:00 AM) and 5 (at 10:00 AM)
   *  - rewards clamped to these max/min values outside this timeframe.
   */
  function getBaseReward(uint32 alarmTime) public pure returns (uint32) {
    // Later than 10:00am gets min base reward (5 suns)
    if (alarmTime > 36_000) {
      return 5;
    }

    // Earlier than 5:00am gets max base reward (50 suns)
    if (alarmTime < 18_000) {
      return 50;
    }

    // Linear interpolation between (18000, 50) and (36000, 5)
    int32 reward = (-5 * int32(alarmTime)) / 2 + 95_000;

    // Correct the scaling by dividing by 1000
    return uint32(reward / 1000);
  }
}
