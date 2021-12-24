import React from "react"
import { Flex, Button } from "palette"
import { MainNavigationStack } from "MainNavigationStack"
import { NativeStackScreenProps } from "@react-navigation/native-stack"

interface LoginNavigationProps extends NativeStackScreenProps<MainNavigationStack, "Login"> {}

export const LoginScreen: React.FC<LoginNavigationProps> = ({ navigation }) => (
  <Flex flex={1} justifyContent="center" alignItems="center">
    <Button onPress={() => navigation.goBack()}>Navigate back to Home Screen</Button>
  </Flex>
)
