// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

import { getUniqueEntity } from "@latticexyz/world-modules/src/modules/uniqueentity/getUniqueEntity.sol";
import { System } from "@latticexyz/world/src/System.sol";
import { Creator, AlarmTime, Timezone, Credit, WakeupConfirmations } from "../codegen/index.sol";

contract WakeupObjectiveCreationSystem is System {
  function newObjective(uint32 wakeupTime, int8 playerTimezoneHrs) public returns (bytes32) {
    bytes32 entity = getUniqueEntity();

    Creator.set(entity, _msgSender());
    AlarmTime.set(entity, wakeupTime);
    Timezone.set(entity, playerTimezoneHrs);
    Credit.set(entity, 0);
    WakeupConfirmations.set(entity, 0);

    return entity; 
  }
}
