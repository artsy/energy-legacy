import { StackScreenProps } from "@react-navigation/stack"
import { MainAuthenticatedStackProps } from "@routes/AuthenticatedNavigationStacks"
import { Flex, Text } from "palette"
import React from "react"
import { ActivityIndicator, ScrollView } from "react-native"
import { graphql, useLazyLoadQuery } from "react-relay"
import { ArtworkScreenQuery } from "__generated__/ArtworkScreenQuery.graphql"
import { ArtworkHeader } from "./components/ArtworkHeader"

interface ArtworkProps {
  id: string
}

export const Artwork: React.FC<ArtworkProps> = ({ id }) => {
  const data = useLazyLoadQuery<ArtworkScreenQuery>(
    graphql`
      query ArtworkScreenQuery($id: String!) {
        artwork(id: $id) {
          title
          ...ArtworkHeader_artwork
        }
      }
    `,
    { id }
  )

  if (!data.artwork) {
    return (
      <Flex>
        <Text>Artwork Unavailable</Text>
      </Flex>
    )
  }
  return (
    <ScrollView contentContainerStyle={{ backgroundColor: "white", flexGrow: 1 }}>
      <ArtworkHeader artwork={data.artwork} />
    </ScrollView>
  )
}

interface ArtworkScreenProps extends StackScreenProps<MainAuthenticatedStackProps, "Artwork"> {}

export const ArtworkScreen: React.FC<ArtworkScreenProps> = ({ route }) => {
  const id = route.params.id
  return (
    <React.Suspense
      fallback={() => (
        <Flex flex={1} justifyContent="center" alignItems="center">
          <ActivityIndicator />
        </Flex>
      )}
    >
      <Artwork id={id} />
    </React.Suspense>
  )
}
