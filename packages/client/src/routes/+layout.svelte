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
		<div class={`flex w-full flex-col text-zinc-700 h-screen overflow-hidden max-w-[550px] px-3`}>
			<div class="py-3 flex justify-between w-full items-center">
				<h1 class="text-cyan-500 font-bold text-xl">Alarm Bets</h1>
				<div class="stroke-cyan-500 w-6">
					<Wallet />
				</div>
			</div>
			<div class="flex-grow overflow-hidden">
				<slot />
			</div>
			<NavBar />
		</div>
	{/if}
</div>
