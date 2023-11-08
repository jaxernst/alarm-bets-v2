<script>
  import EthSymbol from "./lib/icons/EthSymbol.svelte";
  import Reputation from "./lib/icons/Reputation.svelte";
  import Sun from "./lib/icons/Sun.svelte";
  import Wallet from "./lib/icons/Wallet.svelte";
  import CircularProgress from "./lib/CircularProgress.svelte";
  import Lock from "./lib/icons/Lock.svelte";

  let user = "0x205b";
  let wakeupObjective = true;

  const activeChallenges = [
    { name: "Daily Check In", colorClass: "text-purple-600", open: true },
    { name: "Bet w/ Hunter B.", colorClass: "text-blue-500", open: false },
  ];

  const upcomingChallenges = {
    M: [
      { time: "8:00am", value: "10xp", open: true },
      { time: "8:30am", value: "8xp", open: false },
    ],
    T: [{ time: "8:00am", value: "10xp" }],
    W: [{ time: "8:00am", value: "10xp" }],
    Th: [{ time: "8:00am", value: "10xp" }],
  };

  const activeDays = new Set(["M", "T", "W", "Th"]);

  const blueGradientClass = [
    "border-blue-700",
    "border-blue-600",
    "border-blue-500",
    "border-blue-400",
    "border-blue-300",
    "border-blue-200",
    "border-blue-100",
  ];
</script>

<div class="flex justify-center">
  <div
    class="flex flex-col items-stretch text-zinc-700 h-screen min-w-[400px] max-w-[700px]"
  >
    <div class="flex-grow px-2 flex flex-col gap-3 bg-zinc-50">
      <div class="p-3 flex justify-between w-full items-center">
        <h1 class="text-cyan-500 font-bold text-xl">Alarm Bets</h1>
        <div class="stroke-cyan-500 w-6">
          <Wallet />
        </div>
      </div>

      <div class="w-full px-2">
        <!--Current Wakeup Objective-->
        {#if !wakeupObjective}
          Create new wakeup goal
        {:else}
          <div class="text-sm py-1 text-cyan-500 flex justify-between">
            Wakeup Goals
            <div>1 / 1</div>
          </div>
          <div class="p-2 flex items-center min-h-[100px]">
            <div class="flex gap-2 w-full">
              <div
                class="flex-grow self-center font-digital text-4xl font-bold"
                style="line-height:1em"
              >
                8:30 am
              </div>
              <div class="flex-col items-end flex gap-1 text-sm text-zinc-400">
                <div class="flex items-center gap-2">
                  <CircularProgress progress={0.3}>12343</CircularProgress>
                </div>
              </div>
            </div>
          </div>
        {/if}
      </div>

      <div class="px-2 flex flex-col gap-2 items-stretch">
        <div class="text-sm text-cyan-500">Upcoming Challenges</div>
        <div class="flex flex-col gap-1">
          {#each ["Tu", "W", "Th", "Sa", "Su", "M"] as day, i}
            <div class="flex gap-4">
              <div
                class={` ${
                  activeDays.has(day) ? "text-green-500" : "text-zinc-300"
                }`}
              >
                {day}
              </div>
              <div class="flex flex-grow gap-2">
                {#if upcomingChallenges[day]}
                  {#each upcomingChallenges[day] as challenge}
                    <div
                      class={`${
                        challenge.open
                          ? "border border-zinc-500 text-zinc-500"
                          : "bg-zinc-300"
                      } flex gap-2 items-center  text-sm text-white font-semibold rounded-xl px-2 py-1`}
                    >
                      {challenge.time}
                    </div>
                  {/each}
                {/if}
              </div>
            </div>
          {/each}
        </div>
      </div>
      <div
        class={`p-2 justify-center font-semibold text-white rounded-xl items-center flex-grow`}
      >
        <div class={`flex justify-between gap-4 text-zinc-500 p-3`}>
          <div class="py-2 text-lg text-zinc-700">8:30am</div>
          <div class="text-zinc-400 flex items-center">
            Daily wakeup challenge
          </div>
        </div>
      </div>
    </div>
    <ul
      class="flex w-full justify-evenly py-2 bg-cyan-500 text-white font-bold rounded-t-lg"
    >
      <li>Dashboard</li>
      <li>Challenges</li>
      <li>Friends</li>
    </ul>
  </div>
</div>

<style>
  .days-row {
    display: inline-flex;
    flex-wrap: wrap;
    flex-direction: row;
    font-size: 1em;
    justify-content: space-evenly;
  }

  .day {
    padding: 0 0.3em 0 0.3em;
    color: rgb(161 161 170);
    opacity: 0.3;
  }

  .today {
    border-bottom: 0.1em solid white;
    opacity: 1;
  }

  .active {
    opacity: 1;
    color: var(--active-color);
  }
</style>
