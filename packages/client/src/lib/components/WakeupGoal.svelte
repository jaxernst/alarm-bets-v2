<script lang="ts">
	import Sun from '../icons/Sun.svelte'
	import EthSymbol from '../icons/EthSymbol.svelte'
	import Lock from '../icons/Lock.svelte'
	import { timeString } from '../util'
	import AlarmActiveDays from './ActiveDays.svelte'
	import ActiveDays from './ActiveDays.svelte'
	import type { Entity } from '@latticexyz/recs'
	import GradientCard from './design-sys/GradientCard.svelte'

	export let goal: {
		entity: Entity
		time: number
		suns: number
		level: number
	}

	let time = timeString(goal.time)
	let challengeDays = [2, 3, 5]
</script>

<GradientCard klass="flex flex-col">
	<div class="flex justify-between gap-1 items-center p-1 text-white">
		<div class="text-xs rounded-full font-semibold">Lvl {goal.level}</div>
		<div class="flex gap-1 items-center text-xs rounded-full font-semibold">
			{goal.suns}
			<div class="w-3 h-min fill-white">
				<Sun />
			</div>
		</div>
	</div>
	<div class="py-2">
		<div
			class=" px-6 py-1 font-digital text-cyan-100 text-4xl font-bold text-center pt-1"
			style="line-height:1em"
		>
			{time}
		</div>
	</div>
	<div class="flex flex-col px-2">
		<ActiveDays activeDays={challengeDays} />
	</div>
</GradientCard>
