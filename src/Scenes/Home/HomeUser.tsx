import { Flex, Text } from "palette"
import React from "react"
import { graphql, useFragment } from "react-relay"
import { HomeUser_me$key } from "__generated__/HomeUser_me.graphql"

interface HomeUserProps {
  me: HomeUser_me$key
}

const HomeUserFragment = graphql`
  fragment HomeUser_me on Me {
    email
    name
  }
`

export const HomeUser: React.FC<HomeUserProps> = (props) => {
  const me = useFragment(HomeUserFragment, props.me)

  if (!me) {
    return <Text>Failed to make query</Text>
  }
  return (
    <Flex>
      <Text>{me.email}</Text>
      <Text>{me.name}</Text>
    </Flex>
  )
}
