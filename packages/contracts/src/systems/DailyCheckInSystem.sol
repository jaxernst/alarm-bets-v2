// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

import { getUniqueEntity } from "@latticexyz/world-modules/src/modules/uniqueentity/getUniqueEntity.sol";
import { SystemSwitch } from "@latticexyz/world-modules/src/utils/SystemSwitch.sol";
import { System } from "@latticexyz/world/src/System.sol";
import { Status } from "../codegen/common.sol";
import { AlarmScheduleSystem } from "./AlarmScheduleSystem.sol";
import { WakeupObjective, Creator, Timezone, AlarmTime, Suns, ChallengeStatus, WakeupChallenge, ChallengeName, ExpirationTime, TargetWakeupObjective, ChallengeDays, SunsStaked } from "../codegen/index.sol";
import { IWorld } from "../codegen/world/IWorld.sol";

contract DailyCheckInSystem is System {
  string public constant CHALLENGE_NAME = "Daily Check In";
  uint32 public constant SUBMISSION_WINDOW = 15 minutes;
  uint32 public constant SUN_REWARD_PER_DAY = 11;
  uint32 public constant SUN_COST_PER_DAY = 5;

  function DailyCheckIn_enter(
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
    bytes32 challengeId = getUniqueEntity();
    ChallengeName.set(challengeId, CHALLENGE_NAME);
    TargetWakeupObjective.set(challengeId, wakeupObjective);
    WakeupChallenge.set(challengeId, true);
    Creator.set(challengeId, creator);
    ChallengeStatus.set(challengeId, Status.Active);
    ChallengeDays.set(challengeId, challengeDays);
    SunsStaked.set(challengeId, costSuns);

    uint expiration = block.timestamp + challengeDays.length * numWeeks * 1 days;
    ExpirationTime.set(challengeId, expiration);

    _startAlarmSchedule(challengeId, alarmTime, timezoneHrs, uint32(expiration), challengeDays);

    return challengeId;
  }

  function DailyCheckIn_confirmWakeup(bytes32 challengeId) public {
    address challengeCreator = Creator.get(challengeId);
    uint expiration = ExpirationTime.get(challengeId);

    require(challengeCreator == _msgSender(), "Only creator can confirm wakeup");
    require(expiration > block.timestamp, "Challenge expired");

    SystemSwitch.call(abi.encodeCall(IWorld(_world()).recordEntry, (challengeId)));

    _creditEntity(TargetWakeupObjective.get(challengeId), SUN_REWARD_PER_DAY);
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
    bytes32 challengeId,
    uint32 alarmTime,
    int8 timezoneHrs,
    uint32 expiration,
    uint8[] memory challengeDays
  ) private {
    SystemSwitch.call(
      abi.encodeCall(
        IWorld(_world()).newAlarmSchedule,
        (challengeId, alarmTime, SUBMISSION_WINDOW, timezoneHrs, uint32(expiration), challengeDays)
      )
    );
  }
}
