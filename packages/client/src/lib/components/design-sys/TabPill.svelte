<script>
	import { fade } from 'svelte/transition'

	export let active = false
	export let activeClass = 'bg-cyan-500 text-cyan-50 shadow'
	export let inactiveClass = ''
	export let paddingClass = 'px-2 py-1'
</script>

<button
	transition:fade
	on:click
	class={`rounded-full text-sm whitespace-nowrap font-semibold transition-color duration-200 ${paddingClass} ${
		active ? activeClass : inactiveClass
	}`}
>
	<slot />
</button>
