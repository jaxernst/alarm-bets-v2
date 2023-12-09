<script>
	import { mud } from '$lib/mud/mudStore'
	import { userWallet } from '$lib/connectWallet'
	import { onMount } from 'svelte'
	import { promptConnectWallet } from '$lib/components/WalletConnector.svelte'

	$: if (!$userWallet) {
		userWallet.tryConnect()
	}

	$: if (!$mud.ready && $userWallet) {
		mud.setup($userWallet)
	}
</script>

{#if !$userWallet}
	Logging in...
{:else if !$mud.ready}
	Loading mud...
{:else}
	<slot />
{/if}
