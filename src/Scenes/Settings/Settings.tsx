import { NavigationContainer } from "@react-navigation/native"
import { createStackNavigator } from "@react-navigation/stack"
import React from "react"
import { SettingsScreen } from "./Settings/Settings"
import { SettingsPrivacyDataRequestScreen } from "./SettingsPrivacyDataRequest/SettingsPrivacyDataRequest"

export type SettingsScreenStack = {
  Settings: undefined
  SettingsPrivacyDataRequest: undefined
}

export const SettingsScreenStackNavigator = createStackNavigator<SettingsScreenStack>()

export const SettingsScreenStack = () => {
  return (
    <NavigationContainer independent>
      <SettingsScreenStackNavigator.Navigator>
        <SettingsScreenStackNavigator.Screen
          name="Settings"
          component={SettingsScreen}
          // options={{ headerShown: false }}
        />
        <SettingsScreenStackNavigator.Screen
          name="SettingsPrivacyDataRequest"
          component={SettingsPrivacyDataRequestScreen}
        />
      </SettingsScreenStackNavigator.Navigator>
    </NavigationContainer>
  )
}
