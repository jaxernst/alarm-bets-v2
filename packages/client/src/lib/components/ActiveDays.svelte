<script lang="ts">
	export let activeDays: number[]
	export let activeDayClass = 'text-white font-bold'
	export let inactiveDayClass = 'text-cyan-300'
</script>

<div class="px-2 flex gap-2 text-xs font-semi py-1 justify-end">
	{#each ['Su', 'M', 'Tu', 'W', 'Th', 'Sa', 'Su'] as day, i}
		<div class={` ${activeDays.includes(i + 1) ? activeDayClass : inactiveDayClass}`}>
			{day}
		</div>
	{/each}
</div>
