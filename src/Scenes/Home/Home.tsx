import React from "react"
import { Flex, Button } from "palette"
import { NativeStackScreenProps } from "@react-navigation/native-stack"
import { MainNavigationStack } from "MainNavigationStack"

interface HomeNavigationProps extends NativeStackScreenProps<MainNavigationStack, "Home"> {}

export const HomeScreen: React.FC<HomeNavigationProps> = ({ navigation }) => (
  <Flex flex={1} justifyContent="center" alignItems="center">
    <Button onPress={() => navigation.navigate("Login")}>Navigate to Login Screen</Button>
  </Flex>
)
