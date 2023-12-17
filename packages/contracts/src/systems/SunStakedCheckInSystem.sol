// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

import { getUniqueEntity } from "@latticexyz/world-modules/src/modules/uniqueentity/getUniqueEntity.sol";
import { SystemSwitch } from "@latticexyz/world-modules/src/utils/SystemSwitch.sol";
import { System } from "@latticexyz/world/src/System.sol";
import { Status } from "../codegen/common.sol";
import { AlarmScheduleSystem } from "./AlarmScheduleSystem.sol";
import { WakeupObjective, Creator, Timezone, AlarmTime, Suns, ChallengeStatus, WakeupChallengeType, ExpirationTime, TargetWakeupObjective, ChallengeDays, SunsStaked, WakeupConfirmations, BaseReward } from "../codegen/index.sol";
import { IWorld } from "../codegen/world/IWorld.sol";

contract SunStakedCheckInSystem is System {
  uint32 constant CHALLENGE_ID = 2;
  uint32 constant SUBMISSION_WINDOW = 15 minutes;
  uint32 constant SUN_REWARD_PER_DAY = 11;
  uint32 constant SUN_COST_PER_DAY = 5;

  modifier onlyChallengeEntity(bytes32 challengeEntity) {
    require(WakeupChallengeType.get(challengeEntity) == CHALLENGE_ID, "Not a wakeup challenge");
    _;
  }

  function SunStakedCheckIn_enter(
    bytes32 wakeupObjective,
    uint32 numWeeks,
    uint8[] memory challengeDays
  ) public returns (bytes32) {
    int8 timezoneHrs = Timezone.get(wakeupObjective);
    uint32 alarmTime = AlarmTime.get(wakeupObjective);
    address creator = Creator.get(wakeupObjective);

    uint32 costSuns = numWeeks * uint32(challengeDays.length) * SUN_COST_PER_DAY;

    require(WakeupObjective.get(wakeupObjective), "Not a wakeup objective");
    require(creator == _msgSender(), "creator only");

    // Apply the entry fee for the challenge
    _debitEntity(wakeupObjective, costSuns);

    // Create challenge entity
    bytes32 challengeEntity = getUniqueEntity();
    WakeupChallengeType.set(challengeEntity, CHALLENGE_ID);
    TargetWakeupObjective.set(challengeEntity, wakeupObjective);
    Creator.set(challengeEntity, creator);
    ChallengeStatus.set(challengeEntity, Status.Active);
    ChallengeDays.set(challengeEntity, challengeDays);
    SunsStaked.set(challengeEntity, costSuns);
    WakeupConfirmations.set(challengeEntity, 0);

    uint expiration = block.timestamp + challengeDays.length * numWeeks * 1 days;
    ExpirationTime.set(challengeEntity, expiration);

    _startAlarmSchedule(challengeEntity, alarmTime, timezoneHrs, uint32(expiration), challengeDays);

    return challengeEntity;
  }

  function SunStakedCheckIn_confirmWakeup(bytes32 entity) public onlyChallengeEntity(entity) {
    address challengeCreator = Creator.get(entity);
    uint expiration = ExpirationTime.get(entity);

    require(challengeCreator == _msgSender(), "Only creator can confirm wakeup");
    require(expiration > block.timestamp, "Challenge expired");

    WakeupConfirmations.set(entity, WakeupConfirmations.get(entity) + 1);
    SystemSwitch.call(abi.encodeCall(IWorld(_world()).recordEntry, (entity)));

    uint32 baseWakeupReward = BaseReward.get(TargetWakeupObjective.get(entity));

    _creditEntity(TargetWakeupObjective.get(entity), SUN_REWARD_PER_DAY + baseWakeupReward);
  }

  function _creditEntity(bytes32 entity, uint32 amount) private {
    Suns.set(entity, Suns.get(entity) + amount);
  }

  function _debitEntity(bytes32 entity, uint32 amount) private {
    uint32 balanceSuns = Suns.get(entity);
    require(balanceSuns >= amount, "Insufficient Sun balance");
    Suns.set(entity, balanceSuns - amount);
  }

  function _startAlarmSchedule(
    bytes32 challengeEntity,
    uint32 alarmTime,
    int8 timezoneHrs,
    uint32 expiration,
    uint8[] memory challengeDays
  ) private {
    SystemSwitch.call(
      abi.encodeCall(
        IWorld(_world()).newAlarmSchedule,
        (challengeEntity, alarmTime, SUBMISSION_WINDOW, timezoneHrs, uint32(expiration), challengeDays)
      )
    );
  }
}
