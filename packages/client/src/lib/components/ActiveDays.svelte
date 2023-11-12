<script lang="ts">
	export let activeDays: number[];
</script>

<div class="px-2 flex gap-2 text-xs font-semi py-1 justify-end">
	{#each ['Su', 'M', 'Tu', 'W', 'Th', 'Sa', 'Su'] as day, i}
		<div class={` ${activeDays.includes(i + 1) ? 'text-white font-bold' : 'text-cyan-300'}`}>
			{day}
		</div>
	{/each}
</div>
