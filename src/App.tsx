import { Theme } from "palette"
import React, { ReactNode } from "react"
import { LogBox } from "react-native"
import { SafeAreaProvider } from "react-native-safe-area-context"
import { GlobalStoreProvider } from "./store/GlobalStore"
import { MainNavigationStack } from "./MainNavigationStack"
import { useStoreRehydrated } from "easy-peasy"

LogBox.ignoreLogs(["Expected style "])

const AppProviders = ({ children }: { children: ReactNode }) => (
  <GlobalStoreProvider>
    <SafeAreaProvider>
      <Theme>{children}</Theme>
    </SafeAreaProvider>
  </GlobalStoreProvider>
)

const Main = () => {
  const isRehydrated = useStoreRehydrated()

  if (!isRehydrated) {
    return null
  }

  return <MainNavigationStack />
}
export const App = () => {
  return (
    <AppProviders>
      <Main />
    </AppProviders>
  )
}
