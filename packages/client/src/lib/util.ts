export function getTimezoneOffsetInHours() {
  // Get the timezone offset in minutes
  const offsetMinutes = new Date().getTimezoneOffset();

  // Convert the offset to hours and change the sign
  const offsetHours = -offsetMinutes / 60;

  return offsetHours;
}

console.log(getTimezoneOffsetInHours()); // Should print -7 or -8 depending on Daylight Saving
