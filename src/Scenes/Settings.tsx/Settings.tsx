import { StackScreenProps } from "@react-navigation/stack"
import { Flex, Button } from "palette"
import React from "react"
import { MainAuthenticatedStackProps, TabNavigatorStack } from "@routes/AuthenticatedNavigationStacks"
import { CompositeScreenProps } from "@react-navigation/native"
import { BottomTabScreenProps } from "@react-navigation/bottom-tabs"
import { GlobalStore } from "@store/GlobalStore"

interface SettingsScreenProps
  extends CompositeScreenProps<
    BottomTabScreenProps<TabNavigatorStack, "Artists">,
    StackScreenProps<MainAuthenticatedStackProps, "Settings">
  > {}

export const SettingsScreen: React.FC<SettingsScreenProps> = () => {
  return (
    <Flex flex={1} justifyContent="center" alignItems="center" backgroundColor="white">
      <Button
        onPress={() => {
          GlobalStore.actions.setActivePartnerID(null)
        }}
      >
        Change Partner
      </Button>
    </Flex>
  )
}
