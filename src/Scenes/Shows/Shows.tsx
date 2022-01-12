import { BottomTabScreenProps } from "@react-navigation/bottom-tabs"
import { TabNavigatorStack } from "@routes/AuthenticatedNavigationStacks"
import { Flex, Text } from "palette"
import React from "react"

export interface ShowsScreenProps extends BottomTabScreenProps<TabNavigatorStack, "Shows"> {}

export const ShowsScreen = () => {
  return (
    <Flex flex={1} justifyContent="center" alignItems="center" backgroundColor="white">
      <Text>Shows Screen</Text>
    </Flex>
  )
}
