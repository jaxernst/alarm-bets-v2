<script lang="ts">
	import Sun from '$lib/icons/Sun.svelte'
	import EthSymbol from '$lib/icons/EthSymbol.svelte'
	import { fade } from 'svelte/transition'
	import type { Challenge } from './types'

	export let challenge: Challenge
</script>

<button
	on:click
	in:fade={{ delay: 200, duration: 100 }}
	class="flex flex-col gap-2 rounded-lg bg-slate-50 items-center border-zinc-400 p-2 text-sm"
>
	<div class="bg-cyan-400 text-cyan-50 rounded-full px-2 text-xs">
		Lvl {challenge.requiredLevel}
	</div>
	<div class="font-semibold text-zinc-400">
		{challenge.name}
	</div>
	<div class="flex items-center gap-3">
		{#if challenge.staked}
			<div class="w-3 fill-cyan-400 "><EthSymbol /></div>
		{/if}
		<div class="flex gap-1 items-center text-sm text-green-500">
			+{challenge.reward}
			<div class="w-3 fill-cyan-400"><Sun /></div>
		</div>

		<div class="flex gap-1 items-center text-sm text-red-600">
			{challenge.entryCost}
			<div class="w-3 fill-cyan-400"><Sun /></div>
		</div>
	</div>
</button>
