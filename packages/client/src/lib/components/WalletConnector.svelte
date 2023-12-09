<script context="module">
	import { userWallet } from '$lib/connectWallet'
	import { shortenAddress } from '$lib/util'
	import { ReplaySubject } from 'rxjs'
	import { get, writable } from 'svelte/store'
	import { fade } from 'svelte/transition'

	const showModal = writable(false)

	export async function promptConnectWallet() {
		showModal.set(true)

		return new Promise(async (resolve, reject) => {
			userWallet.subscribe((wallet) => {
				if (wallet) setTimeout(() => resolve(wallet), 1000)
			})

			showModal.subscribe((show) => {
				if (!show && !get(userWallet)) {
					reject()
				}
			})
		})
	}

	const connectWallet = async () => {
		const wallet = userWallet.tryConnect()
		await new Promise((r) => setTimeout(r, 2000))

		if (wallet) {
			showModal.set(false)
		}
	}
</script>

{#if $showModal}
	<div class="absolute h-screen w-screen flex justify-center items-center bg-black bg-opacity-20">
		<div
			class="min-w-[200px] min-h-[200px] bg-zinc-50 flex flex-col gap-2 justify-evenly items-center rounded-lg p-6"
		>
			{#if $userWallet}
				<p transition:fade class={`text-cyan-500 font-semibold`}>
					Welcome {shortenAddress($userWallet?.account.address ?? '')}
				</p>
			{:else}
				<button
					on:click={connectWallet}
					class="bg-cyan-400 rounded-full px-2 py-1 text-white font-bold"
				>
					Connect
				</button>
			{/if}
		</div>
	</div>
{/if}
