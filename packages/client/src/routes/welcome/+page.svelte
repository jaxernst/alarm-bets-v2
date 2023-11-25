<script>
	import { goto } from '$app/navigation'
	import GoalCreator from '$lib/components/GoalCreator.svelte'
	import { mud, userWakeupGoals } from '$lib/mud/mudStore'
	import { getEntitiesWithValue } from '@latticexyz/recs'

	$: if ($mud.stateSynced && $userWakeupGoals.length > 0) {
		console.log('User has goals, redirecting...')
		goto('/')
	}
</script>

<div class="h-full flex flex-col gap-6">
	<div class="flex-grow flex flex-col justify-evenly w-full p-4">
		<div>
			<h1 class="text-cyan-600 text-2xl font-bold">Welcome to alarm bets.</h1>
			<p class="text-cyan-400">An onchain game to help you wake up earlier.</p>
		</div>
		<GoalCreator
			firstGoal={true}
			onGoalCreated={() => {
				// Wait 5 seconds and if a redirect has not happened, force the redirect
				setTimeout(() => {
					if ($mud.stateSynced && $userWakeupGoals.length > 0) {
						console.log('User has goals, redirecting...')
						goto('/')
					}
				}, 5000)
			}}
		/>
	</div>
</div>
