export const localTzOffsetHrs = () => {
	return -new Date().getTimezoneOffset() / 60
}

export function systemTimestamp(): number {
	return Math.floor(Date.now() / 1000)
}

export const timeOfDay = (timestamp: number, timezoneOffsetHrs = 0): number => {
	const date = new Date((timestamp + timezoneOffsetHrs * HOUR) * 1000)
	return date.getUTCHours() * 3600 + date.getUTCMinutes() * 60 + date.getUTCSeconds()
}

// Takes the alarm time of day in seconds (0 - 86400) and a UTC timezone offset (-12 - 12)
// add offsets
export const correctAlarmTime = (alarmTimeS: number, onchainTimezoneOffsetS: number) => {
	const localTimezoneOffsetS = localTzOffsetHrs() * 60 * 60
	const tzDiff = localTimezoneOffsetS - onchainTimezoneOffsetS

	let correctedAlarmTimeS = alarmTimeS + tzDiff

	// Correcting the alarm time so it wraps around 0 and 86400
	if (correctedAlarmTimeS < 0) {
		correctedAlarmTimeS = DAY + correctedAlarmTimeS
	} else if (correctedAlarmTimeS >= DAY) {
		correctedAlarmTimeS = correctedAlarmTimeS - DAY
	}

	return correctedAlarmTimeS
}

export const SECOND = 1
export const MINUTE = SECOND * 60
export const HOUR = MINUTE * 60
export const DAY = HOUR * 24
export const WEEK = DAY * 7
export const MONTH = DAY * 30

export function formatTime(timeInSeconds: number) {
	const MINUTE_IN_SECONDS = 60
	const HOUR_IN_SECONDS = MINUTE_IN_SECONDS * 60
	const DAY_IN_SECONDS = HOUR_IN_SECONDS * 24
	const WEEK_IN_SECONDS = DAY_IN_SECONDS * 7

	if (timeInSeconds < MINUTE_IN_SECONDS) {
		return `${timeInSeconds} second${timeInSeconds === 1 ? '' : 's'}`
	} else if (timeInSeconds < HOUR_IN_SECONDS) {
		const minutes = Math.floor(timeInSeconds / MINUTE_IN_SECONDS)
		const seconds = timeInSeconds % MINUTE_IN_SECONDS
		return `${minutes} minute${minutes === 1 ? '' : 's'} and ${seconds} second${
			seconds === 1 ? '' : 's'
		}`
	} else if (timeInSeconds < DAY_IN_SECONDS) {
		const hours = Math.floor(timeInSeconds / HOUR_IN_SECONDS)
		const minutes = Math.floor((timeInSeconds % HOUR_IN_SECONDS) / MINUTE_IN_SECONDS)
		return `${hours} hour${hours === 1 ? '' : 's'}, ${minutes} minute${minutes === 1 ? '' : 's'}`
	} else if (timeInSeconds < WEEK_IN_SECONDS) {
		const days = Math.floor(timeInSeconds / DAY_IN_SECONDS)
		const hours = Math.floor((timeInSeconds % DAY_IN_SECONDS) / HOUR_IN_SECONDS)
		return `${days} day${days === 1 ? '' : 's'}, ${hours} hour${hours === 1 ? '' : 's'}`
	} else {
		const weeks = Math.floor(timeInSeconds / WEEK_IN_SECONDS)
		const days = Math.floor((timeInSeconds % WEEK_IN_SECONDS) / DAY_IN_SECONDS)
		return `${weeks} week${weeks === 1 ? '' : 's'}, ${days} day${days === 1 ? '' : 's'}`
	}
}

export function timeString(secondsAfterMidnight: number) {
	let hours = Math.floor(secondsAfterMidnight / 3600)
	const minutes = Math.floor((secondsAfterMidnight % 3600) / 60)
	const ampm = hours >= 12 ? 'PM' : 'AM'
	hours = hours % 12
	hours = hours ? hours : 12 // the hour '0' should be '12'
	const minutesFormatted = minutes < 10 ? '0' + minutes : minutes
	const strTime = hours + ':' + minutesFormatted + ' ' + ampm
	return strTime
}

export function timeString24Hour(secondsAfterMidnight: number) {
	const hours = Math.floor(secondsAfterMidnight / 3600)
	const minutes = Math.floor((secondsAfterMidnight % 3600) / 60)
	const minutesFormatted = minutes < 10 ? '0' + minutes : minutes
	const strTime = hours + ':' + minutesFormatted
	// Pad with 0 if needed
	return strTime.padStart(5, '0')
}

export function timeStringToSeconds(timeString: string) {
	const [hours, minutes] = timeString.split(':')

	let totalSeconds = 0

	// Calculate total seconds
	totalSeconds += parseInt(hours, 10) * 3600 // 1 hour = 3600 seconds
	totalSeconds += parseInt(minutes, 10) * 60 // 1 minute = 60 seconds

	return totalSeconds
}

export const readableTimezone = (offset: number) => {
	let localTimezone
	if (offset === localTzOffsetHrs()) {
		localTimezone = Intl.DateTimeFormat().resolvedOptions().timeZone
	}
	return `UTC${offset >= 0 ? `+${offset}` : offset} (${localTimezone ?? 'non-local'}) `
}

export const parseTimeString = (timeString: string) => {
	const time = timeString.replace(/\s/g, '').toUpperCase()

	// Regular expression to match time formats
	const timeRegex = /(\d{1,2}):(\d{2})(?::(\d{2}))?\s?(AM|PM)?/

	const match = time.match(timeRegex)
	if (!match) {
		throw new Error('Invalid time format')
	}

	let [_, hours, minutes, seconds = '0', ampm]: any[] = match

	// Convert to numbers
	hours = parseInt(hours, 10)
	minutes = parseInt(minutes, 10)
	seconds = parseInt(seconds, 10)

	// Adjust hours for 12-hour clock, if applicable
	if (ampm) {
		if (hours < 1 || hours > 12) {
			throw new Error('Invalid hour for 12-hour format')
		}
		if (ampm === 'PM' && hours < 12) hours += 12
		if (ampm === 'AM' && hours === 12) hours = 0
	} else {
		if (hours < 0 || hours > 23) {
			throw new Error('Invalid hour for 24-hour format')
		}
	}

	// Calculate total seconds
	return hours * 3600 + minutes * 60 + seconds
}

export const shortenAddress = (address: string, chars = 4) => {
	return `${address.substring(0, chars + 2)}...${address.substring(address.length - chars)}`
}
