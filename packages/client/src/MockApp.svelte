<script>
  import EthSymbol from "./lib/icons/EthSymbol.svelte";
  import Reputation from "./lib/icons/Reputation.svelte";
  import Sun from "./lib/icons/Sun.svelte";
  import Wallet from "./lib/icons/Wallet.svelte";
  import CircularProgress from "./lib/CircularProgress.svelte";
  import Lock from "./lib/icons/Lock.svelte";

  let wakeupObjective = true;

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
</script>

<div class="flex justify-center">
  <div
    class="flex flex-col items-stretch text-zinc-700 h-screen min-w-[400px] max-w-[500px]"
  >
    <div class="flex-grow px-2 flex flex-col gap-6 bg-zinc-50">
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
          <div class="text-sm py-2 text-cyan-500 flex justify-between">
            Wakeup Goals
            <div class="text-base">+</div>
          </div>
          <div class="flex flex-col min-h-[100px] gap-2">
            <div
              class="flex justify-between items-stretch"
              style="line-height:1em"
            >
              <div
                class="px-2 py-1 font-digital text-cyan-600 text-4xl font-bold"
              >
                8:00 am
              </div>
              <div class="flex flex-col">
                <div class="px-2 flex gap-2 text-xs font-semi py-1 justify-end">
                  {#each ["Tu", "W", "Th", "Sa", "Su", "M"] as day, i}
                    <div
                      class={` ${
                        activeDays.has(day)
                          ? "text-cyan-400 font-bold"
                          : "text-zinc-400"
                      }`}
                    >
                      {day}
                    </div>
                  {/each}
                </div>
                <div class="flex justify-end gap-1 items-center">
                  <div
                    class="px-2 text-xs rounded-full bg-cyan-400 text-white font-semibold"
                  >
                    Lvl 10
                  </div>
                  <div
                    class="flex gap-1 items-center px-2 text-xs rounded-full bg-cyan-400 text-white font-semibold"
                  >
                    42
                    <div class="w-3 h-min fill-white">
                      <Sun />
                    </div>
                  </div>
                </div>
              </div>
            </div>
            <div
              class="flex justify-between items-stretch"
              style="line-height:1em"
            >
              <div
                class="px-2 pt-1 font-digital text-cyan-600 text-4xl font-bold"
              >
                8:30 am
              </div>
              <div class="flex flex-col">
                <div class="px-2 flex gap-2 text-xs font-semi py-1 justify-end">
                  {#each ["Su", "M", "T", "W", "Th", "F", "Sa"] as day, i}
                    <div
                      class={` ${
                        ["M", "T", "W", "Th", "F"].includes(day)
                          ? "text-cyan-400 font-bold"
                          : "text-zinc-400"
                      }`}
                    >
                      {day}
                    </div>
                  {/each}
                </div>
                <div class="flex justify-end gap-1 items-center">
                  <div
                    class="px-2 text-xs rounded-full bg-cyan-400 text-white font-semibold"
                  >
                    Lvl 5
                  </div>
                  <div
                    class="flex gap-1 items-center px-2 text-xs rounded-full bg-cyan-400 text-white font-semibold"
                  >
                    23
                    <div class="w-3 h-min fill-white">
                      <Sun />
                    </div>
                  </div>
                  <div
                    class="flex gap-1 items-center px-2 text-xs rounded-full bg-cyan-400 text-white font-semibold"
                  >
                    .0123
                    <div class="flex">
                      <div class="w-3 h-min fill-white">
                        <EthSymbol />
                      </div>
                      <div class="w-3 h-min stroke-white">
                        <Lock />
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        {/if}
      </div>

      <div class="p-2 flex flex-col gap-2 items-stretch">
        <div class="flex items-center justify-between text-cyan-500">
          <div class="text-sm">Upcoming Challenges</div>
          <div>+</div>
        </div>

        <div class="flex flex-col gap-3">
          <div
            class={`flex flex-col gap-3 bg-zinc-100 shadow-lg p-2 rounded-xl w-full text-zinc-500 px-2`}
          >
            <div class="flex justify-between">
              <div>
                <div class="text-cyan-600 font-semibold">8:00am</div>
                <div
                  class="text-zinc-400 flex gap-1 items-center font-semibold"
                >
                  Wakeup Check-in
                </div>
                <div
                  class="pt-2 text-zinc-400 pl-2 flex gap-1 items-center text-sm"
                >
                  Due in 2 hours and 29 minutes...
                </div>
              </div>
              <div class="flex self-start gap-3">
                <div class="flex gap-2 items-center text-sm text-green-500">
                  +10 <div class="w-3 fill-cyan-400"><Sun /></div>
                </div>
                <div class="flex gap-2 items-center text-sm text-red-600">
                  -6 <div class="w-3 fill-cyan-400"><Sun /></div>
                </div>
              </div>
            </div>
            <div class="flex justify-end text-white">
              <div class="px-2 bg-cyan-400 text-white rounded-lg font-semibold">
                Check In
              </div>
            </div>
          </div>
          <div
            class={`flex bg-zinc-100 p-2 rounded-xl justify-between w-full text-zinc-500 px-2`}
          >
            <div>
              <div class="text-cyan-600 font-semibold">8:30am</div>
              <div class="text-zinc-400 flex gap-1 items-center font-semibold">
                Alarm Bet with jaxer.eth
              </div>
            </div>
            <div class="flex flex-col justify-evenly items-end">
              <div class="flex gap-2">
                <div class="flex gap-1 items-center text-sm text-green-500">
                  +10 <div class="w-3 fill-cyan-400"><Sun /></div>
                </div>
                <div class="flex gap-1 items-center text-sm text-red-600">
                  -6 <div class="w-3 fill-cyan-400"><Sun /></div>
                </div>
              </div>
              <div class="flex gap-2 text-sm">
                <div class="flex gap-1 items-center text-sm text-zinc-400">
                  <span class="text-xs">+/- </span>.002
                  <div class="w-3 fill-cyan-400"><EthSymbol /></div>
                </div>
                <div class="flex gap-1 items-center text-sm text-zinc-400">
                  .01
                  <div class="flex">
                    <div class="w-3 h-min fill-cyan-400">
                      <EthSymbol />
                    </div>
                    <div class="w-3 h-min stroke-cyan-400">
                      <Lock />
                    </div>
                  </div>
                </div>
              </div>
            </div>
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
