// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

import { getUniqueEntity } from "@latticexyz/world-modules/src/modules/uniqueentity/getUniqueEntity.sol";
import { SystemSwitch } from "@latticexyz/world-modules/src/utils/SystemSwitch.sol";
import { System } from "@latticexyz/world/src/System.sol";
import { Status } from "../codegen/common.sol";
import { AlarmScheduleSystem } from "./AlarmScheduleSystem.sol";
import { WakeupObjective, Creator, Timezone, AlarmTime, Suns, ChallengeStatus, WakeupChallengeType, ExpirationTime, TargetWakeupObjective, ChallengeDays, SunsStaked } from "../codegen/index.sol";
import { IWorld } from "../codegen/world/IWorld.sol";

/**
 * DailyCheckIn challenge: Earn suns for checking in on any day of the week within
 * the subission window
 */
contract DailyCheckInSystem is System {
  uint32 constant CHALLENGE_ID = 2;
  uint32 constant SUBMISSION_WINDOW = 15 minutes;
  uint32 constant SUN_REWARD_PER_DAY = 11;

  modifier onlyChallengeEntity(bytes32 challengeEntity) {
    require(WakeupChallengeType.get(challengeEntity) == CHALLENGE_ID, "Not a wakeup challenge");
    _;
  }

  function DailyCheckIn_enter(bytes32 wakeupObjective) public returns (bytes32) {
    address creator = Creator.get(wakeupObjective);

    require(WakeupObjective.get(wakeupObjective), "Not a wakeup objective");
    require(creator == _msgSender(), "creator only");

    bytes32 challengeEntity = getUniqueEntity();

    WakeupChallengeType.set(challengeEntity, CHALLENGE_ID);
    TargetWakeupObjective.set(challengeEntity, wakeupObjective);
    Creator.set(challengeEntity, creator);
    ChallengeStatus.set(challengeEntity, Status.Active);

    return challengeEntity;
  }

  function DailyCheck_confirmWakeup(bytes32 challengeEntity) public onlyChallengeEntity(challengeEntity) {
    address challengeCreator = Creator.get(challengeEntity);
    bytes32 wakeupObjective = TargetWakeupObjective.get(challengeEntity);
    int8 timezoneHrs = Timezone.get(wakeupObjective);
    uint32 alarmTime = AlarmTime.get(wakeupObjective);

    require(challengeCreator == _msgSender(), "Only creator can confirm wakeup");
    require(_inSubmissionWindow(alarmTime, timezoneHrs), "Not in submission window");

    _creditEntity(TargetWakeupObjective.get(challengeEntity), SUN_REWARD_PER_DAY);
  }

  function _creditEntity(bytes32 entity, uint32 amount) private {
    Suns.set(entity, Suns.get(entity) + amount);
  }

  function _inSubmissionWindow(uint32 alarmTime, int8 timezoneHrs) private pure returns (bool) {
    return true;
  }
}
