<script>
	import { mud } from '$lib/mud/mudStore'
	import { Has, getComponentValueStrict, runQuery } from '@latticexyz/recs'
	import Sun from '$lib/icons/Sun.svelte'
	import { formatTime, timeString, shortenAddress } from '$lib/util'

	$: Suns = $mud.components.Suns
	$: Level = $mud.components.Level
	$: WakeupGoal = $mud.components.WakeupObjective
	$: AlarmTime = $mud.components.AlarmTime
	$: Creator = $mud.components.Creator

	$: entities = runQuery([Has(WakeupGoal), Has(Suns), Has(Level)])

	$: sortedWakeupGoals = Array.from(entities)
		.map((entity) => {
			return {
				suns: getComponentValueStrict(Suns, entity).value,
				level: getComponentValueStrict(Level, entity).value,
				alarmTime: getComponentValueStrict(AlarmTime, entity).value,
				owner: getComponentValueStrict(Creator, entity).value
			}
		})
		.sort((a, b) => {
			// Sort by level then suns
			if (a.level > b.level) return -1
			if (a.level < b.level) return 1
			if (a.suns > b.suns) return -1
			if (a.suns < b.suns) return 1
			return 0
		})
</script>

<div class="p-4">
	<div class="text-xl font-bold text-cyan-500">Leaderboard</div>
	<div class="p-4 flex flex-col text-zinc-500 gap-2 fill-cyan-400">
		{#each sortedWakeupGoals as { suns, level, alarmTime, owner }, i}
			<div class="flex justify-between items-center">
				<div class="font-semibold">{i}</div>
				<div class="bg-cyan-500 text-cyan-50 font-bold rounded-full px-2">
					Level {level}
				</div>
				<div>{shortenAddress(owner)}</div>
				<div class="text-cyan-600 font-semibold">{timeString(alarmTime)}</div>

				<div class="flex gap-1 items-center text-green-500 font-semibold">
					{suns}
					<div class="w-3"><Sun /></div>
				</div>
			</div>
		{/each}
	</div>
</div>
