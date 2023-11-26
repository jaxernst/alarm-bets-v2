<script>
	export let progress
	const angle = 360 * progress

	// Adapt the logic according to the approach
	const background = `radial-gradient(white 50%, transparent 51%),
    conic-gradient(transparent 0deg ${angle}deg, gainsboro ${angle}deg 360deg),
    conic-gradient(orange 0deg, yellow 90deg, lightgreen 180deg, green);`

	$: cssVarStyles = `--background:${background}`
</script>

<div
	id="progress-circle"
	class="flex justify-center items-center aspect-square w-[110px]"
	style={cssVarStyles}
>
	<slot />
</div>

<style>
	#progress-circle {
		background: var(--background);
		border-radius: 50%;
		transition: all 500ms ease-in;
		will-change: transform;
	}
</style>
