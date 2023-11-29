import mudConfig from 'contracts/mud.config'
import { type SetupResult, setup } from './setup'
import { writable, derived } from 'svelte/store'
import { mount as mountDevTools } from '@latticexyz/dev-tools'
import { type Component, runQuery, Has, HasValue, type Entity } from '@latticexyz/recs'

enum Status {
	Inactive,
	Active,
	Complete
}

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

export const user = derived(mud, ($mud) => {
	return $mud?.network.walletClient.account.address
})

export const userWakeupGoals = derived(mud, ($mud) => {
	const user = $mud?.network.walletClient.account.address
	if (!$mud || !user) return []

	const { WakeupObjective, Creator } = $mud.components
	const entities = runQuery([Has(WakeupObjective), HasValue(Creator, { value: user })])
	return Array.from(entities)
})

// Function to get all active wakeup challenges for a given wakeup goal
export const getActiveWakeupChallenges = derived(mud, ($mud) => {
	return (forGoal: Entity) => {
		if (!$mud) return []

		const { WakeupChallenge, ChallengeStatus, TargetWakeupObjective } = $mud.components
		const entities = runQuery([
			Has(WakeupChallenge),
			HasValue(TargetWakeupObjective, { value: forGoal }),
			HasValue(ChallengeStatus, { value: Status.Active as any })
		])

		return Array.from(entities)
	}
})
