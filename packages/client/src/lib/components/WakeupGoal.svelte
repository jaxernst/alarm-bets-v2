<script lang="ts">
	import Sun from '../icons/Sun.svelte'
	import { timeString } from '../util'
	import ActiveDays from './ActiveDays.svelte'
	import { getComponentValueStrict, type Entity, runQuery } from '@latticexyz/recs'
	import { fade, scale, slide } from 'svelte/transition'
	import { mud, getActiveWakeupChallenges } from '$lib/mud/mudStore'
	import CircularProgress from './CircularProgress.svelte'
	import Deadline from '$lib/icons/Deadline.svelte'

	export let open = false
	export let goal: Entity

	$: [goalTime, goalLevel, goalSuns] = [
		getComponentValueStrict($mud.components.AlarmTime, goal).value,
		getComponentValueStrict($mud.components.Level, goal).value,
		getComponentValueStrict($mud.components.Suns, goal).value
	]

	$: console.log(Number(goalSuns) / nextLevelSunRequirement)
	$: activeChallenges = $getActiveWakeupChallenges(goal)
	$: numChallenges = activeChallenges.length

	let nextLevelSunRequirement = 100
	let challengeDays: number[] = []
	$: {
		const activeChallengeDays = new Set<number>()
		activeChallenges.forEach((challenge) => {
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

<div transition:fade class="flex items-center justify-evenly gap-4 rounded-xl py-6">
	<div class="flex flex-col p-3 rounded-xl">
		<div
			class="whitespace-nowrap font-digital text-cyan-400 from-cyan-50 to-cyan-200 text-5xl font-bold text-center pt-1"
			style="line-height:.8em"
		>
			{timeString(goalTime)}
		</div>

		<div class="self-center font-semibold justify-center">
			<ActiveDays
				textSizeClass={'text-xs'}
				activeDays={challengeDays}
				activeDayClass={'text-green-400 font-bold'}
				inactiveDayClass={'text-zinc-300'}
			/>
		</div>
	</div>
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
