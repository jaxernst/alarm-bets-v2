import { mudConfig } from "@latticexyz/world/register";

export default mudConfig({
  enums: {
    Status: ["Inactive", "Active", "Complete"],
  },
  tables: {
    Counter: {
      keySchema: {},
      valueSchema: "uint32",
    },

    // Wakeup goal components
    WakeupObjective: "bool",
    Creator: "address",
    AlarmTime: "uint32",
    Timezone: "int8",
    WakeupConfirmations: "uint32",
    Suns: "uint32",
    Level: "uint32",

    // Wakeup challenge components
    WakeupChallenge: "bool",
    ChallengeName: "string",
    TargetWakeupObjective: "bytes32",
    ExpirationTime: "uint256",
    ChallengeStatus: "Status",
    ChallengeDays: "uint8[]",
    SunsStaked: "uint32",
    EthStaked: "uint256",

    AlarmSchedule: {
      valueSchema: {
        alarmTime: "uint32",
        submissionWindow: "uint32",
        timezoneOffset: "int8",
        activationTimestamp: "uint32",
        lastEntryTime: "uint32",
        alarmEntries: "uint32",
        expiration: "uint32",
        alarmDays: "uint8[]",
      },
    },
  },

  systems: {
    AlarmScheduleSystem: {
      openAccess: true,
    },
  },

  modules: [
    {
      name: "UniqueEntityModule",
      root: true,
      args: [],
    },
  ],
});
