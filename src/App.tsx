import { Theme } from "palette"
import React from "react"
import { LogBox } from "react-native"
import { SafeAreaProvider } from "react-native-safe-area-context"
import { MainNavigationStack } from "./MainNavigationStack"

LogBox.ignoreLogs(["Expected style "])

export const App = () => {
  return (
    <SafeAreaProvider>
      <Theme>
        <MainNavigationStack />
      </Theme>
    </SafeAreaProvider>
  )
}
