// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

/* Autogenerated file. Do not edit manually. */

/**
 * @title IDailyCheckInSystem
 * @dev This interface is automatically generated from the corresponding system contract. Do not edit manually.
 */
interface IDailyCheckInSystem {
  function DailyCheckIn_enter(bytes32 wakeupObjective) external returns (bytes32);

  function DailyCheckIn_confirmWakeup(bytes32 challengeEntity) external;
}
