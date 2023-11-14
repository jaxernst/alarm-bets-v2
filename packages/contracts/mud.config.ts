import { mudConfig } from "@latticexyz/world/register";

export default mudConfig({
  tables: {
    Counter: {
      keySchema: {},
      valueSchema: "uint32",
    },

    WakeupObjective: "bool",
    Creator: "address",
    AlarmTime: "uint32",
    Timezone: "int8",
    WakeupConfirmations: "uint32",
    Suns: "uint32",
    Level: "uint32",
  },
  modules: [
    {
      name: "UniqueEntityModule",
      root: true,
      args: [],
    },
  ],
});
