import { Theme } from "palette"
import React from "react"
import { LogBox } from "react-native"
import { MainNavigationStack } from "./MainNavigationStack"

LogBox.ignoreLogs(["Expected style "])

export const App = () => {
  return (
    <Theme>
      <MainNavigationStack />
    </Theme>
  )
}
