import { Flex, Text } from "palette"
import React from "react"
import { BottomTabScreenProps } from "@react-navigation/bottom-tabs"
import { TabNavigatorStack } from "@routes/AuthenticatedNavigationStacks"

export interface AlbumsScreenProps extends BottomTabScreenProps<TabNavigatorStack, "Albums"> {}

export const AlbumsScreen = () => {
  return (
    <Flex flex={1} justifyContent="center" alignItems="center" backgroundColor="white">
      <Text>Albums Screen</Text>
    </Flex>
  )
}
