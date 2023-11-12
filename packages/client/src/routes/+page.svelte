<script lang="ts">
	import { mud } from '$lib/mud/mudStore';
	import MockApp from '$lib/Dashboard.svelte';
	import NavBar from '$lib/components/NavBar.svelte';
	import Wallet from '$lib/icons/Wallet.svelte';
	import Dashboard from '$lib/Dashboard.svelte';
</script>

<div class="flex justify-center ">
	<div class="flex flex-col text-zinc-700 h-screen overflow-hidden min-w-[400px] max-w-[500px]">
		<div class="p-3 flex justify-between w-full items-center">
			<h1 class="text-cyan-500 font-bold text-xl">Alarm Bets</h1>
			<div class="stroke-cyan-500 w-6">
				<Wallet />
			</div>
		</div>
		<div class="flex-grow overflow-hidden">
			<Dashboard />
		</div>
		<NavBar />
	</div>
</div>
