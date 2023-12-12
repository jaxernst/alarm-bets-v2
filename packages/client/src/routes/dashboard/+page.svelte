<script lang="ts">
	import { mud, userWakeupGoals } from '$lib/mud/mudStore'
	import { goto } from '$app/navigation'
	import GoalCreator from '$lib/components/GoalCreator.svelte'
	import { fade, slide } from 'svelte/transition'
	import TabPill from '$lib/components/design-sys/TabPill.svelte'
	import { getComponentValueStrict } from '@latticexyz/recs'
	import { timeString } from '$lib/util'
	import GoalDashboard from '$lib/components/GoalDashboard.svelte'

	$: if ($mud.stateSynced && $userWakeupGoals.length === 0) {
		console.log('User has no goals, redirecting from dashboard...')
		goto('/welcome')
	}

	let showGoalCreator = false

	let iActiveGoal = 0
	$: goalTimes = $userWakeupGoals.map((goal) => {
		return timeString(getComponentValueStrict($mud.components.AlarmTime, goal).value)
	})
</script>

<div class="h-full flex flex-col gap-1">
	{#if showGoalCreator}
		<div transition:slide class="px-4">
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

	<div class="w-full px-2 pt-4">
		<div class="text-sm text-cyan-500 flex justify-between">
			<div class="w-full flex gap-1">
				<div class="px-2 flex gap-2">
					{#each goalTimes as time, i}
						<TabPill
							active={iActiveGoal === i}
							on:click={() => (iActiveGoal = i)}
							inactiveClass="bg-zinc-200 text-white hover:bg-zinc-300 transition-all hover:shadow-md"
							activeClass="shadow bg-zinc-50"
							paddingClass={'px-2'}
							roundedClass={'rounded-lg'}
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

	{#if $userWakeupGoals[iActiveGoal]}
		<div class="flex-grow">
			<GoalDashboard wakeupGoal={$userWakeupGoals[iActiveGoal]} />
		</div>
	{/if}
</div>
