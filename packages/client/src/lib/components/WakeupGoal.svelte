<script lang="ts">
  import Sun from "../icons/Sun.svelte";
  import EthSymbol from "../icons/EthSymbol.svelte";
  import Lock from "../icons/Lock.svelte";
  import { timeString } from "../util";

  export let goal: {
    time: number;
    challengeDays: number[];
    sunRating: number;
    valueLocked: string;
    sunsLocked: number;
  };

  let time = timeString(goal.time);
</script>

<div class="flex justify-between items-stretch" style="line-height:1em">
  <div class="px-2 py-1 font-digital text-cyan-600 text-4xl font-bold">
    {time}
  </div>
  <div class="flex flex-col">
    <div class="px-2 flex gap-2 text-xs font-semi py-1 justify-end">
      {#each ["Su", "M", "Tu", "W", "Th", "Sa", "Su"] as day, i}
        <div
          class={` ${
            goal.challengeDays.includes(i + 1)
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
<div class="flex justify-between items-stretch" style="line-height:1em">
  <div class="px-2 pt-1 font-digital text-cyan-600 text-4xl font-bold">
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
