import mudConfig from 'contracts/mud.config'
import { type SetupResult, setup } from './setup'
import { writable, derived } from 'svelte/store'
import { mount as mountDevTools } from '@latticexyz/dev-tools'
import type { Component } from '@latticexyz/recs'

export const mud = (() => {
	const mud = writable<SetupResult>()
	const components = writable<SetupResult['components']>()
	const stateSynced = writable(false)

	setup().then((mudSetupResult) => {
		mud.set(mudSetupResult)
		components.set(mudSetupResult.components)

		const { network } = mudSetupResult

		Object.entries(mudSetupResult.components).forEach(([componentName, component]) => {
			return (component as Component).update$.subscribe((update) => {
				console.log('Component update', componentName, update)
				components.update((components) => ({
					...components,
					[componentName]: update.component as any
				}))
			})
		})

		mudSetupResult.components.SyncProgress.update$.subscribe((progress) => {
			stateSynced.set(progress.value.every((v) => v?.step === 'live'))
		})

		mountDevTools({
			config: mudConfig,
			publicClient: network.publicClient,
			walletClient: network.walletClient,
			latestBlock$: network.latestBlock$,
			storedBlockLogs$: network.storedBlockLogs$,
			worldAddress: network.worldContract.address,
			worldAbi: network.worldContract.abi,
			write$: network.write$,
			recsWorld: network.world
		})
	})

	return derived([mud, components, stateSynced], ([$mud, $components, $stateSynced]) => {
		if (!$mud) return undefined as unknown as SetupResult & { stateSynced: boolean }
		return {
			...$mud,
			stateSynced: $stateSynced,
			components: $components
		}
	})
})()

export const user = derived(mud, ($mud) => $mud?.network.walletClient.account.address)
