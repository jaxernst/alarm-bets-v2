<script lang="ts">
	import { timeString } from '$lib/util'
	import { getComponentValueStrict, type Entity } from '@latticexyz/recs'
	import { getActiveWakeupChallenges, mud } from '$lib/mud/mudStore'
	import ActiveDays from '../ActiveDays.svelte'
	import Sun from '$lib/icons/Sun.svelte'
	import { Challenge } from '$lib/types'

	export let wakeupGoal: Entity

	$: goalTime = getComponentValueStrict($mud.components.AlarmTime, wakeupGoal).value
	$: goalLevel = getComponentValueStrict($mud.components.Level, wakeupGoal).value
	$: goalSuns = getComponentValueStrict($mud.components.Suns, wakeupGoal).value

	$: activeChallenges = $getActiveWakeupChallenges(wakeupGoal)

	let challengeDays: number[] = []
	$: {
		const activeChallengeDays = new Set<number>()
		activeChallenges.forEach((challenge) => {
			const challengeType = getComponentValueStrict(
				$mud.components.WakeupChallengeType,
				challenge
			).value

			console.log(challengeType, Challenge.DailyCheckIn)
			if (challengeType === Challenge.DailyCheckIn) return

			const days = getComponentValueStrict($mud.components.DaysOfWeek, challenge).value
			days.forEach((day) => {
				if (!activeChallengeDays.has(day)) {
					activeChallengeDays.add(day)
				}
			})
		})
		challengeDays = Array.from(activeChallengeDays)
	}
</script>

<div class="flex flex-col">
	<div class=" flex justify-between text-cyan-400 fill-cyan-400 font-semibold">
		<div class="flex items-center text-sm gap-2">
			<div class="w-4">
				<Sun />
			</div>
			{goalSuns}
		</div>
		<div>
			Level
			{goalLevel}
		</div>
	</div>

	<div
		class="whitespace-nowrap font-digital text-cyan-500 from-cyan-50 to-cyan-200 text-7xl font-bold text-center pt-[.45rem]"
		style="line-height:.8em"
	>
		{timeString(goalTime)}
	</div>

	<div class="flex items-center justify-center">
		<ActiveDays
			textSizeClass={'font-semibold'}
			activeDays={challengeDays}
			activeDayClass={'text-green-400 font-bold'}
			inactiveDayClass={'text-zinc-300'}
		/>
	</div>
</div>
