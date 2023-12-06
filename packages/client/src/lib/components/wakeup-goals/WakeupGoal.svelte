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

<div transition:fade class="flex items-center justify-evenly gap-4 rounded-xl py-6">
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
