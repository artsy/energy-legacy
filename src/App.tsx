import React from "react"
import { Theme, Flex, Button, Text } from "palette"
import { NavigationContainer } from "@react-navigation/native"
import { createNativeStackNavigator, NativeStackScreenProps } from "@react-navigation/native-stack"
import { LogBox } from "react-native"
import Config from "react-native-config"

LogBox.ignoreLogs(["Expected style "])

interface HomeNavigationProps extends NativeStackScreenProps<AppNavigationStack, "Home"> {}

const HomeScreen: React.FC<HomeNavigationProps> = ({ navigation }) => (
  <Theme>
    <Flex flex={1} justifyContent="center" alignItems="center">
      <Button onPress={() => navigation.navigate("Login")}>Navigate to Login Screen</Button>
      <Text>{Config.CUSTOM_ENV_VAR}</Text>
      <Text>{Config.ARTSY_API_CLIENT_KEY}</Text>
    </Flex>
  </Theme>
)

interface LoginNavigationProps extends NativeStackScreenProps<AppNavigationStack, "Login"> {}

const LoginScreen: React.FC<LoginNavigationProps> = ({ navigation }) => (
  <Theme>
    <Flex flex={1} justifyContent="center" alignItems="center">
      <Button onPress={() => navigation.goBack()}>Navigate back to Home Screen</Button>
    </Flex>
  </Theme>
)

// tslint:disable-next-line:interface-over-type-literal
export type AppNavigationStack = {
  Home: undefined
  Login: undefined
}

const Stack = createNativeStackNavigator<AppNavigationStack>()

const App = () => {
  console.log(Config)
  return (
    <NavigationContainer>
      <Stack.Navigator screenOptions={{ headerShown: false }}>
        <Stack.Screen name="Home" component={HomeScreen} />
        <Stack.Screen name="Login" component={LoginScreen} />
      </Stack.Navigator>
    </NavigationContainer>
  )
}

export default App
