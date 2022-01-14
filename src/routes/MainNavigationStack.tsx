import { createNativeStackNavigator } from "@react-navigation/native-stack"
import React from "react"
import { LoginScreen } from "@Scenes/Login/Login"
import { useStoreRehydrated } from "easy-peasy"
import { GlobalStore } from "@store/GlobalStore"
import { AuthenticatedStack } from "./AuthenticatedNavigationStacks"
import { NavigationContainer } from "@react-navigation/native"

// tslint:disable-next-line:interface-over-type-literal
export type MainNavigationStack = {
  Home: undefined
  Login: undefined
}

const Stack = createNativeStackNavigator<MainNavigationStack>()

export const MainNavigationStack = () => {
  const isRehydrated = useStoreRehydrated()
  const isLoggedIn = !!GlobalStore.useAppState((store) => store.auth.userAccessToken)

  if (!isRehydrated) {
    return null
  }

  if (!isLoggedIn) {
    return <LoginScreen />
  }

  return <AuthenticatedStack />
}
