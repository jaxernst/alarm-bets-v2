<script>
	import Sun from '$lib/icons/Sun.svelte'
	import { flip } from 'svelte/animate'
	import AvailableChallengeExpandedCard from './AvailableChallengeExpandedCard.svelte'
	import AvailableChallengeOverviewCard from './AvailableChallengeOverviewCard.svelte'
	import { derived, writable } from 'svelte/store'
	import { cubicInOut, cubicOut } from 'svelte/easing'

	const availableChallenges = [
		{
			id: '1',
			name: 'Daily Check in',
			reward: 10,
			entryCost: 6,
			requiredLevel: 1,
			description:
				'Wakeup before your wakeup goal time and check in to earn suns. If you miss your wakeup on the days you select, no reward is given'
		},
		{
			id: '2',
			name: 'Donation check in',
			reward: 20,
			entryCost: 0,
			staked: true,
			penalty: 0.001,
			requiredLevel: 2,
			description:
				'Wakeup and check inbefore your goal time, else a portion of your stake is donated to any address of your choice'
		},
		{
			id: '3',
			name: 'Wakeup puzzle',
			reward: 30,
			entryCost: 20,
			staked: false,
			requiredLevel: 3,
			description: 'Wakeup and solve a puzzle before your goal time to earn suns'
		},
		{
			id: '4',
			name: 'Check-in bet (1v1)',
			reward: 40,
			entryCost: 30,
			staked: true,
			stakeAmount: 'variable',
			requiredLevel: 5,
			description:
				'Enter a 1v1 staked bet with another player. If any player misses their check in during the challenge, the other player wins the stake'
		}
	]

	const selectedId = writable('')

	// Derived store to reorder challenges
	const reorderedChallenges = derived(
		// Reactive dependency
		selectedId,
		// Computation function
		($selectedId) => {
			if (!$selectedId) return availableChallenges
			const selectedChallenge = availableChallenges.find((c) => c.id === $selectedId)
			const otherChallenges = availableChallenges.filter((c) => c.id !== $selectedId)
			return [selectedChallenge, ...otherChallenges]
		}
	)
</script>

<div class="flex flex-wrap gap-2 bg-zinc-100 p-2 rounded-xl w-full items-start text-zinc-400 px-2">
	{#each $reorderedChallenges as challenge (challenge?.id)}
		<div animate:flip={{ duration: 300 }} class={`${$selectedId === challenge.id ? 'w-full' : ''}`}>
			{#if challenge}
				{#if challenge.id === $selectedId}
					<AvailableChallengeExpandedCard {challenge} />
				{:else}
					<AvailableChallengeOverviewCard
						on:click={() => ($selectedId = challenge.id)}
						{challenge}
					/>
				{/if}
			{/if}
		</div>
	{/each}
</div>
