<script lang="ts">
	import { mud } from '$lib/mud/mudStore'
	import { getComponentValueStrict, type Entity } from '@latticexyz/recs'
	import CircularProgress from '../CircularProgress.svelte'
	import { onMount } from 'svelte'
	import { formatTime, systemTimestamp, timeString, timeString24Hour } from '$lib/util'
	import ActiveDays from '../ActiveDays.svelte'
	import Sun from '$lib/icons/Sun.svelte'
	import WakeupGoal from '../WakeupGoal.svelte'
	import ChallengeCard from './ChallengeCard.svelte'
	import { challengeTypes } from '$lib/challengeTypes'

	export let challenge: Entity

	$: [challengeName, targetWakeupGoal, expiration, days, sunsStaked, alarmSchedule] = [
		getComponentValueStrict($mud.components.ChallengeName, challenge).value,
		getComponentValueStrict($mud.components.TargetWakeupObjective, challenge).value,
		Number(getComponentValueStrict($mud.components.ExpirationTime, challenge).value),
		getComponentValueStrict($mud.components.ChallengeDays, challenge).value,
		getComponentValueStrict($mud.components.SunsStaked, challenge).value,
		getComponentValueStrict($mud.components.AlarmSchedule, challenge)
	]

	$: challengeInfo = challengeTypes.find((type) => {
		return type.name === challengeName
	})

	$: console.log(challengeInfo)

	$: submissionWindow = alarmSchedule.submissionWindow
	$: numWakeups = alarmSchedule.alarmEntries

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

	const dayMap: any = {
		1: 'Su',
		2: 'M',
		3: 'Tu',
		4: 'W',
		5: 'Th',
		6: 'F',
		7: 'S'
	}

	let timeToNextDeadline: null | number = null
	onMount(async () => {
		const dueTimestamp = await $mud.systemCalls.nextDeadlineTimestamp(challenge)

		setInterval(() => {
			const curTimestamp = systemTimestamp()
			timeToNextDeadline = dueTimestamp - curTimestamp
		}, 1000)
	})
</script>

<ChallengeCard>
	<div slot="header" class="w-full flex justify-between items-center">
		<div>
			<div class="font-bold text-xl">
				{challengeName}
			</div>
			{#if timeToNextDeadline}
				<div class="text-xs px-2">Due in {formatTime(timeToNextDeadline)}...</div>
			{/if}
		</div>
		<div class="flex justify-center text-sm text-zinc-100 gap-1">
			{#each days as day}
				<div
					class="w-6 h-6 flex items-center justify-center text-sm bg-zinc-400 font-semibold rounded-full"
				>
					{dayMap[day]}
				</div>
			{/each}
		</div>
	</div>

	<div slot="description">
		Wakeup before your goal time and check in to earn suns on the days you selected. Missing a
		deadline results in lost Suns!
	</div>

	<div slot="details" class="flex flex-col gap-3">
		<div class="flex flex-wrap gap-4 justify-center fill-cyan-500">
			<div class="flex gap-1 items-center">
				<div class="text-cyan-500 font-semibold">
					{sunsStaked}
				</div>
				<span><div class="w-3"><Sun /></div></span>
				staked
			</div>
			<div class="flex items-center gap-1">
				<div class="text-cyan-500 font-semibold">
					{challengeInfo?.sunReward.amount}
				</div>
				<span><div class="w-3"><Sun /></div></span>
				next reward
			</div>
			<div class="flex items-center gap-1">
				<div class="text-cyan-500 font-semibold">
					{numWakeups}
				</div>
				wakeups confirmed
			</div>
		</div>
		<div class="flex flex-col gap-2 py-2 px-1 text-sm fill-cyan-400">
			<div>
				<span class="font-semibold">Submission window:</span>{' '}{Math.floor(
					submissionWindow / 60
				)} minutes before deadline
			</div>
			<div>
				<span class="font-semibold">Expiration:</span>{' '}{formatTime(
					expiration - systemTimestamp()
				)}
			</div>
		</div>

		<button
			class="py-1 px-2 self-center bg-gradient-to-r from-cyan-300 to-cyan-500 text-cyan-100 rounded font-semibold disabled:opacity-60"
			disabled={(timeToNextDeadline ?? 0) > submissionWindow}
			on:click={() => $mud.systemCalls.recordEntry(challenge)}
		>
			Wakeup
		</button>
	</div>
</ChallengeCard>
