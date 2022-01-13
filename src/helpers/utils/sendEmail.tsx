import { stringify } from "qs"
import { Linking, Alert } from "react-native"

export const sendEmail = ({ toAddress, subject, body }: { toAddress: string; subject?: string; body?: string }) => {
  const mailString = `mailto:${toAddress}?${stringify({ subject, body })}`
  Linking.canOpenURL(mailString)
    .then((res) => {
      console.log("res => ", res)

      if (res) {
        Linking.openURL(mailString)
        return
      }
    })
    .catch((error) => {
      console.error(error)
      Alert.alert(
        "Error",
        `We could not find a mailing app installed on your device, please send us an email to ${toAddress}`
      )
    })
}
