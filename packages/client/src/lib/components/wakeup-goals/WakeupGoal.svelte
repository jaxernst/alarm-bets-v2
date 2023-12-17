<script lang="ts">
	import Sun from '../../icons/Sun.svelte'
	import { timeString } from '../../util'
	import ActiveDays from '../ActiveDays.svelte'
	import { getComponentValueStrict, type Entity, runQuery, Has, HasValue } from '@latticexyz/recs'
	import { fade, scale, slide } from 'svelte/transition'
	import { mud, getActiveWakeupChallenges } from '$lib/mud/mudStore'
	import CircularProgress from '../CircularProgress.svelte'
	import Deadline from '$lib/icons/Deadline.svelte'
	import WakeupGoalBadge from './WakeupGoalBadge.svelte'

	export let open = false
	export let goal: Entity

	$: [baseReward, startTime, goalSuns] = [
		getComponentValueStrict($mud.components.BaseReward, goal).value,
		getComponentValueStrict($mud.components.StartTime, goal).value,
		getComponentValueStrict($mud.components.Suns, goal).value
	]

	$: getTotalWakeupCount = (goal: Entity) => {
		const allGoalChallenges = runQuery([
			Has($mud.components.WakeupChallengeType),
			HasValue($mud.components.TargetWakeupObjective, { value: goal })
		])

		return Array.from(allGoalChallenges).reduce((sum, entity) => {
			const confirmations = getComponentValueStrict(
				$mud.components.WakeupConfirmations,
				entity
			).value
			return sum + confirmations
		}, 0)
	}

	$: numWakeups = getTotalWakeupCount(goal)

	$: activeChallenges = $getActiveWakeupChallenges(goal)
	$: numChallenges = activeChallenges.length

	$: formattedStart = new Date(Number(startTime) * 1000).toLocaleDateString('en-US', {
		year: 'numeric',
		month: 'short',
		day: 'numeric'
	})

	let nextLevelSunRequirement = 100
</script>

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

<div class="">
	<div
		class=" relative text-cyan-500 flex flex-wrap items-center gap-2 text-xs bg-zinc-100 border-zinc-400 px-2"
	>
		<div class="whitespace-nowrap px-1">
			<span class="text-zinc-400">Started</span>
			<span class=" font-extrabold">{formattedStart}</span>
		</div>
		<div class="whitespace-nowrap px-1">
			<span class="text-zinc-400"> Timezone </span>
			<span class="font-extrabold">UTC-8</span>
		</div>
		<div class="whitespace-nowrap px-1">
			<span class="text-zinc-400"> Made Alarms</span>
			<span class="font-extrabold">{numWakeups}</span>
		</div>
		<div class="whitespace-nowrap px-1">
			<span class="text-zinc-400">Eth Staked</span>
			<span class="font-extrabold">x.x</span>
		</div>
		<div class="flex gap-1 flex-nowrap px-1">
			<span class="text-zinc-400 whitespace-nowrap">Base Alarm Reward</span>
			<div class="flex flex-nowrap gap-1 items-center text-yellow-500 font-extrabold">
				{baseReward}
				<div class="w-[.9em] fill-yellow-500">
					<Sun />
				</div>
			</div>
		</div>
	</div>
</div>
