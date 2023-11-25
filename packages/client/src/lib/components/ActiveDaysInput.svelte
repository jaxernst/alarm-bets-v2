<script lang="ts">
	export let activeDayClass = 'text-white font-bold'
	export let inactiveDayClass = 'text-cyan-300'

	let selectedDays: number[] = []
	export let onDaysChanged: (days: number[]) => void = () => {}

	const handleDayClick = (dayNum: number) => {
		if (selectedDays.includes(dayNum)) {
			selectedDays = selectedDays.filter((day) => day !== dayNum)
		} else {
			selectedDays = [...selectedDays, dayNum]
		}
		onDaysChanged(selectedDays)
	}
</script>

<div class="px-2 flex gap-2 text-xs font-semi py-1 justify-end">
	{#each ['Su', 'M', 'Tu', 'W', 'Th', 'Sa', 'Su'] as day, i}
		<button
			on:click={() => handleDayClick(i + 1)}
			class={`${selectedDays.includes(i + 1) ? activeDayClass : inactiveDayClass}`}
		>
			{day}
		</button>
	{/each}
</div>
