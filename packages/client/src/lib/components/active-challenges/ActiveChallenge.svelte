<script lang="ts">
	import { mud } from '$lib/mud/mudStore'
	import { getComponentValueStrict, type Entity } from '@latticexyz/recs'
	import CircularProgress from '../CircularProgress.svelte'
	import { onMount } from 'svelte'
	import { timeString } from '$lib/util'
	import ActiveDays from '../ActiveDays.svelte'
	import Sun from '$lib/icons/Sun.svelte'

	export let challenge: Entity

	$: [challengeName, targetWakeupGoal, startTime, expiration, days, sunsStaked] = [
		getComponentValueStrict($mud.components.ChallengeName, challenge).value,
		getComponentValueStrict($mud.components.TargetWakeupObjective, challenge).value,
		Number(getComponentValueStrict($mud.components.StartTime, challenge).value),
		Number(getComponentValueStrict($mud.components.ExpirationTime, challenge).value),
		getComponentValueStrict($mud.components.ChallengeDays, challenge).value,
		getComponentValueStrict($mud.components.SunsStaked, challenge).value
	]

	$: targetWakeupGoalTime = getComponentValueStrict(
		$mud.components.AlarmTime,
		targetWakeupGoal as Entity
	).value

	let lastBlockTimestamp = 0
	const lastBlockNumber = async () => {
		const lastBlock = await $mud.network.publicClient.getBlock()
		lastBlockTimestamp = Number(lastBlock.timestamp)
	}
	onMount(() => {
		setInterval(async () => {}, 3000)
	})

	$: console.log(challengeName, startTime, expiration)

	const dayMap: any = {
		1: 'Su',
		2: 'M',
		3: 'Tu',
		4: 'W',
		5: 'Th',
		6: 'F',
		7: 'S'
	}
</script>

<div
	class="p-3 flex flex-col items-center text-lg bg-zinc-100 text-zinc-400 min-w-[200px] rounded-lg first:border-2 border-cyan-200"
>
	<div class="w-full flex justify-between items-center">
		<div class="text-center font-digital text-2xl pt-[.2rem]" style="line-height:.8em">
			{timeString(targetWakeupGoalTime)}
		</div>
		<div class="flex justify-center text-sm text-zinc-100 gap-1">
			{#each days as day}
				<div class="bg-zinc-600 font-semibold bg-opacity-50 text-sm rounded-full w-5 text-center">
					{dayMap[day]}
				</div>
			{/each}
		</div>
	</div>

	<div class="font-bold text-xl py-3">
		{challengeName}
	</div>

	<div class="flex flex-col items-center gap-2 py-2 px-1 text-sm fill-cyan-400">
		<div class="flex items-center gap-1">
			Staked: {sunsStaked}
			<span><div class="w-3"><Sun /></div></span>
		</div>
		<div>Submission window: 15min</div>
	</div>

	<div class="bg-zinc-200 bg-opacity-70 p-2 rounded-lg">
		<div>Next alarm in 59 minutes...</div>
		<div>Check in before 6:00am to earn 1 sun</div>
	</div>
</div>
