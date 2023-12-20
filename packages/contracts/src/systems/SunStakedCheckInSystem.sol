// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

import { getUniqueEntity } from "@latticexyz/world-modules/src/modules/uniqueentity/getUniqueEntity.sol";
import { SystemSwitch } from "@latticexyz/world-modules/src/utils/SystemSwitch.sol";
import { System } from "@latticexyz/world/src/System.sol";
import { Status } from "../codegen/common.sol";
import { AlarmScheduleSystem } from "./AlarmScheduleSystem.sol";
import { WakeupObjective, Creator, Timezone, AlarmTime, Suns, ChallengeStatus, WakeupChallengeType, Expiration, TargetWakeupObjective, DaysOfWeek, SunsStaked, WakeupConfirmations, BaseReward, LastEntryTime, StartTime } from "../codegen/index.sol";
import { IWorld } from "../codegen/world/IWorld.sol";

import { _alarmScheduleParamsValid, _inSubmissionWindow } from "../library/ScheduleUtils.sol";

contract SunStakedCheckInSystem is System {
  uint32 constant CHALLENGE_ID = 2;
  uint32 constant SUBMISSION_WINDOW = 15 minutes;
  uint32 constant SUN_REWARD_PER_DAY = 11;
  uint32 constant SUN_COST_PER_DAY = 5;
  uint32 constant COMPLETION_BONUS = 20;

  modifier onlyChallengeEntity(bytes32 challengeEntity) {
    require(WakeupChallengeType.get(challengeEntity) == CHALLENGE_ID, "Wrong challenge entity");
    _;
  }

  function SunStakedCheckIn_enter(
    bytes32 wakeupObjective,
    uint32 numWeeks,
    uint8[] calldata challengeDays
  ) public returns (bytes32) {
    require(WakeupObjective.get(wakeupObjective), "Not a wakeup objective");

    int8 timezoneHrs = Timezone.get(wakeupObjective);
    uint32 alarmTime = AlarmTime.get(wakeupObjective);
    address creator = Creator.get(wakeupObjective);

    require(_alarmScheduleParamsValid(challengeDays, alarmTime, timezoneHrs), "Invalid schedule params");
    require(creator == _msgSender(), "creator only");

    // Apply the entry fee for the challenge
    uint32 costSuns = numWeeks * uint32(challengeDays.length) * SUN_COST_PER_DAY;
    _debitEntity(wakeupObjective, costSuns);

    // Create challenge entity and schedule components
    bytes32 challengeEntity = getUniqueEntity();
    WakeupChallengeType.set(challengeEntity, CHALLENGE_ID);
    ChallengeStatus.set(challengeEntity, Status.Active);
    TargetWakeupObjective.set(challengeEntity, wakeupObjective);
    Creator.set(challengeEntity, creator);
    SunsStaked.set(challengeEntity, costSuns);

    uint expiration = block.timestamp + challengeDays.length * numWeeks * 1 days;
    Expiration.set(challengeEntity, expiration);
    StartTime.set(challengeEntity, block.timestamp);
    DaysOfWeek.set(challengeEntity, challengeDays);
    WakeupConfirmations.set(challengeEntity, 0);

    return challengeEntity;
  }

  function SunStakedCheckIn_confirmWakeup(bytes32 entity) public onlyChallengeEntity(entity) {
    address challengeCreator = Creator.get(entity);
    uint expiration = Expiration.get(entity);
    uint lastEntryTime = LastEntryTime.get(entity);
    uint timeSinceLastEntry = block.timestamp - lastEntryTime;

    bytes32 targetObjective = TargetWakeupObjective.get(entity);
    int8 timezoneHrs = Timezone.get(targetObjective);
    uint32 alarmTime = AlarmTime.get(targetObjective);

    require(challengeCreator == _msgSender(), "Only creator can confirm wakeup");
    require(expiration > block.timestamp, "Challenge expired");
    require(_inSubmissionWindow(SUBMISSION_WINDOW, alarmTime, timezoneHrs), "Not in submission window");
    require(timeSinceLastEntry >= 1 days - SUBMISSION_WINDOW, "Already submitted today");

    WakeupConfirmations.set(entity, WakeupConfirmations.get(entity) + 1);
    LastEntryTime.set(entity, block.timestamp);

    uint32 baseWakeupReward = BaseReward.get(TargetWakeupObjective.get(entity));
    _creditEntity(TargetWakeupObjective.get(entity), SUN_REWARD_PER_DAY + baseWakeupReward);
  }

  function SunStakedCheckIn_complete(bytes32 entity) public onlyChallengeEntity(entity) {
    require(ChallengeStatus.get(entity) == Status.Active, "Challenge not active");
    require(Expiration.get(entity) < block.timestamp, "Challenge not expired");

    bytes32 targetObjective = TargetWakeupObjective.get(entity);

    // Pay out the suns staked to the creator
    _creditEntity(targetObjective, COMPLETION_BONUS);

    // Mark the challenge as complete
    ChallengeStatus.set(entity, Status.Complete);
  }

  function _creditEntity(bytes32 entity, uint32 amount) private {
    Suns.set(entity, Suns.get(entity) + amount);
  }

  function _debitEntity(bytes32 entity, uint32 amount) private {
    uint32 balanceSuns = Suns.get(entity);
    require(balanceSuns >= amount, "Insufficient Sun balance");
    Suns.set(entity, balanceSuns - amount);
  }
}
