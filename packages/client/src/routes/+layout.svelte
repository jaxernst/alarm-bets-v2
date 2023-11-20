<script>
	import NavBar from '$lib/components/NavBar.svelte'
	import Wallet from '$lib/icons/Wallet.svelte'
	import { mud } from '$lib/mud/mudStore'
	import '../app.css'
</script>

<div class="flex justify-center">
	{#if !$mud.stateSynced}
		Loading MUD App...
	{:else}
		<div class={`flex w-full flex-col text-zinc-700 min-h-screen max-w-[550px] flex-1 overflow-auto`}>
			<div class="p-3 flex justify-between w-full items-center">
				<h1 class="text-cyan-500 font-bold text-xl">Alarm Bets</h1>
				<div class="stroke-cyan-500 w-6">
					<Wallet />
				</div>
			</div>
			<div class="flex-grow overflow-y-auto min-h-min">
				<slot />
			</div>
			<NavBar />
		</div>
	{/if}
</div>
