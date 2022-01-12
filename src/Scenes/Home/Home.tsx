import React from "react"
import { Flex, Button, Text } from "palette"
import { NativeStackScreenProps } from "@react-navigation/native-stack"
import { MainNavigationStack } from "MainNavigationStack"
import { graphql, useLazyLoadQuery } from "react-relay"
import { HomeUser } from "./HomeUser"
import { HomeQuery } from "__generated__/HomeQuery.graphql"
import { GlobalStore } from "@store/GlobalStore"

interface HomeNavigationProps extends NativeStackScreenProps<MainNavigationStack, "Home"> {}

export const HomeScreen: React.FC<HomeNavigationProps> = ({}) => {
  const data = useLazyLoadQuery<HomeQuery>(
    graphql`
      query HomeQuery {
        me {
          ...HomeUser_me
        }
      }
    `,
    {}
  )

  if (!data?.me) {
    return <Text>Query Failed</Text>
  }
  return (
    <Flex flex={1} justifyContent="center" alignItems="center">
      <HomeUser me={data.me} />
      <Button
        onPress={() => {
          GlobalStore.actions.auth.signOut()
        }}
      >
        Log out
      </Button>
    </Flex>
  )
}
