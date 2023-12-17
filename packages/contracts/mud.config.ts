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

    // Generic components
    Creator: "address",
    Timezone: "int8",
    ExpirationTime: "uint256",
    StartTime: "uint256",

    // Wakeup goal specific components
    WakeupObjective: "bool",
    BaseReward: "uint32",
    AlarmTime: "uint32",
    Suns: "uint32",
    Level: "uint32",

    // Wakeup challenge components
    WakeupChallengeType: "uint32",
    TargetWakeupObjective: "bytes32",
    ChallengeStatus: "Status",
    ChallengeDays: "uint8[]",
    SunsStaked: "uint32",
    EthStaked: "uint256",

    // Wakeup challenge schedule components
    // TODO: Break apart 'AlarmSchedule' into individual components
    WakeupConfirmations: "uint32",

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

    // Unused
    TimezoneAttested: "bool",
    SubmissionWindow: "uint32",
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
