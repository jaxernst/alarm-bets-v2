<script>
	import { goto } from '$app/navigation'
	import GoalCreator from '$lib/components/GoalCreator.svelte'
	import { promptConnectWallet } from '$lib/components/WalletConnector.svelte'
	import { userWallet } from '$lib/connectWallet'
	import Wallet from '$lib/icons/Wallet.svelte'
	import { mud, userWakeupGoals } from '$lib/mud/mudStore'
	import { getEntitiesWithValue } from '@latticexyz/recs'

	$: if ($mud.stateSynced && $userWakeupGoals.length > 0) {
		console.log('User has goals, redirecting...')
		goto('/dashboard')
	}

	const loginAndConnect = async () => {
		const wallet = await promptConnectWallet()
		mud.setup(wallet)
	}
</script>

<div class="h-full flex flex-col gap-6">
	<div class="flex-grow flex flex-col justify-evenly w-full p-4">
		<div>
			<h1 class="text-cyan-600 text-6xl font-bold">Alarm Bets</h1>
			<div class="text-cyan-500 font-semibold flex flex-wrap gap-2 text-sm py-5">
				<p class="border border-cyan-500 rounded-lg px-2 py-1">Set goals</p>
				<p class="border border-cyan-500 rounded-lg px-2 py-1">Complete morning challenges</p>
				<p class="border border-cyan-500 rounded-lg px-2 py-1">Wake up earlier</p>
			</div>
		</div>
		<div class="flex flex-col items-center gap-3">
			<GoalCreator
				firstGoal={true}
				onGoalCreated={() => {
					// Wait 5 seconds and if a redirect has not happened, force the redirect
					setTimeout(() => {
						if ($mud.stateSynced && $userWakeupGoals.length > 0) {
							console.log('User has goals, redirecting...')
							// goto('/')
						}
					}, 5000)
				}}
			/>
			{#if !$userWallet}
				<p class="text-zinc-400">or</p>
				<button
					on:click={loginAndConnect}
					class="flex gap-1 items-center border border-cyan-500 rounded-full text-cyan-500 stroke-cyan-500 px-3 py-1 font-semibold hover:bg-cyan-500 hover:text-cyan-50 hover:shadow hover:stroke-cyan-50 transition-all"
				>
					Login
					<div class="w-4"><Wallet /></div>
				</button>
			{/if}
		</div>
	</div>
</div>
