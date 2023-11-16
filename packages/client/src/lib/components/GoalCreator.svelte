<script lang="ts">
	import { writable } from 'svelte/store'
	import Plus from './Plus.svelte'
	import GradientCard from './design-sys/GradientCard.svelte'
	import { fade, scale, slide } from 'svelte/transition'
	import { cubicInOut } from 'svelte/easing'
	import { localTzOffsetHrs, parseTimeString, readableTimezone } from '$lib/util'
	import { mud } from '$lib/mud/mudStore'
	import Sun from '$lib/icons/Sun.svelte'
	import { onMount } from 'svelte'

	export let onGoalCreated = () => {}
	export let onClose = () => {}
	export let firstGoal = false

	const deferClickOutsideDuration = 300
	const mountTime = Date.now()

	let inputActive = false
	let hovered = false

	function interactionListener(node: HTMLElement) {
		const handleMouseover = () => (hovered = true)
		const handleMouseout = () => (hovered = false)
		const handleClickOutside = (event) => {
			if (Date.now() - mountTime < deferClickOutsideDuration) {
				return
			}
			if (!node.contains(event.target)) {
				inputActive = false
				onClose()
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
			inputActive = false
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
			<div class=" w-5 animate-spin" transition:fade={{ delay: 370 }}>
				<Sun />
			</div>
		{:else}
			<div class="grid grid-rows-1 w-full">
				{#if !inputActive}
					<div
						transition:slide
						class={`grid col-start-1 grid-cols-[1fr_auto_1fr] items-center w-full`}
					>
						<div />
						<button class="grid-cols-1 w-full text-center"> Create a new wakeup goal </button>
						<div class="w-3 fill-cyan-200 justify-self-end">
							<Plus />
						</div>
					</div>
				{:else}
					<div transition:slide class="flex row-start-1 col-start-1 gap-3 items-center">
						<input
							type="text"
							placeholder="At what time would you like to wake up?"
							class="grid-cols-1 font-semibold text-center w-full bg-transparent placeholder-cyan-200 outline-none"
							bind:value={$alarmTimeInput}
						/>
						{#if alarmTimeInputValid}
							<div
								class="flex justify-evenly items-center px-2 bg-cyan-400 text-cyan-50 rounded-full"
								in:slide={{ axis: 'x', easing: cubicInOut }}
								on:click|preventDefault|stopPropagation={(e) => {
									timezoneConfirmed = true
								}}
							>
								{#if !timezoneConfirmed}
									<button class=" whitespace-nowrap text-center py-1 px-2 text-sm">
										Confirm your primary timezone
									</button>
								{:else}
									<div
										transition:slide={{ axis: 'x' }}
										class="min-w-[150px] flex grid-col-1 justify-between items-center gap-1"
									>
										<button on:click={() => playerTimezoneOffset--} class="px-2 font-semibold"
											>{'<'}</button
										>
										<p class="text-center min-w-[240px] py-1 px-2 text-sm">
											{readableTimezone(playerTimezoneOffset)}
										</p>
										<button on:click={() => playerTimezoneOffset++} class="px-2 font-semibold"
											>{'>'}</button
										>
									</div>
								{/if}
							</div>
						{/if}
						{#if readyToSubmit}
							<button
								on:click={() => submitGoal()}
								class={`w-10 first-letter:animate-pulse`}
								transition:slide
							>
								<div class="w-3 fill-green-300">
									<Plus />
								</div>
							</button>
						{/if}
					</div>
				{/if}
			</div>
		{/if}
	</GradientCard>
</div>
