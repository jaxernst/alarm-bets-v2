<script lang="ts">
	import WakeupGoal from '$lib/components/WakeupGoal.svelte'
	import { getEntitiesWithValue, getComponentValueStrict } from '@latticexyz/recs'
	import ChallengeTimeline from '$lib/components/ChallengeTimeline.svelte'
	import { mud, user } from '$lib/mud/mudStore'
	import { goto } from '$app/navigation'
	import GoalCreator from '$lib/components/GoalCreator.svelte'
	import { slide } from 'svelte/transition'

	$: userWakeupGoals = getEntitiesWithValue($mud.components.Creator, { value: $user })

	$: if ($mud.stateSynced && userWakeupGoals.size === 0) {
		console.log('User has no goals, redirecting from dashboard...')
		goto('/welcome')
	}

	const wakeupChallenges = [] || [
		{
			id: 1,
			days: [2, 3, 4, 5],
			time: 28800,
			title: 'Wakeup Check-in',
			sunReward: 10,
			sunPenalty: 6,
			ethPenalty: 0
		},
		{
			id: 2,
			days: [3, 4, 5],
			time: 30600,
			title: 'Alarm Bet with jaxer.eth',
			sunReward: 10,
			sunPenalty: 6,
			ethPenalty: 0.001
		}
	]

	$: entities = getEntitiesWithValue($mud.components.Creator, { value: $user })
	$: wakeupGoals = Array.from(entities).map((entity) => {
		return {
			entity,
			time: getComponentValueStrict($mud.components.AlarmTime, entity).value,
			timezone: getComponentValueStrict($mud.components.Timezone, entity).value,
			suns: getComponentValueStrict($mud.components.Suns, entity).value,
			level: getComponentValueStrict($mud.components.Level, entity).value
		}
	})

	let showGoalCreator = false
</script>

<div class="h-full flex flex-col gap-10">
	<div class="w-full px-2">
		{#if showGoalCreator}
			<div transition:slide>
				<GoalCreator
					onGoalCreated={() => {
						showGoalCreator = false
					}}
					onClose={() => {
						showGoalCreator = false
					}}
				/>
			</div>
		{/if}
		<div class="text-sm py-2 text-cyan-500 flex justify-between">
			Goals
			<button on:click={() => (showGoalCreator = true)} class="text-base"
				>{showGoalCreator ? '' : '+'}</button
			>
		</div>
		<div
			class={`${
				wakeupGoals.length === 1 ? 'flex justify-center' : 'grid-container overflow-y-auto'
			}`}
		>
			{#each wakeupGoals as goal}
				<WakeupGoal {goal} open={wakeupGoals.length === 1} />
			{/each}
		</div>
	</div>

	<div class="flex gap-4 flex-col flex-grow bg-slate-100 shadow-xl rounded-t-2xl py-3">
		<div class="px-2 flex items-center gap-3 text-cyan-400">
			<div class="rounded-full px-2 py-1 bg-cyan-400 text-cyan-50">Active Challenges</div>
			<div class="rounded-full px-2 py-1">Available Challenges</div>
			<div class="rounded-full px-2 py-1">Leaderboard</div>
		</div>

		<div class="px-2 flex flex-col items-stretch overflow-hidden">
			{#if !wakeupChallenges.length}
				<div class="p-3 text-zinc-400 text-sm">No active challenges ...</div>
			{:else}
				<div class="overflow-y-auto">
					<ChallengeTimeline challenges={wakeupChallenges} />
				</div>
			{/if}
		</div>
	</div>
</div>

<style>
	.grid-container {
		display: grid;
		grid-template-columns: repeat(auto-fill, minmax(150px, 1fr));
		grid-gap: 10px;
	}
</style>
