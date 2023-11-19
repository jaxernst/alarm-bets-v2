<script>
	import { fade } from 'svelte/transition'

	export let active = false
</script>

<button
	transition:fade
	on:click
	class={`rounded-full text-sm whitespace-nowrap font-semibold transition-color duration-200 px-2 py-1 ${
		active ? 'bg-cyan-500 text-cyan-50' : ''
	}`}
>
	<slot />
</button>
