<script lang="ts">
	import ChevronUpDown from '$lib/icons/ChevronUpDown.svelte'
	import Sun from '$lib/icons/Sun.svelte'
	import { fade, scale, slide } from 'svelte/transition'
	import type { Challenge } from './types'
	import { cubicInOut, quintInOut } from 'svelte/easing'
	import type { Entity } from '@latticexyz/recs'
	import Lock from '$lib/icons/Lock.svelte'
	import { mud, user } from '$lib/mud/mudStore'
	import { formatTime, timeString } from '$lib/util'
	import ActiveDaysInput from '../ActiveDaysInput.svelte'
	import { writable } from 'svelte/store'
	import { userWakeupGoals } from '$lib/mud/mudStore'

	export let challenge: Challenge
	export let wakeupGoals: { id: Entity; level: number; time: number; sunBalance: bigint }[]

	$: maxWakeupObjectiveLevel = Math.max(...wakeupGoals.map((goal) => goal.level))
	$: qualifies = challenge.requiredLevel <= maxWakeupObjectiveLevel

	const selectedGoal = writable<(typeof wakeupGoals)[number]>(wakeupGoals[0])
	const joinChallengeDays = writable<number[]>([])
	const joinChallengeWeeks = writable<number>(1)

	$: costSuns = challenge.entryCost * $joinChallengeWeeks * $joinChallengeDays.length

	$: joinReady =
		$selectedGoal.level >= challenge.requiredLevel &&
		$selectedGoal.sunBalance >= costSuns &&
		$joinChallengeDays.length > 0 &&
		$joinChallengeWeeks > 0

	let enterChallengeLoading = false
	let enterChallengeError = ''
	const enterChallenge = async () => {
		enterChallengeLoading = true
		enterChallengeError = ''
		try {
			await $mud.systemCalls.enterDailyCheckInChallenge(
				$selectedGoal.id,
				$joinChallengeDays,
				$joinChallengeWeeks
			)
		} catch (e: any) {
			enterChallengeError = e.message ?? 'Unknown error'
		} finally {
			enterChallengeLoading = false
		}
	}
</script>

<div in:fade class="flex w-full flex-col gap-3 rounded-lg border-zinc-400 bg-slate-50 p-2 text-sm">
	<div class="flex items-center justify-between gap-4 font-semibold">
		<div class="text-lg font-bold text-cyan-600">{challenge.name}</div>
		<div
			class={`py-1 ${
				qualifies
					? 'bg-cyan-600 stroke-cyan-50 text-cyan-50'
					: 'bg-zinc-200 stroke-zinc-400 text-zinc-400'
			} flex items-center gap-1 rounded-full px-2`}
		>
			<span class="w-3"><Lock /></span>Level {challenge.requiredLevel}
		</div>
	</div>
	<div class="flex flex-col gap-1">
		<div class="flex gap-3 self-start">
			Reward:
			<div class="flex items-center gap-1 text-sm text-green-500">
				+{challenge.reward}
				<div class="w-3 fill-cyan-400"><Sun /></div>
				/ day
			</div>
		</div>
		<div class="flex gap-3 self-start">
			Entry cost:
			<div class="flex items-center gap-1 text-sm text-red-600">
				{challenge.entryCost}
				<div class="w-3 fill-cyan-400"><Sun /></div>
				/ day
			</div>
		</div>
	</div>
	<div
		in:slide={{ delay: 100, easing: cubicInOut }}
		class="flex w-full justify-center gap-2 rounded-lg bg-zinc-100 p-2"
	>
		<div class="whitespace-normal text-center">
			{challenge.description}
		</div>
	</div>

	{#if qualifies}
		<div class="flex flex-col gap-1">
			<div class="flex items-center gap-3">
				Target Goal:
				{#each wakeupGoals as goal}
					<button
						on:click={() => ($selectedGoal.id = goal.id)}
						disabled={$selectedGoal.id === goal.id}
						class="rounded-full bg-zinc-200 px-1 text-white transition-all disabled:bg-cyan-600 disabled:font-semibold"
						>{timeString(goal.time)}</button
					>
				{/each}
			</div>
			<div class="flex items-center gap-3">
				Choose days:
				<ActiveDaysInput
					activeDayClass={'rounded-full bg-cyan-600 text-white font-bold px-1'}
					inactiveDayClass={''}
					onDaysChanged={(days) => ($joinChallengeDays = days)}
				/>
			</div>
			<div class="flex items-center gap-3">
				Choose duration:
				<input
					type="number"
					min={1}
					bind:value={$joinChallengeWeeks}
					class="w-[45px]  rounded-lg bg-zinc-100 text-center"
				/>
				week(s)
			</div>
		</div>
		<div class="self-center py-2">
			<button
				on:click={enterChallenge}
				disabled={!joinReady}
				class={`px-2 py-1 flex items-center gap-2 rounded-lg bg-cyan-600 transition-all font-semibold text-white 
					${!joinReady ? 'opacity-75' : 'hover:bg-cyan-400 hover:scale-105'}
				`}
			>
				{#if enterChallengeLoading}
					<div class="w-4 h-4 fill-white animate-spin"><Sun /></div>
				{:else}
					<div
						class={`flex items-center gap-1 ${
							$selectedGoal.sunBalance < costSuns ? 'text-red-600' : 'text-white '
						}`}
					>
						{costSuns}
						<div class="w-3 fill-white"><Sun /></div>
					</div>
					|
					<div class=" text-center">Enter Challenge</div>
				{/if}
			</button>
		</div>
	{:else}
		<div class="text-center font-light text-red-600">
			You must reach level {challenge.requiredLevel} to enter this challenge
		</div>
	{/if}
</div>
