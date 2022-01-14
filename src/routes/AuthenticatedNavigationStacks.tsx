import { BottomTabNavigationOptions, createBottomTabNavigator } from "@react-navigation/bottom-tabs"
import { LinkingOptions, NavigationContainer } from "@react-navigation/native"
import { createStackNavigator } from "@react-navigation/stack"
import { AlbumsScreen } from "@Scenes/Albums/Albums"
import { ArtistScreen } from "@Scenes/Artist/Artist"
import { ArtistsScreen } from "@Scenes/Artists/Artists"
import { ArtworkScreen } from "@Scenes/Artwork/Artwork"
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
  Artist: { id: string }
  Artwork: { id: string }
}

export const MainAuthenticatedStackNavigator = createStackNavigator<MainAuthenticatedStackProps>()

const linking: LinkingOptions<ReactNavigation.RootParamList> = {
  // TODO: Consolidate deep linking infra
  prefixes: ["folio://"],
  config: {
    screens: {
      Artwork: "artwork/:id",
      Artist: "artist/:id",
    },
  },
}

export const MainAuthenticatedStack = () => {
  return (
    <NavigationContainer linking={linking}>
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
        <MainAuthenticatedStackNavigator.Screen name="Artwork" component={ArtworkScreen} />
      </MainAuthenticatedStackNavigator.Navigator>
    </NavigationContainer>
  )
}

export const AuthenticatedStack = () => {
  const selectedPartner = GlobalStore.useAppState((state) => state.activePartnerID)

  if (!selectedPartner) {
    return <SelectPartnerScreen />
  }

  return <MainAuthenticatedStack />
}
