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
    Suns: "uint256",
    Level: "uint32",

    // Wakeup challenge components
    WakeupChallenge: "bool",
    TargetWakeupObjective: "bytes32",
    ExpirationTime: "uint256",
    ChallengeStatus: "Status",
    ChallengeName: "string",
    ChallengeDays: "uint8[]",
  },

  modules: [
    {
      name: "UniqueEntityModule",
      root: true,
      args: [],
    },
  ],
});
