import { Platform } from "react-native"
import { getBuildNumber, getUserAgentSync } from "react-native-device-info"
import packageJson from "../../package.json"

export const getUserAgent = () => {
  // `getUserAgentSync` breaks the Chrome Debugger, so we use a string instead.
  const userAgent = `${__DEV__ ? "Artsy-Mobile " + Platform.OS : getUserAgentSync()} Artsy-Mobile/${
    packageJson.version
  } Eigen/${getBuildNumber()}/${packageJson.version}`

  return userAgent
}
