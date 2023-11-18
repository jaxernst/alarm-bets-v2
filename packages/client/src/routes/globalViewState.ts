import { writable } from 'svelte/store'

export type DashboardTab = 'Active Challenges' | 'Available Challenges' | 'Leaderboard'
export const DashboardTab = writable<DashboardTab>('Active Challenges')
