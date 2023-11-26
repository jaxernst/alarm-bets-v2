<script lang="ts">
	import Sun from '../icons/Sun.svelte'
	import { timeString } from '../util'
	import ActiveDays from './ActiveDays.svelte'
	import { getComponentValueStrict, type Entity, runQuery } from '@latticexyz/recs'
	import GradientCard from './design-sys/GradientCard.svelte'
	import { fade, scale, slide } from 'svelte/transition'
	import { userWakeupGoals, mud, activeWakeupChallenges } from '$lib/mud/mudStore'
	import CircularProgress from './CircularProgress.svelte'
	import Deadline from '$lib/icons/Deadline.svelte'

	export let open = false
	export let goal: Entity

	$: [goalTime, goalLevel, goalSuns] = [
		getComponentValueStrict($mud.components.AlarmTime, goal).value,
		getComponentValueStrict($mud.components.Level, goal).value,
		getComponentValueStrict($mud.components.Suns, goal).value
	]

	$: numChallenges = $activeWakeupChallenges.length

	let nextLevelSunRequirement = 100
	let challengeDays: number[] = []
	$: {
		const activeChallengeDays = new Set<number>()

		$activeWakeupChallenges.forEach((challenge) => {
			const days = getComponentValueStrict($mud.components.ChallengeDays, challenge).value
			days.forEach((day) => {
				if (!activeChallengeDays.has(day)) {
					activeChallengeDays.add(day)
				}
			})
		})

		challengeDays = Array.from(activeChallengeDays)
	}
</script>

<div
	in:slide={{ axis: 'x' }}
	out:scale
	class="flex items-center justify-evenly gap-4 rounded-xl py-4"
>
	<div class="flex flex-col bg-gradient-to-b from-cyan-300 to-cyan-500 p-3 rounded-xl">
		<div
			class="whitespace-nowrap font-digital text-cyan-100 from-cyan-50 to-cyan-200 text-5xl font-bold text-center pt-1"
			style="line-height:.8em"
		>
			{timeString(goalTime)}
		</div>

		<div class="self-center font-semibold justify-center">
			<ActiveDays
				activeDays={challengeDays}
				activeDayClass={'text-cyan-100'}
				inactiveDayClass={challengeDays.length === 0 ? 'text-cyan-100' : 'text-cyan-500'}
			/>
		</div>
	</div>
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
	<div class="self-stretch flex flex-col gap-1 text-zinc-400 fill-cyan-500">
		<div
			class="font-bold bg-gradient-to-r from-cyan-300 to-cyan-500 rounded-full px-2 text-cyan-50"
		>
			Level {goalLevel}
		</div>
		<div class="flex items-center text-sm gap-2">
			<div class="w-4 ">
				<Sun />
			</div>
			{goalSuns}
		</div>
		<div class="flex items-center text-sm  gap-2">
			<div class="w-4 ">
				<Deadline />
			</div>
			{numChallenges}
		</div>
	</div>
</div>
