<script lang="ts">
	import type { Entity } from '@latticexyz/recs'
	import TabPill from './design-sys/TabPill.svelte'
	import WakeupGoal from './WakeupGoal.svelte'
	import { getActiveWakeupChallenges } from '$lib/mud/mudStore'
	import { fade } from 'svelte/transition'
	import AvailableChallenges from './available-challenges/AvailableChallenges.svelte'
	import ActiveChallenge from './active-challenges/ActiveChallenge.svelte'

	export let wakeupGoal: Entity

	$: activeChallenges = $getActiveWakeupChallenges(wakeupGoal)

	type DashboardTab = 'Active Challenges' | 'Available Challenges'
	let activeTab: DashboardTab = 'Active Challenges'
</script>

<div class="px-4 grid">
	<div class="col-start-1 row-start-1">
		<WakeupGoal goal={wakeupGoal} open={false} />
	</div>
</div>

<div class="flex flex-shrink flex-col overflow-y-auto rounded-t-2xl px-3">
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

	<div class="border-[.05px] border-cyan-400 w-full" />

	<div class="py-4 grid text-zinc-400 flex-grow overflow-auto h-max ">
		{#if activeTab === 'Available Challenges'}
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
				{#if !activeChallenges.length}
					<div class="text-sm">No active challenges ...</div>
				{:else}
					<div class="flex flex-col items-stretch gap-2">
						{#each activeChallenges as challenge}
							<ActiveChallenge {challenge} />
						{/each}
					</div>
				{/if}
			</div>
		{/if}
	</div>
</div>
