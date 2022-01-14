import { StackScreenProps } from "@react-navigation/stack"
import { MainAuthenticatedStackProps } from "@routes/AuthenticatedNavigationStacks"
import { Flex, Text, useColor } from "palette"
import React from "react"
import { ActivityIndicator, ScrollView } from "react-native"
import { graphql, useLazyLoadQuery } from "react-relay"
import { ArtworkScreenQuery } from "__generated__/ArtworkScreenQuery.graphql"
import { ArtworkHeader } from "./components/ArtworkHeader"
import QRCode from "react-native-qrcode-svg"

interface ArtworkProps {
  id: string
}

export const Artwork: React.FC<ArtworkProps> = ({ id }) => {
  const color = useColor()
  const data = useLazyLoadQuery<ArtworkScreenQuery>(
    graphql`
      query ArtworkScreenQuery($id: String!) {
        artwork(id: $id) {
          title
          ...ArtworkHeader_artwork
          href
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
    <ScrollView contentContainerStyle={{ backgroundColor: "white", flexGrow: 1, paddingBottom: 50 }}>
      <ArtworkHeader artwork={data.artwork} />
      <Flex mt={2} alignItems="center">
        <QRCode
          size={250}
          value={"test"}
          logo={require("images/short-black-logo.png")}
          logoSize={40}
          color={color("black60")}
          logoBackgroundColor="white"
        />
      </Flex>
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
