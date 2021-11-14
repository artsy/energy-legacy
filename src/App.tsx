import React from "react"
import { Theme, Flex, Text } from "palette"

const App = () => {
  return (
    <Theme>
      <Flex flex={1} justifyContent="center" alignItems="center">
        <Text variant="md">Fonts work!</Text>
      </Flex>
    </Theme>
  )
}

export default App
