<script lang="ts">
	import Sun from '../../icons/Sun.svelte'
	import { timeString } from '../../util'
	import ActiveDays from '../ActiveDays.svelte'
	import { getComponentValueStrict, type Entity, runQuery } from '@latticexyz/recs'
	import { fade, scale, slide } from 'svelte/transition'
	import { mud, getActiveWakeupChallenges } from '$lib/mud/mudStore'
	import CircularProgress from '../CircularProgress.svelte'
	import Deadline from '$lib/icons/Deadline.svelte'
	import WakeupGoalBadge from './WakeupGoalBadge.svelte'

	export let open = false
	export let goal: Entity

	$: [goalTime, goalLevel, goalSuns] = [
		getComponentValueStrict($mud.components.AlarmTime, goal).value,
		getComponentValueStrict($mud.components.Level, goal).value,
		getComponentValueStrict($mud.components.Suns, goal).value
	]

	$: activeChallenges = $getActiveWakeupChallenges(goal)
	$: numChallenges = activeChallenges.length

	let nextLevelSunRequirement = 100
</script>

<div class="border-l-2 border-zinc-400 pl-2 pb-4">
	<div transition:fade class="flex items-center justify-evenly gap-4 py-6">
		<WakeupGoalBadge wakeupGoal={goal} />
		{#key goalSuns}
			<CircularProgress progress={Number(goalSuns) / nextLevelSunRequirement}>
				<div class="flex flex-col w-[70px] font-semibold text-center fill-cyan-500 text-cyan-500">
					<div class="flex justify-center items-center gap-1">
						100
						<div class="w-4">
							<Sun />
						</div>
					</div>
					<div class="text-zinc-300 text-xs">To level up</div>
				</div>
			</CircularProgress>
		{/key}
	</div>

	<div
		class="relative text-cyan-500 w-full flex flex-wrap items-center gap-2 text-xs border-l-2 pl-2 border-zinc-400"
	>
		<div class="whitespace-nowrap px-1">
			<span class="text-zinc-400">Started</span>
			<span class=" font-extrabold">Dec 21, 2023</span>
		</div>
		<div class="whitespace-nowrap px-1">
			<span class="text-zinc-400"> Made Alarms</span>
			<span class="font-extrabold">23</span>
		</div>
		<div class="whitespace-nowrap px-1">
			<span class="text-zinc-400"> Timezone </span>
			<span class="font-extrabold">UTC-8</span>
		</div>
		<div class="flex gap-1 flex-nowrap px-1">
			<span class="text-zinc-400">Base Alarm Reward</span>
			<div class="flex flex-nowrap gap-1 items-center text-yellow-500 font-extrabold">
				20
				<div class="w-[.9em] fill-yellow-500">
					<Sun />
				</div>
			</div>
		</div>
	</div>
</div>
