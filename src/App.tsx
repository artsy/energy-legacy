import { Flex, Theme } from "palette"
import React from "react"
import { Text } from "react-native"

const App = () => {
  return (
    <Theme>
      <Flex flex={1} justifyContent="center" alignItems="center">
        <Text>Works</Text>
      </Flex>
    </Theme>
  )
}

export default App
