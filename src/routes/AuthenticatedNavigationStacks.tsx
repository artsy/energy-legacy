import {
  BottomTabNavigationOptions,
  createBottomTabNavigator,
  BottomTabScreenProps,
} from "@react-navigation/bottom-tabs"
import { NavigationContainer } from "@react-navigation/native"
import React from "react"
import { ArtistsScreen } from "@Scenes/Artists/Artists"
import { ShowsScreen } from "@Scenes/Shows/Shows"
import { AlbumsScreen } from "@Scenes/Albums/Albums"
import { SelectPartner } from "@Scenes/SelectPartner/SelectPartner"
import { useColor, useTheme } from "palette"

// tslint:disable-next-line:interface-over-type-literal
export type TabNavigatorStack = {
  Artists: undefined
  Shows: undefined
  Albums: undefined
}

const Tab = createBottomTabNavigator<TabNavigatorStack>()

export const TabNavigatorStack = () => {
  const color = useColor()
  const {
    theme: { fonts },
  } = useTheme()

  return (
    <NavigationContainer independent>
      <Tab.Navigator
        screenOptions={({ route }) => {
          let routeSpecificOptions: BottomTabNavigationOptions = {}

          switch (route.name) {
            case "Artists":
              routeSpecificOptions = { tabBarAccessibilityLabel: "Artists", tabBarLabel: "Artists" }
              break
            case "Albums":
              routeSpecificOptions = { tabBarAccessibilityLabel: "Albums", tabBarLabel: "Albums" }
              break
            case "Shows":
              routeSpecificOptions = { tabBarAccessibilityLabel: "Shows", tabBarLabel: "Shows" }
              break
            default:
              break
          }
          return {
            tabBarItemStyle: {
              alignItems: "center",
              justifyContent: "center",
            },
            tabBarIconStyle: { display: "none" },
            tabBarLabelStyle: {
              fontFamily: fonts.sans.medium,
              fontSize: 14,
            },
            tabBarActiveTintColor: color("blue100"),
            tabBarInactiveTintColor: color("black60"),
            ...routeSpecificOptions,
          }
        }}
      >
        <Tab.Screen name="Artists" component={ArtistsScreen} />
        <Tab.Screen name="Shows" component={ShowsScreen} />
        <Tab.Screen name="Albums" component={AlbumsScreen} />
      </Tab.Navigator>
    </NavigationContainer>
  )
}

export const AuthenticatedStack = () => {
  const selectedPartner = "randomPartner"

  if (!selectedPartner) {
    return <SelectPartner />
  }

  return <TabNavigatorStack />
}
