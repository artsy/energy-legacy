import { BottomTabScreenProps } from "@react-navigation/bottom-tabs"
import { CompositeScreenProps } from "@react-navigation/native"
import { StackScreenProps } from "@react-navigation/stack"
import { MainAuthenticatedStackProps, TabNavigatorStack } from "@routes/AuthenticatedNavigationStacks"
import { Button, Flex } from "palette"
import React from "react"

interface ArtistsScreenProps
  extends CompositeScreenProps<
    BottomTabScreenProps<TabNavigatorStack, "Artists">,
    StackScreenProps<MainAuthenticatedStackProps, "TabNavigatorStack">
  > {}

export const ArtistsScreen: React.FC<ArtistsScreenProps> = ({ navigation, route }) => {
  return (
    <Flex flex={1} justifyContent="center" alignItems="center" backgroundColor="white">
      <Button
        onPress={() => {
          navigation.navigate("Settings")
        }}
      >
        Go to settings
      </Button>
    </Flex>
  )
}
