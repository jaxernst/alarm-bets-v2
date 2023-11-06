<script lang="ts">
  import { writable } from "svelte/store";
  import { counter, mud  } from "./mudStore";
  import { getTimezoneOffsetInHours } from "./lib/util"
  import { world } from "./mud/world"
  import { getComponentValueStrict, runQuery, HasValue  } from "@latticexyz/recs"

  $: components = $mud.components
  $: systemCalls = $mud.systemCalls
  $: userAddress = $mud.network.walletClient.account.address 

  console.log("comps", $mud, components) 
  
  const matchingEntities = runQuery([
    HasValue($mud.components.Creator, { value: userAddress })
  ])
    console.log(matchingEntities)

  // Alarm Objective Creation Params
  const alarmTime = writable(0);
  const timezone = getTimezoneOffsetInHours() 
  
  $: createWakeupObjective = () => {
      $mud?.systemCalls.createWakeupObjective($alarmTime, timezone)
  }
</script>


<div>Counter: <span id="counter">{$counter.value}</span></div>
<button on:click={systemCalls.increment}>Increment</button>

<div>Make new wakeup objective:</div>
<input type="number" bind:value={$alarmTime} />
<button on:click={createWakeupObjective}>Go</button>
