<script lang="ts">
	import WakeupGoal from '$lib/components/WakeupGoal.svelte'
	import ChallengeTimeline from '$lib/components/ChallengeTimeline.svelte'
	import { mud, userWakeupGoals, activeWakeupChallenges } from '$lib/mud/mudStore'
	import { goto } from '$app/navigation'
	import GoalCreator from '$lib/components/GoalCreator.svelte'
	import { fade, slide } from 'svelte/transition'
	import TabPill from '$lib/components/design-sys/TabPill.svelte'
	import AvailableChallenges from '$lib/components/available-challenges/AvailableChallenges.svelte'
	import { getComponentValueStrict } from '@latticexyz/recs'
	import { timeString } from '$lib/util'
	import ActiveChallenge from '$lib/components/active-challenges/ActiveChallenge.svelte'

	$: if ($mud.stateSynced && $userWakeupGoals.length === 0) {
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

	let showGoalCreator = false
	type DashboardTab = 'Active Challenges' | 'Available Challenges' | 'Leaderboard'
	let activeTab: DashboardTab = 'Available Challenges'

	let iActiveGoal = 0
	$: goalTimes = $userWakeupGoals.map((goal) => {
		return timeString(getComponentValueStrict($mud.components.AlarmTime, goal).value)
	})
</script>

<div class="h-full flex flex-col gap-4">
	{#if showGoalCreator}
		<div transition:slide>
			<GoalCreator
				firstGoal={$userWakeupGoals.length === 0}
				onGoalCreated={() => {
					showGoalCreator = false
				}}
				onClose={() => {
					showGoalCreator = false
				}}
			/>
		</div>
	{/if}
	{#if $userWakeupGoals.length}
		<div class="w-full px-2">
			<div class="text-sm text-cyan-500 flex justify-between">
				<div class="w-full flex flex-col gap-1">
					<div class="flex justify-between items-center">Goals</div>
					<div class="px-2 flex gap-2">
						{#each goalTimes as time, i}
							<TabPill
								active={iActiveGoal === i}
								on:click={() => (iActiveGoal = i)}
								inactiveClass="bg-zinc-200 text-white hover:bg-zinc-300 transition-all hover:shadow-md"
								paddingClass={'px-2'}
							>
								{time}
							</TabPill>
						{/each}
						<button
							on:click={() => (showGoalCreator = true)}
							class="rounded-full aspect-square h-full bg-zinc-200 hover:bg-zinc-300 transition-all hover:shadow-md px-2 flex justify-center items-center text-lg text-white font-bold pb-[.2em]"
						>
							+
						</button>
					</div>
				</div>
			</div>
		</div>
		<div class="px-4 grid">
			{#key iActiveGoal}
				<div class="col-start-1 row-start-1">
					<WakeupGoal goal={$userWakeupGoals[iActiveGoal]} open={false} />
				</div>
			{/key}
		</div>
	{/if}

	<div class="flex flex-shrink flex-col overflow-y-auto rounded-t-2xl px-3">
		<div class="py-3 flex items-center gap-3 text-cyan-400">
			<TabPill
				on:click={() => (activeTab = 'Active Challenges')}
				active={activeTab === 'Active Challenges'}
			>
				<div class="flex items-center gap-1">
					Active Challenges
					{#if $activeWakeupChallenges.length}
						<div class="bg-cyan-50 text-cyan-400 rounded-full w-5 aspect-square">
							{$activeWakeupChallenges.length}
						</div>
					{/if}
				</div>
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

		<div class="border border-cyan-400 w-full" />

		<div class="py-4 grid text-zinc-400 flex-grow overflow-auto h-max ">
			{#if activeTab === 'Leaderboard'}
				<div
					transition:fade
					class="h-full flex flex-col row-start-1 col-start-1 whitespace-nowrap text-sm"
				>
					Leaderboard coming soon ...
				</div>
			{:else if activeTab === 'Available Challenges'}
				<div
					transition:fade
					class="flex flex-col overflow-y-auto row-start-1 col-start-1 whitespace-nowrap text-sm"
				>
					<AvailableChallenges />
				</div>
			{:else if activeTab === 'Active Challenges'}
				<div
					transition:fade
					class="h-full row-start-1 col-start-1 flex flex-col items-stretch overflow-hidden"
				>
					{#if !$activeWakeupChallenges.length}
						<div class="text-sm">No active challenges ...</div>
					{:else}
						<div class="flex overflow-x-auto gap-2">
							{#each $activeWakeupChallenges as challenge}
								<ActiveChallenge {challenge} />
							{/each}
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
