<script lang="ts">
	import Sun from '../icons/Sun.svelte';
	import EthSymbol from '../icons/EthSymbol.svelte';
	import Lock from '../icons/Lock.svelte';
	import { timeString } from '../util';
	import AlarmActiveDays from './ActiveDays.svelte';
	import ActiveDays from './ActiveDays.svelte';

	export let goal: {
		time: number;
		challengeDays: number[];
		suns: number;
		valueLocked: string;
		level: number;
	};

	let time = timeString(goal.time);
</script>

<div class="flex flex-col relative bg-gradient-to-r from-cyan-400 to-cyan-500 rounded-xl p-1">
	<div class="flex justify-between gap-1 items-center p-1 text-white">
		<div class="text-xs rounded-full font-semibold">Lvl 10</div>
		<div class="flex gap-1 items-center text-xs rounded-full font-semibold">
			42
			<div class="w-3 h-min fill-white">
				<Sun />
			</div>
		</div>
	</div>
	<div class="py-2">
		<div
			class="px-2 py-1 font-digital text-cyan-100 text-4xl font-bold text-center pt-1"
			style="line-height:1em"
		>
			{time}
		</div>
	</div>
	<div class="flex flex-col px-2">
		<ActiveDays activeDays={goal.challengeDays} />
	</div>
</div>
