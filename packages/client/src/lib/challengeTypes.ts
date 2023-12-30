type Currency = 'suns' | 'eth'

type FixedStake<T extends Currency> = {
	type: 'fixed'
	amount: number
	currency: T
}

type VariableStake<T extends Currency> = {
	type: 'variable'
	minAmount: number
	currency: T
}

type Stake<T extends Currency> = FixedStake<T> | VariableStake<T>

export type ChallengeInfo = {
	name: string
	id: number
	description: string
	requiredLevel: number
	sunEntryStake?: Stake<'suns'>
	ethEntryStake?: Stake<'eth'>
	sunReward: {
		amount: number
		currency: 'suns'
	}

	attestationRequired?: boolean
	submissionWindowMin: number
	numPlayers: number
}

export const challengeTypes: ChallengeInfo[] = [
	{
		id: 1,
		name: 'Daily Check In',
		requiredLevel: 1,
		sunReward: { amount: 0, currency: 'suns' },
		submissionWindowMin: 15,
		numPlayers: 1,
		description: 'Check in any day before your alarm time to earn your base reward'
	},
	{
		id: 2,
		name: 'Sun Staked Check In',
		requiredLevel: 1,
		sunReward: { amount: 11, currency: 'suns' },
		sunEntryStake: { type: 'fixed', currency: 'suns', amount: 5 },
		submissionWindowMin: 15,
		numPlayers: 1,
		description:
			'Wakeup before your wakeup goal time and check in to earn suns. If you miss your wakeup on the days you select, no reward is given'
	},
	{
		id: 99,
		name: 'Eth Staked Check In',
		requiredLevel: 1,
		sunReward: { amount: 16, currency: 'suns' },
		ethEntryStake: { type: 'variable', currency: 'eth', minAmount: 0.01 },
		submissionWindowMin: 15,
		numPlayers: 1,
		description:
			'Stake Eth, Wakeup before your wakeup goal time, and get back the Eth with a Sun bonus!'
	}
]
