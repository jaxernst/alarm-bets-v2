<script lang="ts">
	export let activeDays: number[]
	export let activeDayClass = 'text-white font-bold'
	export let inactiveDayClass = 'text-cyan-300'
	export let textSizeClass = 'text-sm'
</script>

<div class={`flex gap-2 ${textSizeClass} font-semi justify-end`}>
	{#each ['Su', 'M', 'Tu', 'W', 'Th', 'Sa', 'Su'] as day, i}
		<div class={` ${activeDays.includes(i + 1) ? activeDayClass : inactiveDayClass}`}>
			{day}
		</div>
	{/each}
</div>
