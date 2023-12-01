// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

import { getUniqueEntity } from "@latticexyz/world-modules/src/modules/uniqueentity/getUniqueEntity.sol";
import { SystemSwitch } from "@latticexyz/world-modules/src/utils/SystemSwitch.sol";
import { System } from "@latticexyz/world/src/System.sol";
import { Status } from "../codegen/common.sol";
import { AlarmScheduleSystem } from "./AlarmScheduleSystem.sol";
import { WakeupObjective, Creator, Timezone, AlarmTime, Suns, ChallengeStatus, WakeupChallenge, ChallengeName, ExpirationTime, TargetWakeupObjective, ChallengeDays, StartTime, SunsStaked } from "../codegen/index.sol";
import { IWorld } from "../codegen/world/IWorld.sol";

contract DailyCheckInSystem is System {
  string public constant CHALLENGE_NAME = "Daily Check In";
  uint32 public constant SUBMISSION_WINDOW = 15 minutes;
  uint public constant SUN_REWARD_PER_DAY = 10;
  uint public constant SUN_COST_PER_DAY = 6;

  function DailyCheckIn_enter(bytes32 wakeupObjective, uint32 numWeeks, uint8[] memory challengeDays) public {
    int8 timezoneHrs = Timezone.get(wakeupObjective);
    uint32 alarmTime = AlarmTime.get(wakeupObjective);
    address creator = Creator.get(wakeupObjective);
    uint balanceSuns = Suns.get(wakeupObjective);

    uint costSuns = numWeeks * challengeDays.length * SUN_COST_PER_DAY;

    require(WakeupObjective.get(wakeupObjective), "Not a wakeup objective");
    require(creator == _msgSender(), "creator only");
    require(balanceSuns >= costSuns, "Insufficient Sun balance");

    // Apply the entry fee for the challenge
    Suns.set(wakeupObjective, balanceSuns - costSuns);

    // Create challenge entity
    bytes32 challengeId = getUniqueEntity();
    ChallengeName.set(challengeId, CHALLENGE_NAME);
    TargetWakeupObjective.set(challengeId, wakeupObjective);
    WakeupChallenge.set(challengeId, true);
    Creator.set(challengeId, creator);
    ChallengeStatus.set(challengeId, Status.Active);
    ChallengeDays.set(challengeId, challengeDays);
    StartTime.set(challengeId, block.timestamp);
    SunsStaked.set(challengeId, costSuns);

    uint expiration = block.timestamp + numWeeks * 1 weeks;
    ExpirationTime.set(challengeId, expiration);

    SystemSwitch.call(
      abi.encodeCall(
        IWorld(_world()).newAlarmSchedule,
        (challengeId, alarmTime, SUBMISSION_WINDOW, timezoneHrs, uint32(expiration), challengeDays)
      )
    );
  }

  function DailyCheckIn_confirmWakeup(bytes32 challengeId) public {
    address challengeCreator = Creator.get(challengeId);
    uint expiration = ExpirationTime.get(challengeId);

    require(challengeCreator == _msgSender(), "Only creator can confirm wakeup");
    require(expiration > block.timestamp, "Challenge expired");

    SystemSwitch.call(abi.encodeCall(IWorld(_world()).recordEntry, (challengeId)));
  }
}
