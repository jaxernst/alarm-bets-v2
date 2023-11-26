// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

/* Autogenerated file. Do not edit manually. */

/**
 * @title IDailyCheckInSystem
 * @dev This interface is automatically generated from the corresponding system contract. Do not edit manually.
 */
interface IDailyCheckInSystem {
  function DailyCheckIn_enter(bytes32 wakeupObjective, uint32 numWeeks, uint8[] memory challengeDays) external;

  function DailyCheckIn_confirmWakeup(bytes32 challengeId) external;
}