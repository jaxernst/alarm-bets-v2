<script lang="ts">
	import type { Entity } from '@latticexyz/recs'
	import TabPill from './design-sys/TabPill.svelte'
	import WakeupGoal from './wakeup-goals/WakeupGoal.svelte'
	import { getActiveWakeupChallenges } from '$lib/mud/mudStore'
	import { fade } from 'svelte/transition'
	import AvailableChallenge from './challenges/AvailableChallenge.svelte'
	import ActiveChallenge from './challenges/ActiveChallenge.svelte'
	import { challengeTypes } from '$lib/challengeTypes'

	export let wakeupGoal: Entity

	const availableChallenge = challengeTypes

	$: activeChallenges = $getActiveWakeupChallenges(wakeupGoal)

	type DashboardTab = 'Active Challenges' | 'Available Challenges'
	let activeTab: DashboardTab = 'Active Challenges'
</script>

<div class="px-4 grid py-2">
	<div class="col-start-1 row-start-1">
		<WakeupGoal goal={wakeupGoal} open={false} />
	</div>
</div>

<div class="flex flex-shrink flex-col overflow-y-auto rounded-t-2xl px-3 pt-5">
	<div class="py-3 flex items-center gap-3 text-cyan-400">
		<TabPill
			on:click={() => (activeTab = 'Active Challenges')}
			active={activeTab === 'Active Challenges'}
		>
			<div class="flex items-center gap-1">
				Active Challenges
				{#if activeChallenges.length}
					<div class="bg-cyan-50 text-cyan-400 rounded-full w-5 aspect-square">
						{activeChallenges.length}
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
	</div>

	<div class=" grid text-zinc-400 flex-grow overflow-auto h-max overflow-y-auto">
		<div
			transition:fade
			class="px-1 sm:px-2 py-2 flex flex-col gap-2 row-start-1 col-start-1 whitespace-nowrap overflow-visible text-sm"
		>
			{#if activeTab === 'Available Challenges'}
				{#each availableChallenge as challenge}
					<AvailableChallenge {challenge} {wakeupGoal} />
				{/each}
			{:else if activeTab === 'Active Challenges'}
				{#if !activeChallenges.length}
					<div class="text-sm">No active challenges ...</div>
				{:else}
					<div class="flex flex-col items-stretch gap-2">
						{#each activeChallenges as challenge}
							<ActiveChallenge {challenge} />
						{/each}
					</div>
				{/if}
			{/if}
		</div>
	</div>
</div>
