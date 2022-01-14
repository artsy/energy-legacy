import { BottomTabNavigationOptions, createBottomTabNavigator } from "@react-navigation/bottom-tabs"
import { createStackNavigator } from "@react-navigation/stack"
import { AlbumsScreen } from "@Scenes/Albums/Albums"
import { ArtistScreen } from "@Scenes/Artist/Artist"
import { ArtistsScreen } from "@Scenes/Artists/Artists"
import { SelectPartnerScreen } from "@Scenes/SelectPartner/SelectPartner"
import { SettingsScreenStack } from "@Scenes/Settings/Settings"
import { ShowsScreen } from "@Scenes/Shows/Shows"
import { OrdersScreen } from "@Scenes/Orders/Orders"
import { useColor, useTheme } from "palette"
import React from "react"
import { GlobalStore } from "@store/GlobalStore"

// tslint:disable-next-line:interface-over-type-literal
export type TabNavigatorStack = {
  Artists: undefined
  Shows: undefined
  Albums: undefined
  Orders: undefined
}

const Tab = createBottomTabNavigator<TabNavigatorStack>()

export const TabNavigatorStack = () => {
  const color = useColor()
  const {
    theme: { fonts },
  } = useTheme()

  return (
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
      <Tab.Screen name="Orders" component={OrdersScreen} />
    </Tab.Navigator>
  )
}

// tslint:disable-next-line:interface-over-type-literal
export type MainAuthenticatedStackProps = {
  Settings: undefined
  TabNavigatorStack: undefined
  Artist: { artistID: string }
}

export const MainAuthenticatedStackNavigator = createStackNavigator<MainAuthenticatedStackProps>()

// // tslint:disable-next-line:variable-name

export const MainAuthenticatedStack = () => {
  return (
    <MainAuthenticatedStackNavigator.Navigator>
      <MainAuthenticatedStackNavigator.Screen
        name="TabNavigatorStack"
        component={TabNavigatorStack}
        options={{ headerShown: false }}
      />
      <MainAuthenticatedStackNavigator.Screen
        name="Settings"
        component={SettingsScreenStack}
        options={{ headerShown: false }}
      />
      <MainAuthenticatedStackNavigator.Screen name="Artist" component={ArtistScreen} />
    </MainAuthenticatedStackNavigator.Navigator>
  )
}

export const AuthenticatedStack = () => {
  const selectedPartner = GlobalStore.useAppState((state) => state.activePartnerID)

  if (!selectedPartner) {
    return <SelectPartnerScreen />
  }

  return <MainAuthenticatedStack />
}
