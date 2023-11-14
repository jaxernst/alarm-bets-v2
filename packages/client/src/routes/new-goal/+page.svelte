<script lang="ts">
	import { localTzOffsetHrs, timeString, timeString24Hour, timeStringToSeconds } from '$lib/util';
	import { mud } from '$lib/mud/mudStore';
	import { writable } from 'svelte/store';
	import Sun from '$lib/icons/Sun.svelte';

	let playerTimezoneOffset = localTzOffsetHrs();
	let alarmTime = writable('08:30');

	const readableTimezone = (offset: number) => {
		let localTimezone;
		if (offset === localTzOffsetHrs()) {
			localTimezone = Intl.DateTimeFormat().resolvedOptions().timeZone;
		}
		return `UTC${offset >= 0 ? `+${offset}` : offset} (${localTimezone ?? 'non-local'}) `;
	};

	let loading = false;
	let error = '';
	$: create = async () => {
		error = '';
		loading = true;
		await new Promise((r) => setTimeout(r, 1000));
		try {
			await $mud.systemCalls.createWakeupObjective(
				timeStringToSeconds($alarmTime),
				playerTimezoneOffset
			);
		} catch (e) {
			console.error(e);
			error = 'Contract execution error';
		} finally {
			loading = false;
		}
	};
</script>

<div class="flex flex-col h-full gap-2 px-2">
	<h1 class="p-2 text-cyan-600 font-semibold text-lg">Create a new Alarm Goal</h1>
	<p class="px-4 text-cyan-400">
		This goal represents your commitment to wakeup at your choosen time. Alarm Goals are pulbic and
		viewable by anyone
	</p>

	<div class="p-6 flex flex-col gap-6 text-zinc-400 justify-center ">
		Wakeup Time
		<input
			class=" text-cyan-600 rounded-xl bg-transparent p-4 self-center min-w-[200px]"
			type="time"
			bind:value={$alarmTime}
		/>
		Player Timezone
		<div class="flex text-cyan-600 items-center gap-1 self-center ">
			<button
				class="bg-zinc-200 rounded p-1 focus:border active:bg-zinc-400"
				style="line-height: .5"
				on:click={() => playerTimezoneOffset--}>-</button
			>
			<button
				class="bg-zinc-200 rounded p-1 focus:border focus:border-zinc-300 active:bg-zinc-400"
				style="line-height: .5"
				on:click={() => playerTimezoneOffset++}>+</button
			>
			<p class="whitespace-nowrap px-1 text-sm">
				Timezone: {readableTimezone(playerTimezoneOffset)}
			</p>
		</div>
	</div>
	<div class="self-center py-6 gap-2 justify-center">
		<button
			on:click={create}
			class="flex justify-center items-center gap-2 px-4 py-1 text-cyan-200 bg-cyan-600 hover:bg-cyan-400 active:bg-cyan-700 transition-all rounded-lg"
		>
			Create
			{#if loading}
				<p class="animate-spin w-4 fill-cyan-200"><Sun /></p>
			{/if}
		</button>
	</div>
	{#if error}
		<p class="text-red-500">{error}</p>
	{/if}
</div>
