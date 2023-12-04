/*
 * Create the system calls that the client can use to ask
 * for changes in the World state (using the System contracts).
 */

import { getComponentValue, type Entity, getEntityString, getEntitySymbol } from '@latticexyz/recs'
import type { ClientComponents } from './createClientComponents'
import type { SetupNetworkResult } from './setupNetwork'
import { encodeEntity, entityToHexKeyTuple, singletonEntity } from '@latticexyz/store-sync/recs'

export type SystemCalls = ReturnType<typeof createSystemCalls>

export function createSystemCalls(
	{ worldContract, waitForTransaction }: SetupNetworkResult,
	{ Counter }: ClientComponents
) {
	const increment = async () => {
		/*
		 * Because IncrementSystem
		 * (https://mud.dev/templates/typescript/contracts#incrementsystemsol)
		 * is in the root namespace, `.increment` can be called directly
		 * on the World contract.
		 */
		const tx = await worldContract.write.increment()
		await waitForTransaction(tx)
		return getComponentValue(Counter, singletonEntity)
	}

	const createWakeupObjective = async (alarmTime: number, timezoneHrs: number) => {
		const tx = await worldContract.write.newObjective([alarmTime, timezoneHrs])
		await waitForTransaction(tx)
	}

	const enterDailyCheckInChallenge = async (
		wakeupObjective: Entity,
		challengeDays: number[],
		numWeeks: number
	) => {
		const tx = await worldContract.write.DailyCheckIn_enter([
			wakeupObjective as `0x${string}`,
			numWeeks,
			challengeDays
		])
		await waitForTransaction(tx)
		console.log('Entered daily check-in challenge')
	}

	const recordEntry = async (challengeId: Entity) => {
		const tx = await worldContract.write.DailyCheckIn_confirmWakeup([challengeId])
		await waitForTransaction(tx)
	}

	const nextDeadlineTimestamp = async (challengeId: Entity) => {
		return Number(await worldContract.read.nextDeadlineTimestamp([challengeId]))
	}

	return {
		increment,
		createWakeupObjective,
		enterDailyCheckInChallenge,
		recordEntry,
		nextDeadlineTimestamp
	}
}
