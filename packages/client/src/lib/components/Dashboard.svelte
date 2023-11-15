<script lang="ts">
	import WakeupGoal from '$lib/components/WakeupGoal.svelte'
	import { getEntitiesWithValue, getComponentValueStrict } from '@latticexyz/recs'
	import ChallengeTimeline from './ChallengeTimeline.svelte'
	import { mud, user } from '../mud/mudStore'
	import GradientCard from './design-sys/GradientCard.svelte'

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
</script>

<div class="h-full px-2 flex flex-col gap-6">
	<div class="w-full px-2">
		<div class="text-sm py-2 text-cyan-500 flex justify-between">
			Goals
			<a href="/new-goal" class="text-base">+</a>
		</div>
		{#if wakeupGoals.length === 0}
			<div class="pt-4">
				<GradientCard>
					<p>Create your first wakeup goal...</p>
				</GradientCard>
			</div>
		{:else}
			<div
				class={`${
					wakeupGoals.length === 1 ? 'flex justify-center' : 'grid-container overflow-y-auto'
				} max-h-[260px]`}
			>
				{#each wakeupGoals as goal}
					<WakeupGoal {goal} open={wakeupGoals.length === 1} />
				{/each}
			</div>
		{/if}
	</div>

	<div class="p-2 flex flex-col flex-grow gap-2 items-stretch overflow-hidden">
		<div class="flex items-center justify-between text-cyan-500">
			<div class="text-sm">Challenges</div>
			<div>+</div>
		</div>
		{#if !wakeupChallenges.length}
			<div class="p-4">
				<div class="p-2 bg-slate-50 rounded-xl text-zinc-400 text-sm">
					Create at least one wakeup goal to enter into daily challenges...
				</div>
			</div>
		{:else}
			<div class="overflow-y-auto">
				<ChallengeTimeline challenges={wakeupChallenges} />
			</div>
		{/if}
	</div>
</div>

<style>
	.grid-container {
		display: grid;
		grid-template-columns: repeat(auto-fill, minmax(150px, 1fr));
		grid-gap: 10px;
	}
</style>
