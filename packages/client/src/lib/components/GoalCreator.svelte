<script lang="ts">
	import { writable } from 'svelte/store'
	import Plus from './Plus.svelte'
	import GradientCard from './design-sys/GradientCard.svelte'
	import { fade, slide } from 'svelte/transition'
	import { localTzOffsetHrs, parseTimeString, readableTimezone } from '$lib/util'
	import { mud } from '$lib/mud/mudStore'
	import Sun from '$lib/icons/Sun.svelte'

	export let onGoalCreated = () => {}

	let inputActive = false
	let hovered = false

	function interactionListener(node: HTMLElement) {
		const handleMouseover = () => (hovered = true)
		const handleMouseout = () => (hovered = false)
		const handleClickOutside = (event) => {
			if (!node.contains(event.target)) {
				inputActive = false
				console.log('click outside')
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

	const alarmTimeInput = writable('')

	let playerTimezoneOffset = localTzOffsetHrs()
	let timezoneConfirmed = false
	let alarmTimeInputValid = false

	$: readyToSubmit = alarmTimeInputValid && timezoneConfirmed

	// Debounce input validation
	let debounceTimer: NodeJS.Timeout
	$: {
		if (debounceTimer) {
			clearTimeout(debounceTimer)
		}

		debounceTimer = setTimeout(() => {
			alarmTimeInputValid = $alarmTimeInput.includes(':') && $alarmTimeInput.length >= 6
		}, 500)
	}

	let submitLoading = false
	const submitGoal = async () => {
		const alarmTime = parseTimeString($alarmTimeInput)
		submitLoading = true
		try {
			await new Promise((resolve) => setTimeout(resolve, 500))
			await $mud.systemCalls.createWakeupObjective(alarmTime, playerTimezoneOffset)
			onGoalCreated()
		} catch (e) {
			console.error(e)
		} finally {
			submitLoading = false
		}
	}
</script>

<!-- svelte-ignore a11y-click-events-have-key-events -->
<div on:click={() => (inputActive = true)} use:interactionListener>
	<GradientCard
		klass={` p-3 px-4 flex justify-between items-center transition-all duration-300 ease-in-out ${
			hovered || inputActive ? 'shadow-lg fill-cyan-50 text-cyan-50' : ''
		}`}
	>
		{#if submitLoading}
			<div class=" w-5 animate-spin" in:fade={{ delay: 370 }}>
				<Sun />
			</div>
		{:else}
			<div class="grid grid-rows-1 w-full">
				{#if !inputActive}
					<button out:slide class="grid-cols-1 w-full text-center"
						>Create your first wakeup goal</button
					>
				{:else}
					<input
						transition:slide
						type="text"
						placeholder="At what time would you like to wake up?"
						class="grid-cols-1 font-semibold text-center w-full bg-transparent placeholder-cyan-200 outline-none"
						bind:value={$alarmTimeInput}
					/>
					{#if alarmTimeInputValid}
						<div
							class="grid grid-rows-1 justify-center pt-2 pb-1"
							transition:slide
							on:click|preventDefault|stopPropagation={(e) => {
								timezoneConfirmed = true
							}}
						>
							{#if !timezoneConfirmed}
								<button
									in:fade
									class="grid-col-1 text-center text-cyan-50 py-1 px-2 text-sm bg-cyan-400 rounded-full"
								>
									Confirm your primary timezone
								</button>
							{:else}
								<div
									class="flex grid-col-1 justify-between items-center gap-1 bg-cyan-400 rounded-full"
								>
									<button on:click={() => playerTimezoneOffset--} class="px-2 font-semibold"
										>{'<'}</button
									>
									<p in:fade class="text-center min-w-[250px] text-cyan-50 py-1 px-2 text-sm">
										{readableTimezone(playerTimezoneOffset)}
									</p>
									<button on:click={() => playerTimezoneOffset++} class="px-2 font-semibold"
										>{'>'}</button
									>
								</div>
							{/if}
						</div>
					{/if}
				{/if}
			</div>

			<button
				on:click={() => (!inputActive ? (inputActive = true) : readyToSubmit ? submitGoal() : null)}
				class={`fill-cyan-200 ${readyToSubmit && inputActive ? 'w-5 animate-pulse' : 'w-3'}`}
			>
				<Plus />
			</button>
		{/if}
	</GradientCard>
</div>
