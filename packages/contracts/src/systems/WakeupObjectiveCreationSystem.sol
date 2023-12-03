// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

import { getUniqueEntity } from "@latticexyz/world-modules/src/modules/uniqueentity/getUniqueEntity.sol";
import { System } from "@latticexyz/world/src/System.sol";
import { WakeupObjective, Creator, AlarmTime, Timezone, Suns, Level, WakeupConfirmations } from "../codegen/index.sol";

contract WakeupObjectiveCreationSystem is System {
  function newObjective(uint32 wakeupTime, int8 playerTimezoneHrs) public returns (bytes32) {
    bytes32 entity = getUniqueEntity();

    WakeupObjective.set(entity, true);
    Creator.set(entity, _msgSender());
    AlarmTime.set(entity, wakeupTime);
    Timezone.set(entity, playerTimezoneHrs);

    Suns.set(entity, 20);
    WakeupConfirmations.set(entity, 0);
    Level.set(entity, 1);

    return entity;
  }
}
