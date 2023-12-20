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
    Expiration: "uint256",
    StartTime: "uint256",
    DaysOfWeek: "uint8[]",

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
    SunsStaked: "uint32",
    EthStaked: "uint256",

    // Alarm schedule components
    WakeupConfirmations: "uint32",
    SubmissionWindow: "uint32",
    LastEntryTime: "uint256",

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
