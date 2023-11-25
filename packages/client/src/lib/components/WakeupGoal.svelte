<script lang="ts">
	import Sun from '../icons/Sun.svelte'
	import { timeString } from '../util'
	import ActiveDays from './ActiveDays.svelte'
	import { getComponentValueStrict, type Entity } from '@latticexyz/recs'
	import GradientCard from './design-sys/GradientCard.svelte'
	import { scale } from 'svelte/transition'
	import { userWakeupGoals, mud } from '$lib/mud/mudStore'

	export let open = false
	export let goal: Entity

	const [goalTime, goalLevel, goalSuns] = [
		getComponentValueStrict($mud.components.AlarmTime, goal).value,
		getComponentValueStrict($mud.components.Level, goal).value,
		getComponentValueStrict($mud.components.Suns, goal).value
	]

	export let onOpenFirstChallenge = () => {}

	let time = timeString(goalTime)
	let challengeDays: any[] = []
</script>

<div in:scale class="h-full w-full ${open ? '' : 'shadow-lg'} rounded-xl">
	<GradientCard klass={`flex flex-col ${open ? 'w-full h-full' : ''}`}>
		<div class="flex justify-between gap-1 items-center p-1 text-white">
			<div class="text-xs rounded-full font-semibold">Lvl {goalLevel}</div>
			<div class="flex gap-1 items-center text-xs rounded-full font-semibold">
				{goalSuns}
				<div class="w-3 h-min fill-white">
					<Sun />
				</div>
			</div>
		</div>
		<div class="py-1">
			<div
				class=" px-6 whitespace-nowrap py-1 font-digital text-cyan-100 text-4xl font-bold text-center pt-1"
				style="line-height:1em"
			>
				{time}
			</div>
		</div>
		<div class="self-center px-2 justify-center">
			<ActiveDays activeDays={challengeDays} />
		</div>

		{#if challengeDays.length === 0 && open}
			<div class="flex flex-col items-center gap-2 px-4 py-2 text-center">
				<p class="text-cyan-100 font-semibold">
					You have set a goal to wakeup at {time}.
				</p>

				<p class="text-sm text-cyan-200">
					Work towards this goal by entering into wakeup challenges. Complete challenges to earns
					Suns, level up your alarm goal, qualify for more challenges, and show off your progress.
				</p>

				<div class="pt-4 pb-3">
					<button
						on:click={onOpenFirstChallenge}
						class="rounded-xl bg-cyan-200 text-cyan-500 font-semibold text-sm p-2 hover:bg-cyan-50 transition-colors active:bg-cyan-400"
					>
						Enter your first challenge
					</button>
				</div>
			</div>
		{/if}
	</GradientCard>
</div>
