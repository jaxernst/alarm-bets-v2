<script>
	import Sun from '$lib/icons/Sun.svelte';

	let selected = false;
</script>

<div class={`flex flex-col gap-3 bg-zinc-100 shadow-lg p-2 rounded-xl w-full text-zinc-500 px-2`}>
	<div class="flex justify-between">
		<div>
			<div class="text-cyan-600 font-semibold">8:00am</div>
			<div class="text-zinc-400 flex gap-1 items-center font-semibold">Wakeup Check-in</div>
		</div>
		<div class="flex self-start gap-3">
			<div class="flex gap-2 items-center text-sm text-green-500">
				+10 <div class="w-3 fill-cyan-400"><Sun /></div>
			</div>
			<div class="flex gap-2 items-center text-sm text-red-600">
				-6 <div class="w-3 fill-cyan-400"><Sun /></div>
			</div>
		</div>
	</div>
	{#if selected}
		<div class="flex justify-end text-white">
			<div class="pt-2 text-zinc-400 pl-2 flex gap-1 items-center text-sm">
				Due in 2 hours and 29 minutes...
			</div>
			<div class="px-2 bg-cyan-400 text-white rounded-lg font-semibold">Check In</div>
		</div>
	{/if}
</div>
