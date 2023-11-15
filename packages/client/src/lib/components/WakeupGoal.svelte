<script lang="ts">
	import Sun from '../icons/Sun.svelte'
	import EthSymbol from '../icons/EthSymbol.svelte'
	import Lock from '../icons/Lock.svelte'
	import { timeString } from '../util'
	import AlarmActiveDays from './ActiveDays.svelte'
	import ActiveDays from './ActiveDays.svelte'
	import type { Entity } from '@latticexyz/recs'
	import GradientCard from './design-sys/GradientCard.svelte'

	export let open = false
	export let goal: {
		entity: Entity
		time: number
		suns: number
		level: number
	}

	let time = timeString(goal.time)
	let challengeDays = []
</script>

<GradientCard klass={`flex flex-col ${open ? 'w-full h-full' : ''}`}>
	<div class="flex justify-between gap-1 items-center p-1 text-white">
		<div class="text-xs rounded-full font-semibold">Lvl {goal.level}</div>
		<div class="flex gap-1 items-center text-xs rounded-full font-semibold">
			{goal.suns}
			<div class="w-3 h-min fill-white">
				<Sun />
			</div>
		</div>
	</div>
	<div class="py-1">
		<div
			class=" px-6 py-1 font-digital text-cyan-100 text-4xl font-bold text-center pt-1"
			style="line-height:1em"
		>
			{time}
		</div>
	</div>
	<div class="self-center px-2 justify-center ">
		{#if challengeDays.length > 0}
			<ActiveDays activeDays={challengeDays} />
		{:else}
			<div class="flex flex-col items-center gap-2 px-4 py-2 text-center">
				<p class="text-cyan-100 font-semibold">
					You have set a goal to wakeup at {time}.
				</p>

				<p class="text-sm text-cyan-200">
					Work towards this goal by entering into wakeup challenges. Complete challenges to earns
					Suns, level up your alarm goal, qualify for more challenges, and show off your progress.
				</p>

				<div class="pt-3 pb-2">
					<a
						href="/challenges"
						class="rounded-xl bg-cyan-200  text-cyan-500 font-semibold text-sm p-2 hover:bg-cyan-50 transition-colors active:bg-cyan-400"
					>
						Enter your first challenge
					</a>
				</div>
			</div>
		{/if}
	</div>
</GradientCard>
