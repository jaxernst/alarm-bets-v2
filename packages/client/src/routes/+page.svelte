<script lang="ts">
	import WakeupGoal from '$lib/components/WakeupGoal.svelte'
	import { getEntitiesWithValue, getComponentValueStrict } from '@latticexyz/recs'
	import ChallengeTimeline from '$lib/components/ChallengeTimeline.svelte'
	import { mud, user } from '$lib/mud/mudStore'
	import { goto } from '$app/navigation'
	import GoalCreator from '$lib/components/GoalCreator.svelte'
	import { fade, slide } from 'svelte/transition'
	import TabPill from '$lib/components/TabPill.svelte'
	import Sun from '$lib/icons/Sun.svelte'
	import CheckIn from '$lib/icons/CheckIn.svelte'
	import ChallengeCard from '$lib/components/ChallengeCard.svelte'
	import AvailableChallenges from '$lib/components/available-challenges/AvailableChallenges.svelte'

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
	type DashboardTab = 'Active Challenges' | 'Available Challenges' | 'Leaderboard'
	let activeTab: DashboardTab = 'Available Challenges'
</script>

<div class="h-full flex flex-col gap-6">
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
			class={`px-4 py-2 ${
				wakeupGoals.length === 1 ? 'flex justify-center' : 'grid-container overflow-y-auto'
			}`}
		>
			{#each wakeupGoals as goal}
				<WakeupGoal
					{goal}
					open={wakeupGoals.length === 1}
					onOpenFirstChallenge={() => (activeTab = 'Available Challenges')}
				/>
			{/each}
		</div>
	</div>

	<div class="flex-grow flex flex-col overflow-y-auto bg-gradient-to-b from-zinc-100 to-zinc-200 rounded-t-2xl px-2 ">
		<div
			class="py-2 flex items-center gap-3 text-cyan-400"
		>
			<TabPill
				on:click={() => (activeTab = 'Active Challenges')}
				active={activeTab === 'Active Challenges'}
			>
				Active Challenges
			</TabPill>
			<TabPill
				on:click={() => (activeTab = 'Available Challenges')}
				active={activeTab === 'Available Challenges'}
			>
				Available Challenges
			</TabPill>
			<TabPill on:click={() => (activeTab = 'Leaderboard')} active={activeTab === 'Leaderboard'}>
				Leaderboard
			</TabPill>
		</div>

		<div class="grid text-zinc-400 flex-grow overflow-auto h-max p-2">
			{#if activeTab === 'Leaderboard'}
				<div transition:fade class="h-full flex flex-col row-start-1 col-start-1 whitespace-nowrap text-sm">
					Leaderboard coming soon ...
				</div>
			{:else if activeTab === 'Available Challenges'}
				<div transition:fade class="flex flex-col overflow-y-auto row-start-1 col-start-1 whitespace-nowrap text-sm">
					<AvailableChallenges />
				</div>
			{:else}
				<div
					transition:fade
					class="h-full row-start-1 col-start-1 flex flex-col items-stretch overflow-hidden"
				>
					{#if !wakeupChallenges.length}
						<div class="text-sm">No active challenges ...</div>
					{:else}
						<div class="overflow-y-auto">
							<ChallengeTimeline challenges={wakeupChallenges} />
						</div>
					{/if}
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
