<script lang="ts">
	import { mud } from '$lib/mud/mudStore'
	import { getComponentValueStrict, type Entity, getComponentValue } from '@latticexyz/recs'
	import { onMount } from 'svelte'
	import { formatTime, systemTimestamp, timeString, timeString24Hour } from '$lib/util'
	import Sun from '$lib/icons/Sun.svelte'
	import ChallengeCard from './ChallengeCard.svelte'
	import { challengeTypes } from '$lib/challengeTypes'
	import { fade } from 'svelte/transition'

	export let challenge: Entity

	const dayMap: any = {
		1: 'Su',
		2: 'M',
		3: 'Tu',
		4: 'W',
		5: 'Th',
		6: 'F',
		7: 'S'
	}

	$: [challengeType, expiration, days, sunsStaked, submissionWindow, numWakeups, targetWakeupGoal] =
		[
			getComponentValueStrict($mud.components.WakeupChallengeType, challenge).value,
			getComponentValue($mud.components.Expiration, challenge)?.value,
			getComponentValue($mud.components.DaysOfWeek, challenge)?.value,
			getComponentValue($mud.components.SunsStaked, challenge)?.value ?? 0,
			getComponentValueStrict($mud.components.SubmissionWindow, challenge)?.value,
			getComponentValueStrict($mud.components.WakeupConfirmations, challenge).value,
			getComponentValueStrict($mud.components.TargetWakeupObjective, challenge).value as Entity
		]

	$: challengeInfo = challengeTypes.find((type) => {
		return type.id === challengeType
	})

	$: console.log(challengeInfo)

	$: baseReward = getComponentValueStrict($mud.components.BaseReward, targetWakeupGoal).value
	$: sunBalance = (challengeInfo?.sunReward.amount ?? 0) * numWakeups - sunsStaked

	let timeToNextDeadline: null | number = null
	onMount(async () => {
		const dueTimestamp = await $mud.systemCalls.nextDeadlineTimestamp(challenge)
		setInterval(() => {
			const curTimestamp = systemTimestamp()
			timeToNextDeadline = dueTimestamp - curTimestamp
			if (timeToNextDeadline < 0) timeToNextDeadline = null
		}, 1000)
	})

	let challengeSubmitLoading = false
	let challengeSubmitError = ''
	let entrySubmitted = false
	const submitChallengeEntry = async () => {
		if (challengeInfo?.name !== 'Sun Staked Check In') throw 'Not implemented'

		challengeSubmitError = ''
		challengeSubmitLoading = true
		try {
			await $mud.systemCalls.recordEntry(challenge)

			entrySubmitted = true
		} catch (e) {
			challengeSubmitError = 'Error recording entry. Were you too late?'
		} finally {
			challengeSubmitLoading = false
		}
	}
</script>

<ChallengeCard>
	<div slot="header" class="w-full flex justify-between items-center">
		<div>
			<div class="font-bold text-cyan-600 text-lg">
				{challengeInfo?.name}
			</div>
			{#if timeToNextDeadline}
				<div class="text-xs px-2 text-zinc-400">Due in {formatTime(timeToNextDeadline)}...</div>
			{/if}
		</div>
		<div class="flex justify-center items-center font-semibold text-cyan-50 gap-2">
			{#if days}
				{#each days as day}
					<div
						class="w-6 h-6 flex items-center text-sm justify-center bg-gradient-to-r from-cyan-400 to-cyan-500 font-semibold rounded-full"
					>
						{dayMap[day]}
					</div>
				{/each}
			{:else}
				<div
					class="px-2 h-6 flex items-center text-sm justify-center bg-gradient-to-r from-cyan-400 to-cyan-500 font-semibold rounded-full"
				>
					Any Day
				</div>
			{/if}
			<div
				class={`flex gap-1 p-2 items-center text-base ${
					sunBalance > 0 ? 'text-green-500' : 'text-red-500'
				}`}
			>
				{sunBalance > 0 ? '+' : ''}{sunBalance}
				<div class="w-4 fill-cyan-400">
					<Sun />
				</div>
			</div>
		</div>
	</div>

	<div slot="description">
		{challengeInfo?.description}
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
					{(challengeInfo?.sunReward.amount ?? 0) + baseReward}
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
			{#if expiration}
				<div>
					<span class="font-semibold">Expiration:</span>{' '}{formatTime(
						Number(expiration) - systemTimestamp()
					)}
				</div>
			{/if}
		</div>

		<button
			class="py-1 px-2 self-center flex justify-center bg-gradient-to-r from-cyan-400 to-cyan-500 text-cyan-100 rounded-md font-semibold disabled:opacity-60"
			disabled={(timeToNextDeadline ?? 0) > submissionWindow || entrySubmitted}
			on:click={() => submitChallengeEntry()}
		>
			{#if challengeSubmitLoading}
				<div in:fade class="w-4 fill-cyan-50 py-1 animate-spin"><Sun /></div>
			{:else if entrySubmitted}
				Success!
			{:else if timeToNextDeadline}
				{#if timeToNextDeadline > submissionWindow}
					Wakeup in {formatTime(timeToNextDeadline - submissionWindow)}
				{:else}
					Submit Wakeup
				{/if}
			{/if}
		</button>
	</div>
</ChallengeCard>
