<script>
	import EthSymbol from '$lib/icons/EthSymbol.svelte';
	import Sun from '$lib/icons/Sun.svelte';
	import Wallet from '$lib/icons/Wallet.svelte';
	import Lock from '$lib/icons/Lock.svelte';
	import WakeupGoal from '$lib/components/WakeupGoal.svelte';
	import NavBar from './components/NavBar.svelte';
	import ChallengeCard from './components/ChallengeCard.svelte';
	import ChallengeTimeline from './components/ChallengeTimeline.svelte';

	const wakeupGoals = [
		{
			time: 8000,
			challengeDays: [1, 2, 3, 4],
			suns: 50,
			valueLocked: '0',
			level: 1
		},
		{
			time: 15000,
			challengeDays: [3, 4, 5],
			sunRating: 12,
			suns: 12,
			valueLocked: '0',
			level: 1
		}
	];

	const activeDays = new Set(['M', 'T', 'W', 'Th']);
</script>

<div class="h-full px-2 flex flex-col gap-6">
	<div class="w-full px-2">
		<div class="text-sm py-2 text-cyan-500 flex justify-between">
			Wakeup Goals
			<div class="text-base">+</div>
		</div>
		{#if wakeupGoals.length === 0}
			Create new wakeup goal...
		{:else}
			<div class="flex gap-2">
				{#each wakeupGoals as goal}
					<WakeupGoal {goal} />
				{/each}
			</div>
		{/if}
	</div>

	<div class="p-2 flex flex-col flex-grow gap-2 items-stretch overflow-hidden">
		<div class="flex items-center justify-between text-cyan-500">
			<div class="text-sm">Upcoming Challenges</div>
			<div>+</div>
		</div>
		<div class="overflow-y-auto">
			<ChallengeTimeline />
		</div>
	</div>
</div>

<style>
	.days-row {
		display: inline-flex;
		flex-wrap: wrap;
		flex-direction: row;
		font-size: 1em;
		justify-content: space-evenly;
	}

	.day {
		padding: 0 0.3em 0 0.3em;
		color: rgb(161 161 170);
		opacity: 0.3;
	}

	.today {
		border-bottom: 0.1em solid white;
		opacity: 1;
	}

	.active {
		opacity: 1;
		color: var(--active-color);
	}
</style>
