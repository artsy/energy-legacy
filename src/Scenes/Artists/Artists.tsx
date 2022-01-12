import { BottomTabScreenProps } from "@react-navigation/bottom-tabs"
import { TabNavigatorStack } from "@routes/AuthenticatedNavigationStacks"
import { Flex, Text } from "palette"
import React from "react"

export interface ArtistsScreenProps extends BottomTabScreenProps<TabNavigatorStack, "Artists"> {}

export const ArtistsScreen: React.FC<ArtistsScreenProps> = () => {
  return (
    <Flex flex={1} justifyContent="center" alignItems="center" backgroundColor="white">
      <Text>Artists Screen</Text>
    </Flex>
  )
}
