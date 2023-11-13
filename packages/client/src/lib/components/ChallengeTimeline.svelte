<script lang="ts">
	import Sun from '$lib/icons/Sun.svelte';
	import { timeString } from '$lib/util';

	type Challenge = {
		id: number;
		days: number[];
		time: number;
		title: string;
		sunReward: number;
		sunPenalty: number;
		ethPenalty: number;
	};

	export let challenges: Challenge[];

	// Make an array that stores the formatted date strings with the same order as the days array

	let groupedChallenges = challenges.reduce((grouped, current, i) => {
		current.days.forEach((day) => {
			if (!grouped[day]) grouped[day] = [];
			grouped[day].push(current);
		});

		return grouped;
	}, {} as Record<number, Challenge[]>);

	// Function to add days to a date
	function addDays(date: Date, days: number): Date {
		let result = new Date(date);
		result.setDate(result.getDate() + days);
		return result;
	}

	const dayOfWeek = new Date().getDay();
	const dayStrings = ['Sun', 'Mon', 'Tues', 'Wed', 'Thurs', 'Fri', 'Sat'];
	const upcomingDays = dayStrings.slice(dayOfWeek).concat(dayStrings.slice(0, dayOfWeek));

	// Generate the date strings for the current week
	let groupedUpcomingDayLabels = upcomingDays.map((dayName, index) => {
		let today = new Date();
		let dayDiff = index - today.getDay();
		let date = addDays(today, dayDiff);
		return `${dayName}, ${date.toLocaleDateString('en-US', { month: 'short', day: 'numeric' })}`;
	});

	let selected: any;
</script>

<div class="flex h-full py-2 gap-2 justify-between">
	<div class="flex-grow overflow-y-auto">
		{#each groupedUpcomingDayLabels as dayString, i}
			{#if groupedChallenges[i + 1]}
				<div class="flex justify-between text-cyan-400 text-sm">
					{dayString}
				</div>
				{#each groupedChallenges[i + 1] as challenge, ii}
					<div
						class={`flex justify-between items-center rounded-xl p-2 my-2 ${
							ii === selected ? 'border border-cyan-600 roundex lg' : ''
						}`}
					>
						<div class="flex flex-col">
							<div class="text-cyan-600 font-semibold">{timeString(challenge.time)}</div>
							<div class="text-zinc-400 flex gap-1 items-center font-semibold">
								{challenge.title}
							</div>
						</div>
						<div class="flex self-start gap-3">
							<div class="flex gap-2 items-center text-sm text-green-500">
								+{challenge.sunReward}
								<div class="w-3 fill-cyan-400"><Sun /></div>
							</div>
							<div class="flex gap-2 items-center text-sm text-red-600">
								-{challenge.sunPenalty}
								<div class="w-3 fill-cyan-400"><Sun /></div>
							</div>
						</div>
					</div>
				{/each}
			{/if}
		{/each}
	</div>
</div>
