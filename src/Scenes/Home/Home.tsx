import React from "react"
import { Flex, Button } from "palette"
import { NativeStackScreenProps } from "@react-navigation/native-stack"
import { MainNavigationStack } from "MainNavigationStack"
import { GlobalStore } from "../../store/GlobalStore"

interface HomeNavigationProps extends NativeStackScreenProps<MainNavigationStack, "Home"> {}

export const HomeScreen: React.FC<HomeNavigationProps> = ({}) => (
  <Flex flex={1} justifyContent="center" alignItems="center">
    <Button
      onPress={async () => {
        await GlobalStore.actions.auth.signOut()
      }}
    >
      Do nothing
    </Button>
  </Flex>
)
