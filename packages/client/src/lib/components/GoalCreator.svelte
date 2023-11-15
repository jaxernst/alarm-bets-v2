<script lang="ts">
	import { writable } from 'svelte/store'
	import Plus from './Plus.svelte'
	import GradientCard from './design-sys/GradientCard.svelte'
	import { slide } from 'svelte/transition'

	let inputActive = false
	let hovered = false

	function interactionListener(node) {
		function handleMouseover() {
			hovered = true
		}

		function handleMouseout() {
			hovered = false
		}

		function handleClickOutside(event) {
			if (!node.contains(event.target)) {
				inputActive = false
			}
		}

		node.addEventListener('mouseover', handleMouseover)
		node.addEventListener('mouseout', handleMouseout)
		document.addEventListener('click', handleClickOutside)

		return {
			destroy() {
				node.removeEventListener('mouseover', handleMouseover)
				node.removeEventListener('mouseout', handleMouseout)
				document.removeEventListener('click', handleClickOutside)
			}
		}
	}

	const textInput = writable('')
	let textinputValid = false
	let debounceTimer: NodeJS.Timeout
	$: {
		if (debounceTimer) {
			clearTimeout(debounceTimer)
		}

		debounceTimer = setTimeout(() => {
			textinputValid = $textInput.includes(':') && $textInput.length >= 6
		}, 500)
	}
</script>

<button on:click={() => (inputActive = true)} use:interactionListener>
	<GradientCard
		klass={`p-3 px-4 flex justify-between items-center fill-cyan-200 transition-all duration-300 ease-in-out ${
			hovered || inputActive ? 'shadow-lg fill-cyan-50 text-cyan-50' : ''
		}`}
	>
		<div class="grid grid-rows-1 w-full">
			{#if !inputActive}
				<p out:slide class="grid-cols-1 w-full text-center">Create your first wakeup goal</p>
			{:else}
				<input
					in:slide
					type="text"
					placeholder="Type in your target wakeup time... (00:00am)"
					class="grid-cols-1 text-center w-full bg-transparent placeholder-cyan-200 outline-none"
					bind:value={$textInput}
				/>
				{#if textinputValid}
					<div class="flex justify-center p-2" in:slide>
						<p class="text-center text-cyan-50 py-1 px-2 text-sm bg-cyan-300 rounded-full">
							Confirm your primary timezone
						</p>
					</div>
				{/if}
			{/if}
		</div>
		<div class="w-3">
			<Plus />
		</div>
	</GradientCard>
</button>
