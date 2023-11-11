export function getTimezoneOffsetInHours() {
  // Get the timezone offset in minutes
  const offsetMinutes = new Date().getTimezoneOffset();

  // Convert the offset to hours and change the sign
  const offsetHours = -offsetMinutes / 60;

  return offsetHours;
}

export const localTzOffsetHrs = () => {
  return -new Date().getTimezoneOffset() / 60;
};

export function systemTimestamp(): number {
  return Math.floor(Date.now() / 1000);
}

export const timeOfDay = (timestamp: number, timezoneOffsetHrs = 0): number => {
  const date = new Date((timestamp + timezoneOffsetHrs * HOUR) * 1000);
  return (
    date.getUTCHours() * 3600 + date.getUTCMinutes() * 60 + date.getUTCSeconds()
  );
};

// Takes the alarm time of day in seconds (0 - 86400) and a UTC timezone offset (-12 - 12)
// add offsets
export const correctAlarmTime = (
  alarmTimeS: number,
  onchainTimezoneOffsetS: number
) => {
  const localTimezoneOffsetS = localTzOffsetHrs() * 60 * 60;
  const tzDiff = localTimezoneOffsetS - onchainTimezoneOffsetS;

  let correctedAlarmTimeS = alarmTimeS + tzDiff;

  // Correcting the alarm time so it wraps around 0 and 86400
  if (correctedAlarmTimeS < 0) {
    correctedAlarmTimeS = DAY + correctedAlarmTimeS;
  } else if (correctedAlarmTimeS >= DAY) {
    correctedAlarmTimeS = correctedAlarmTimeS - DAY;
  }

  return correctedAlarmTimeS;
};

export const SECOND = 1;
export const MINUTE = SECOND * 60;
export const HOUR = MINUTE * 60;
export const DAY = HOUR * 24;
export const WEEK = DAY * 7;
export const MONTH = DAY * 30;

export function formatTime(timeInSeconds: number) {
  const MINUTE_IN_SECONDS = 60;
  const HOUR_IN_SECONDS = MINUTE_IN_SECONDS * 60;
  const DAY_IN_SECONDS = HOUR_IN_SECONDS * 24;
  const WEEK_IN_SECONDS = DAY_IN_SECONDS * 7;

  if (timeInSeconds < MINUTE_IN_SECONDS) {
    return `${timeInSeconds} second${timeInSeconds === 1 ? "" : "s"}`;
  } else if (timeInSeconds < HOUR_IN_SECONDS) {
    const minutes = Math.floor(timeInSeconds / MINUTE_IN_SECONDS);
    const seconds = timeInSeconds % MINUTE_IN_SECONDS;
    return `${minutes} minute${minutes === 1 ? "" : "s"} and ${seconds} second${
      seconds === 1 ? "" : "s"
    }`;
  } else if (timeInSeconds < DAY_IN_SECONDS) {
    const hours = Math.floor(timeInSeconds / HOUR_IN_SECONDS);
    const minutes = Math.floor(
      (timeInSeconds % HOUR_IN_SECONDS) / MINUTE_IN_SECONDS
    );
    return `${hours} hour${hours === 1 ? "" : "s"}, ${minutes} minute${
      minutes === 1 ? "" : "s"
    }`;
  } else if (timeInSeconds < WEEK_IN_SECONDS) {
    const days = Math.floor(timeInSeconds / DAY_IN_SECONDS);
    const hours = Math.floor(
      (timeInSeconds % DAY_IN_SECONDS) / HOUR_IN_SECONDS
    );
    return `${days} day${days === 1 ? "" : "s"}, ${hours} hour${
      hours === 1 ? "" : "s"
    }`;
  } else {
    const weeks = Math.floor(timeInSeconds / WEEK_IN_SECONDS);
    const days = Math.floor((timeInSeconds % WEEK_IN_SECONDS) / DAY_IN_SECONDS);
    return `${weeks} week${weeks === 1 ? "" : "s"}, ${days} day${
      days === 1 ? "" : "s"
    }`;
  }
}

export function timeString(secondsAfterMidnight: number) {
  let hours = Math.floor(secondsAfterMidnight / 3600);
  const minutes = Math.floor((secondsAfterMidnight % 3600) / 60);
  const ampm = hours >= 12 ? "PM" : "AM";
  hours = hours % 12;
  hours = hours ? hours : 12; // the hour '0' should be '12'
  const minutesFormatted = minutes < 10 ? "0" + minutes : minutes;
  const strTime = hours + ":" + minutesFormatted + " " + ampm;
  return strTime;
}
