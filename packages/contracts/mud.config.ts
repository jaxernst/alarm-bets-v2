import { mudConfig } from "@latticexyz/world/register";
/**
 * Daily check-in:
 * State:
 *  map WakeupObjecive => Schedule (days of week, start time, end time, confirmation submitter)
 *
 */
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
    Suns: "uint32",
    Level: "uint32",

    // Challenge State
    DailyCheckIn: {
      valueSchema: {
        scheduleId: "bytes32",
        endTime: "uint32",
        alarmDays: "uint8[]", // Days of the week the alarm is to be enforced on (1 Sunday - 7 Saturday)
      },
    },

    AlarmSchedules: {
      // Schedule state
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
