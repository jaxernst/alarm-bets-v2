<script lang="ts">
	import type { ChallengeInfo } from '$lib/challengeTypes'
	import { getComponentValueStrict, type Entity } from '@latticexyz/recs'
	import ChallengeCard from './ChallengeCard.svelte'
	import { mud } from '$lib/mud/mudStore'
	import Sun from '$lib/icons/Sun.svelte'
	import ActiveDaysInput from '../ActiveDaysInput.svelte'
	import { timeString } from '$lib/util'
	import { fade } from 'svelte/transition'
	import EthSymbol from '$lib/icons/EthSymbol.svelte'

	export let challenge: ChallengeInfo
	export let wakeupGoal: Entity

	$: sunBalance = getComponentValueStrict($mud.components.Suns, wakeupGoal).value
	$: wakeupGoalTime = getComponentValueStrict($mud.components.AlarmTime, wakeupGoal).value
	$: wakeupGoalLevel = getComponentValueStrict($mud.components.Level, wakeupGoal).value
	$: qualifies = wakeupGoalLevel >= challenge.requiredLevel

	let daysSelected: number[] = []
	let numWeeks = 0

	$: sunEntryCost =
		challenge.sunEntryStake?.type === 'fixed'
			? daysSelected.length * numWeeks * (challenge.sunEntryStake.amount ?? 0)
			: 0

	let enterSuccess = false
	let enterChallengeLoading = false
	let enterChallengeError = ''
	const enterChallenge = async () => {
		enterChallengeLoading = true
		enterChallengeError = ''
		try {
			await $mud.systemCalls.enterDailyCheckInChallenge(wakeupGoal, daysSelected.sort(), numWeeks)
			enterSuccess = true
		} catch (e: any) {
			enterChallengeError = e.message ?? 'Unknown error'
		} finally {
			enterChallengeLoading = false
		}
	}
</script>

<ChallengeCard>
	<div
		slot="header"
		class={`flex flex-wrap justify-between gap-2 ${qualifies ? '' : 'opacity-60'}`}
	>
		<div class="flex gap-2">
			<div
				class={`flex items-center px-2 bg-gradient-to-r from-cyan-400 to-cyan-500 text-cyan-50 font-bold rounded-full text-xs sm:text-sm`}
			>
				{`Level ${challenge.requiredLevel}`}
			</div>
			<div class="font-bold">{challenge.name}</div>
		</div>
		<div class="flex gap-3 fill-cyan-500 text-base">
			<div class="flex gap-1 items-center text-green-500 font-semibold">
				+{challenge.sunReward.amount}
				<div class="w-3"><Sun /></div>
			</div>
			{#if challenge.sunEntryStake?.type === 'fixed'}
				<div class="flex gap-1 items-center text-red-500 font-semibold">
					-{challenge.sunEntryStake.amount}
					<div class="w-3"><Sun /></div>
				</div>
			{/if}
			{#if challenge.ethEntryStake}
				{#if challenge.ethEntryStake.type === 'variable'}
					<div class="flex gap-1 items-center text-red-500 font-semibold">
						<div class="w-4"><EthSymbol /></div>
					</div>
				{:else}
					<div class="flex gap-1 items-center text-red-500 font-semibold">
						-{challenge.ethEntryStake.amount}
						<div class="w-4"><EthSymbol /></div>
					</div>
				{/if}
			{/if}
		</div>
	</div>

	<div slot="description">
		{challenge.description}
	</div>

	<div slot="details" class="flex flex-col gap-1 fill-cyan-500">
		<div class="text-sm flex items-center gap-2">
			<span class="font-semibold">Entry stake: </span>
			{#if challenge.sunEntryStake}
				{#if challenge.sunEntryStake?.type === 'fixed'}
					<div class="flex gap-1 items-center">
						{challenge.sunEntryStake?.amount}
						<div class="w-3 fill-cyan-500"><Sun /></div>
						{'/ day'}
					</div>
				{:else}
					Variable
				{/if}
			{/if}
			{#if challenge.ethEntryStake}
				{#if challenge.ethEntryStake.type === 'variable'}
					<input
						type="number"
						value=".001"
						step=".001"
						min={challenge.ethEntryStake.minAmount}
						class="w-[80px] text-center bg-zinc-200 rounded"
					/>
				{:else}
					{challenge.ethEntryStake.amount}
				{/if}
				<div class="w-4"><EthSymbol /></div>
				{'($5.24)'}
			{/if}
		</div>
		<div class="text-sm flex gap-2">
			<span class="font-semibold">Reward: </span>
			<div class="flex gap-1 items-center">
				{challenge.sunReward.amount}
				<div class="w-3"><Sun /></div>
				{'/ day'}
			</div>
		</div>
		<div class="text-sm flex gap-2">
			<span class="font-semibold">Submission window:</span>
			{challenge.submissionWindowMin} minutes
		</div>
		<div class="text-sm flex gap-2 font-semibold">
			Choose challenge days:
			<ActiveDaysInput
				inactiveDayClass={'text-zinc-300'}
				activeDayClass={'text-cyan-50 bg-cyan-500 rounded-full px-1'}
				onDaysChanged={(days) => (daysSelected = days)}
			/>
		</div>
		<div class="text-sm flex gap-2 font-semibold">
			Choose duration:
			<input
				type="number"
				min="0"
				class="w-[30px] text-center bg-zinc-200 rounded"
				on:input={(e) => {
					// @ts-ignore
					numWeeks = e.target?.value
				}}
			/>
			weeks
		</div>
		<button
			on:click|stopPropagation={() => enterChallenge()}
			disabled={!daysSelected.length || !numWeeks || sunEntryCost > sunBalance || enterSuccess}
			class="mt-2 px-2 py-1 flex justify-center gap-1 bg-gradient-to-r from-cyan-400 to-cyan-400 text-cyan-50 rounded disabled:opacity-60 enabled:hover:shadow-md enabled:hover:to-cyan-400 transition-all"
		>
			{#if !enterChallengeLoading}
				{#if !enterSuccess}
					Enter <span class="font-semibold">{timeString(wakeupGoalTime)}</span>
					{challenge.name}
					{#if sunEntryCost}
						<div
							class={`flex items-center font-semibold ${
								sunEntryCost > sunBalance ? 'fill-red-500 text-red-500' : 'fill-cyan-50'
							}`}
						>
							({sunEntryCost}
							<div class="w-4 ml-1">
								<Sun />
							</div>
							)
						</div>
					{/if}
				{:else}
					Challenge entered successfully!
				{/if}
			{:else}
				<div in:fade class="w-4 fill-cyan-50 py-1 animate-spin"><Sun /></div>
			{/if}
		</button>
		{#if enterChallengeError}
			<div class="text-red-500">
				{enterChallengeError}
			</div>
		{/if}
	</div>
</ChallengeCard>
