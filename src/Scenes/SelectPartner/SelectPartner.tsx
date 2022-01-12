import { Button, Flex, Text } from "palette"
import { GlobalStore } from "@store/GlobalStore"

import React from "react"

export const SelectPartner = () => {
  return (
    <Flex flex={1} justifyContent="center" alignItems="center" backgroundColor="white">
      <Button
        onPress={() => {
          GlobalStore.actions.setActivePartnerID("test")
        }}
      >
        Set a partner ID
      </Button>
    </Flex>
  )
}
