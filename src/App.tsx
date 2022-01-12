import { Theme } from "palette"
import React, { ReactNode } from "react"
import { LogBox } from "react-native"
import { SafeAreaProvider } from "react-native-safe-area-context"
import { GlobalStoreProvider } from "./store/GlobalStore"
import { MainNavigationStack } from "./MainNavigationStack"
import { useStoreRehydrated } from "easy-peasy"
import { RelayEnvironmentProvider } from "react-relay/hooks"
import { NavigationContainer } from "@react-navigation/native"
import { defaultEnvironment } from "@relay/defaultEnvironent"

LogBox.ignoreLogs(["Expected style "])

const AppProviders = ({ children }: { children: ReactNode }) => (
  <RelayEnvironmentProvider environment={defaultEnvironment}>
    <SafeAreaProvider>
      <Theme>
        <NavigationContainer>{children}</NavigationContainer>
      </Theme>
    </SafeAreaProvider>
  </RelayEnvironmentProvider>
)

export const App = () => {
  return (
    <GlobalStoreProvider>
      <AppProviders>
        <MainNavigationStack />
      </AppProviders>
    </GlobalStoreProvider>
  )
}
