import moment from "moment"

export const calculateTimeRemaining = (
  stateExpiresAt: string,
  now = moment()
): string => {
  const expiresAt = moment(stateExpiresAt)
  const diff = expiresAt.diff(now)

  if (diff <= 0) return "0d"

  const timeParts = []

  const duration = moment.duration(diff)

  const days = duration.days()
  const hours = duration.hours()
  const minutes = duration.minutes()
  const seconds = duration.seconds()

  if (days > 0) {
    timeParts.push(`${days}d`)
  }
  if (days > 0 || hours > 0) {
    timeParts.push(`${hours}h`)
  }
  // if (days > 0 || hours > 0 || minutes > 0) {
  //   timeParts.push(`${minutes}m`)
  // }
  // timeParts.push(`${seconds}s`)

  return timeParts.join(" ")
}
