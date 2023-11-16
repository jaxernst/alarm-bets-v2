<script lang="ts">
	import { writable } from 'svelte/store'
	import Plus from './Plus.svelte'
	import GradientCard from './design-sys/GradientCard.svelte'
	import { fade, scale, slide } from 'svelte/transition'
	import { cubicInOut, cubicOut } from 'svelte/easing'
	import { localTzOffsetHrs, parseTimeString, readableTimezone } from '$lib/util'
	import { mud } from '$lib/mud/mudStore'
	import Sun from '$lib/icons/Sun.svelte'
	import { onMount } from 'svelte'
	import { tweened } from 'svelte/motion'

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
			await new Promise((resolve) => setTimeout(resolve, 800))
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
<button on:click={() => (inputActive = true)} use:interactionListener>
	<GradientCard
		klass={` p-3 px-4 flex justify-between items-center transition-all duration-300 ease-in-out ${
			hovered || inputActive ? 'shadow-lg fill-cyan-50 text-cyan-50' : ''
		}`}
	>
		{#if submitLoading}
			<div class="fill-white w-5 animate-spin" transition:scale={{ delay: 100 }}>
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
					<div class="flex items-center">
						<div
							transition:slide
							class="flex flex-col w-full row-start-1 col-start-1 gap-3 overflow-hidden items-center"
						>
							<input
								type="text"
								placeholder="At what time would you like to wake up?"
								class={`self-stretch flex-grow font-semibold text-center bg-transparent placeholder-cyan-200 outline-none`}
								bind:value={$alarmTimeInput}
							/>
							{#if alarmTimeInputValid}
								<button
									transition:slide
									class={` ${
										readyToSubmit ? 'border border-green-300' : ''
									} transition-all flex-grow items-center justify-evenly min-w-[66%] oveflow-hidden px-2 bg-cyan-400 text-cyan-50 rounded-full`}
									on:click|stopPropagation={(e) => {
										timezoneConfirmed = true
									}}
								>
									<div class={` flex gap-2 justify-between py-1 px-2 items-center transition-all `}>
										{#if !timezoneConfirmed}
											<button class="text-center w-full" on:click={() => (timezoneConfirmed = true)}
												>Confirm your primary timezone</button
											>
										{:else}
											<button on:click={() => playerTimezoneOffset--} class="font-semibold"
												>{'<'}</button
											>
											<p class="overflow-auto text-sm text-center flex-grow">
												{readableTimezone(playerTimezoneOffset)}
											</p>
											<button on:click={() => playerTimezoneOffset++} class="font-semibold"
												>{'>'}</button
											>
										{/if}
									</div>
								</button>
							{/if}
						</div>
						{#if readyToSubmit}
							<button
								transition:slide={{ axis: 'x' }}
								on:click|stopPropagation={() => submitGoal()}
								class={`p-3 hover:bg-cyan-300 transition-all duration-150 rounded-full`}
							>
								<div
									transition:scale={{ easing: cubicInOut, delay: 50 }}
									class="w-5 animate-pulse fill-green-200"
								>
									<Plus />
								</div>
							</button>
						{/if}
					</div>
				{/if}
			</div>
		{/if}
	</GradientCard>
</button>
