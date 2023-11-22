import { mudConfig } from "@latticexyz/world/register";

export default mudConfig({
  tables: {
    Counter: {
      keySchema: {},
      valueSchema: "uint32",
    },

    // Wakeup Objective state
    WakeupObjective: "bool",
    Creator: "address",
    AlarmTime: "uint32",
    Timezone: "int8",
    WakeupConfirmations: "uint32",
    Suns: "uint256",
    Level: "uint32",

    // Challenge State
    DailyCheckInState: {
      valueSchema: {
        active: "bool",
        confirmationSubmitter: "address",
        expirationTime: "uint256",
      },
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
