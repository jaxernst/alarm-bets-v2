<script>
	import { page } from '$app/stores'
	import { userWallet } from '$lib/connectWallet'
	import NavBar from '$lib/components/NavBar.svelte'
	import WalletConnector from '$lib/components/WalletConnector.svelte'

	import '../app.css'
	import Wallet from '$lib/icons/Wallet.svelte'
	import { shortenAddress } from '$lib/util'

	$: pageRoute = $page.route.id
</script>

<WalletConnector />

<div class="flex justify-center">
	<div class={`flex w-full flex-col text-zinc-400 min-h-screen max-w-[550px] overflow-auto`}>
		{#if $userWallet}
			<div class="p-3 pb-3 flex justify-between items-center">
				<div class="text-xl font-bold text-cyan-500">
					{#if $page.route.id === '/dashboard'}
						Alarm Dashboard
					{/if}
				</div>
				<div
					class="px-3 py-1 flex items-center gap-1 text-cyan-500 font-semibold text-sm border border-cyan-500 rounded-full"
				>
					{shortenAddress($userWallet.account.address)}
					<div class="stroke-cyan-500 w-4">
						<Wallet />
					</div>
				</div>
			</div>
		{/if}
		<div class="flex-grow overflow-y-auto min-h-min">
			<slot />
		</div>
		{#if pageRoute !== '/welcome'}
			<NavBar />
		{/if}
	</div>
</div>
