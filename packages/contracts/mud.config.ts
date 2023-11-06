import { mudConfig } from "@latticexyz/world/register";

export default mudConfig({
  tables: {
    Counter: {
      keySchema: {},
      valueSchema: "uint32",
    },

    WakeupObjectives: {
      keySchema: {
        user: "address",
        id: "bytes32",
      },
      valueSchema: {
        entity: "bytes32",
      },
    },

    Creator: "address",
    AlarmTime: "uint32",
    Timezone: "int8",
    WakeupConfirmations: "uint32",
    Credit: "uint32",
  },
  modules: [
    {
      name: "UniqueEntityModule",
      root: true,
      args: [],
    },
  ],
});
