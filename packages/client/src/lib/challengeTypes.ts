type Currency = 'suns' | 'eth'

type FixedStake<T extends Currency> = {
	type: 'fixed'
	amount: number
	currency: T
}

type VariablStake<T extends Currency> = {
	type: 'variable'
	minAmount: number
	currency: T
}

type Stake<T extends Currency> = FixedStake<T> | VariablStake<T>

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
		name: "Stake It 'Til You Wake It",
		requiredLevel: 1,
		sunReward: { amount: 16, currency: 'suns' },
		ethEntryStake: { type: 'variable', currency: 'eth', minAmount: 0.01 },
		submissionWindowMin: 15,
		numPlayers: 1,
		description:
			'Stake Eth, Wakeup before your wakeup goal time, and get back the Eth with a Sun bonus!'
	},
	{
		id: 99,
		name: 'Wakeup Wordle (Single Player)',
		attestationRequired: true,
		sunReward: { amount: 35, currency: 'suns' },
		sunEntryStake: { type: 'fixed', currency: 'suns', amount: 18 },
		requiredLevel: 5,
		submissionWindowMin: 15,
		numPlayers: 1,
		description: 'Wakeup and solve a puzzle before your goal time to earn suns'
	},
	{
		id: 99,
		name: 'Wakeup Wordle (1v1)',
		attestationRequired: true,
		sunReward: { amount: 35, currency: 'suns' },
		sunEntryStake: { type: 'fixed', currency: 'suns', amount: 18 },
		requiredLevel: 5,
		submissionWindowMin: 15,
		numPlayers: 2,
		description: 'Wakeup and solve a puzzle before your goal time to earn suns'
	}
]
