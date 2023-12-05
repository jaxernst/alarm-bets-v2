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
	description: string
	requiredLevel: number
	sunEntryStake: Stake<'suns'>
	ethEntryStake?: Stake<'eth'>
	sunReward: {
		amount: number
		currency: 'suns'
	}

	attestionRequired?: boolean
	submissionWindowMin: number
}

export const challengeTypes: ChallengeInfo[] = [
	{
		name: 'Daily Check in',
		requiredLevel: 1,
		sunReward: { amount: 11, currency: 'suns' },
		sunEntryStake: { type: 'fixed', currency: 'suns', amount: 5 },
		submissionWindowMin: 15,
		description:
			'Wakeup before your wakeup goal time and check in to earn suns. If you miss your wakeup on the days you select, no reward is given'
	},
	{
		name: 'Wakeup Wordle',
		attestionRequired: true,
		sunReward: { amount: 35, currency: 'suns' },
		sunEntryStake: { type: 'fixed', currency: 'suns', amount: 18 },
		requiredLevel: 5,
		submissionWindowMin: 15,
		description: 'Wakeup and solve a puzzle before your goal time to earn suns'
	}
]
