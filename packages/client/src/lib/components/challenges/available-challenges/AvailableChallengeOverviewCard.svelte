<script lang="ts">
	import Sun from '$lib/icons/Sun.svelte'
	import EthSymbol from '$lib/icons/EthSymbol.svelte'
	import { fade } from 'svelte/transition'
	import type { Challenge } from './types'
	import { getComponentValueStrict, getEntitiesWithValue, type Entity } from '@latticexyz/recs'
	import Lock from '$lib/icons/Lock.svelte'
	import { mud, user } from '$lib/mud/mudStore'

	export let challenge: Challenge
	export let wakeupGoals: { id: Entity; level: number }[]
	

	$: maxWakeupObjectiveLevel = Math.max(...wakeupGoals.map((goal) => goal.level))
	$: qualifies = challenge.requiredLevel <= maxWakeupObjectiveLevel
</script>

<button
	on:click
	in:fade={{ delay: 200, duration: 100 }}
	class="flex flex-col gap-2 rounded-lg bg-slate-50 items-center border-zinc-400 p-2 text-sm"
>
	<div class={`${qualifies ? "bg-cyan-400 text-cyan-50 stroke-cyan-50" : "text-zinc-400 bg-zinc-200 stroke-zinc-400" } font-bold rounded-full flex items-center gap-1 px-2 py-1 text-xs`}>
		<span class="w-3 "><Lock /></span>Lvl {challenge.requiredLevel}
	</div>
	<div class="font-semibold text-zinc-400">
		{challenge.name}
	</div>
	<div class="flex items-center gap-3">
		{#if challenge.staked}
			<div class="w-3 fill-cyan-400 "><EthSymbol /></div>
		{/if}
		<div class="flex gap-1 items-center text-sm text-green-500">
			+{challenge.reward}
			<div class="w-3 fill-cyan-400"><Sun /></div>
		</div>

		<div class="flex gap-1 items-center text-sm text-red-600">
			{challenge.entryCost}
			<div class="w-3 fill-cyan-400"><Sun /></div>
		</div>
	</div>
</button>
