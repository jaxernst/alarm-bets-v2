<script lang="ts">
	import { timeString } from '$lib/util'
	import { getComponentValueStrict, type Entity } from '@latticexyz/recs'
	import { getActiveWakeupChallenges, mud } from '$lib/mud/mudStore'
	import ActiveDays from '../ActiveDays.svelte'
	import Sun from '$lib/icons/Sun.svelte'

	export let wakeupGoal: Entity

	$: goalTime = getComponentValueStrict($mud.components.AlarmTime, wakeupGoal).value
	$: goalLevel = getComponentValueStrict($mud.components.Level, wakeupGoal).value
	$: goalSuns = getComponentValueStrict($mud.components.Suns, wakeupGoal).value

	$: activeChallenges = $getActiveWakeupChallenges(wakeupGoal)

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

<div class="flex flex-col p-3 rounded-xl">
	<div class="flex justify-between items-end text-sm text-cyan-400">
		<div
			class="text-cyan-500 border border-cyan-500 rounded-full px-2 font-semibold flex items-center"
		>
			Level {goalLevel} goal
		</div>
		<div class="">by jaxer.eth</div>
	</div>
	<div
		class="whitespace-nowrap font-digital text-cyan-500 from-cyan-50 to-cyan-200 text-7xl font-bold text-center pt-[.45rem]"
		style="line-height:.8em"
	>
		{timeString(goalTime)}
	</div>

	<div class="flex items-center justify-between">
		<ActiveDays
			textSizeClass={'text-xs font-semibold '}
			activeDays={challengeDays}
			activeDayClass={'text-green-400 font-bold'}
			inactiveDayClass={'text-zinc-300'}
		/>
		<div class="flex items-center text-sm gap-2 text-cyan-400 fill-cyan-400">
			<div class="w-4 ">
				<Sun />
			</div>
			{goalSuns}
		</div>
	</div>
	<div
		class="my-1 self-start text-sm font-semibold px-2 rounded-full bg-gradient-to-r from-cyan-300 to-cyan-400 text-cyan-50"
	>
		Mint
	</div>
</div>
