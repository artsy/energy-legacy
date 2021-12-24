import React from "react"
import { NavigationContainer } from "@react-navigation/native"
import { createNativeStackNavigator } from "@react-navigation/native-stack"
import { HomeScreen } from "./Scenes/Home/Home"
import { LoginScreen } from "./Scenes/Login/Login"

// tslint:disable-next-line:interface-over-type-literal
export type MainNavigationStack = {
  Home: undefined
  Login: undefined
}

const Stack = createNativeStackNavigator<MainNavigationStack>()

export const MainNavigationStack = () => {
  return (
    <NavigationContainer>
      <Stack.Navigator screenOptions={{ headerShown: false }}>
        <Stack.Screen name="Home" component={HomeScreen} />
        <Stack.Screen name="Login" component={LoginScreen} />
      </Stack.Navigator>
    </NavigationContainer>
  )
}
