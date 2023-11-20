<script lang="ts">
	import ChevronUpDown from '$lib/icons/ChevronUpDown.svelte'
	import Sun from '$lib/icons/Sun.svelte'
	import { fade, scale, slide } from 'svelte/transition'
	import type { Challenge } from './types'
	import { cubicInOut, quintInOut } from 'svelte/easing'
	import { type Entity } from '@latticexyz/recs'
	import Lock from '$lib/icons/Lock.svelte'
	import { mud, user } from '$lib/mud/mudStore'
	import { formatTime, timeString } from '$lib/util'
	import ActiveDaysInput from '../ActiveDaysInput.svelte'

	export let challenge: Challenge
	export let wakeupGoals: { id: Entity; level: number, time: number }[]

	let selectedGoal: Entity
	$: if (wakeupGoals && !selectedGoal) {
		selectedGoal = wakeupGoals[0].id
	}

	$: maxWakeupObjectiveLevel = Math.max(...wakeupGoals.map((goal) => goal.level))
	$: qualifies = challenge.requiredLevel <= maxWakeupObjectiveLevel
</script>

<div
	in:fade
	out:scale
	class="flex flex-col gap-3 rounded-lg bg-slate-50 shadow-md border-zinc-400 p-2 w-full text-sm"
>
	<div class="flex justify-between gap-4 text-cyan-700 items-center font-semibold">
		{challenge.name}
		<div class={`${qualifies ? "bg-cyan-400 text-cyan-50 stroke-cyan-50" : "text-zinc-400 bg-zinc-200 stroke-zinc-400" } flex items-center gap-1 rounded-full px-2`}>
			<span class="w-3"><Lock /></span>Level {challenge.requiredLevel}
		</div>
	</div>
	<div class="flex flex-col gap-1">
		<div class="flex self-start gap-3">
			Reward:
			<div class="flex gap-1 items-center text-sm text-green-500">
				+{challenge.reward}
				<div class="w-3 fill-cyan-400"><Sun /></div>
				/ day
			</div>
		</div>
		<div class="flex self-start gap-3">
			Entry cost:
			<div class="flex gap-1 items-center text-sm text-red-600">
				{challenge.entryCost}
				<div class="w-3 fill-cyan-400"><Sun /></div>
				/ day
			</div>
		</div>
	</div>
	<div
		in:slide={{ delay: 100, easing: cubicInOut }}
		class="p-2 flex justify-center w-full bg-zinc-100 rounded-lg gap-2"
	>
		<div class="text-center whitespace-normal">
			{challenge.description}
		</div>
	</div>

	{#if qualifies}
	<div class="text-cyan-500 text-center">Enter Challenge</div>
	<div class="flex gap-3">
		Target Goal:
		{#each wakeupGoals as goal}
			<button
				on:click={() => (selectedGoal = goal.id)}
				disabled={selectedGoal === goal.id}
				class="rounded-full bg-zinc-200 text-white px-1 disabled:bg-cyan-600 disabled:font-semibold transition-all"
				>{timeString(goal.time)}</button
			>
		{/each}
	</div>
	<div class="flex gap-3">
		Choose days:
		<ActiveDaysInput
			activeDayClass={'rounded-full bg-cyan-600 text-white font-bold px-1'}
			inactiveDayClass={''}
		/>
	</div>
	{:else}
	<div class="text-red-600 font-light text-center">You must reach level {challenge.requiredLevel} to enter this challenge</div>
	{/if}
</div>
