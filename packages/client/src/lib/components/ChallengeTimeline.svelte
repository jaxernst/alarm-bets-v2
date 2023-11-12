<script>
	import Sun from '$lib/icons/Sun.svelte';

	let dayOfWeek = new Date().getDay();

	// Make an array that stores the formatted date strings with the same order as the days array

	const days = ['Su', 'M', 'T', 'W', 'Th', 'F', 'Sa'];

	let renderDays = days.slice(dayOfWeek).concat(days.slice(0, dayOfWeek));
	let dayShown = renderDays[0];

	const challenges = [
		{ day: 'Th', time: '8:00am', title: 'Wakeup Check-in', suns: 10, sunsLost: 6 },
		{ day: 'F', time: '8:00am', title: 'Wakeup Check-in', suns: 10, sunsLost: 6 },
		{ day: 'Sa', time: '8:00am', title: 'Wakeup Check-in', suns: 10, sunsLost: 6 },
		{ day: 'Su', time: '8:00am', title: 'Wakeup Check-in', suns: 10, sunsLost: 6 },
		{ day: 'M', time: '8:00am', title: 'Wakeup Check-in', suns: 10, sunsLost: 6 },
		{ day: 'Tu', time: '8:00am', title: 'Wakeup Check-in', suns: 10, sunsLost: 6 },
		{ day: 'W', time: '8:00am', title: 'Wakeup Check-in', suns: 10, sunsLost: 6 }
	];

	const challengeDays = ['M', 'T', 'W', 'F'];
</script>

<div class="flex h-full py-2 gap-2 justify-between">
	<div class="flex flex-col items-center justify-evenly bg-zinc-100 rounded-full">
		{#each renderDays as day, i}
			<div
				class={`px-1 text-sm rounded font-bold ${
					day === dayShown
						? 'bg-cyan-600 text-white'
						: challengeDays.includes(day)
						? 'text-cyan-400'
						: 'text-zinc-300'
				}
				`}
			>
				{day}
			</div>
		{/each}
	</div>
	<div class="flex-grow overflow-y-auto">
		{#each challenges as challenge}
			<div class="flex justify-between items-center rounded-xl p-2 my-2">
				<div class="flex flex-col">
					<div class="text-cyan-600 font-semibold">{challenge.time}</div>
					<div class="text-zinc-400 flex gap-1 items-center font-semibold">{challenge.title}</div>
				</div>
				<div class="flex self-start gap-3">
					<div class="flex gap-2 items-center text-sm text-green-500">
						+{challenge.suns}
						<div class="w-3 fill-cyan-400"><Sun /></div>
					</div>
					<div class="flex gap-2 items-center text-sm text-red-600">
						-{challenge.sunsLost}
						<div class="w-3 fill-cyan-400"><Sun /></div>
					</div>
				</div>
			</div>
		{/each}
	</div>
</div>
