import { StackScreenProps } from "@react-navigation/stack"
import { Avatar, Flex, Message, Separator, Text, Touchable } from "palette"
import React from "react"
import { MainAuthenticatedStackProps, TabNavigatorStack } from "@routes/AuthenticatedNavigationStacks"
import { CompositeScreenProps, useRoute, RouteProp } from "@react-navigation/native"
import { BottomTabScreenProps } from "@react-navigation/bottom-tabs"
import { graphql, useLazyLoadQuery } from "react-relay"
import { ArtistScreenQuery } from "__generated__/ArtistScreenQuery.graphql"
import { GlobalStore } from "@store/GlobalStore"
import { extractNodes } from "@helpers/utils/extractNodes"
import { ActivityIndicator, FlatList, Image } from "react-native"
import { useSafeAreaFrame } from "react-native-safe-area-context"

interface ArtistHeaderProps {
  artist: NonNullable<ArtistScreenQuery["response"]["artist"]>
}
export const ArtistHeader: React.FC<ArtistHeaderProps> = ({artist}) => {
  return (
    <Flex backgroundColor="white" mb={2} justifyContent="center">
      <Flex
        p={1}
        flexDirection="row"
        alignItems="center"
      >
        <Avatar
          src={artist?.imageUrl!}
          size="md"
          initials={artist?.imageUrl ? "" : artist?.initials!}
        />
        <Flex ml={1}>
          <Text variant="sm">{artist?.displayLabel}</Text>
          <Text variant="sm" color="black60">{artist?.formattedNationalityAndBirthday || "-"}</Text>
          <Text variant="xs">{artist?.formattedArtworksCount  || "-"}</Text>
        </Flex>
      </Flex>
      <Separator />
    </Flex>
  )
}

interface ArtworkThumbnailProps {
  artwork: NonNullable<NonNullable<NonNullable<NonNullable<NonNullable<ArtistScreenQuery["response"]["artist"]>["filterArtworksConnection"]>["edges"]>[0]>["node"]>
}
export const ArtworkThumbnail: React.FC<ArtworkThumbnailProps> = ({artwork}) => {
  const width = Math.floor(useSafeAreaFrame().width/2) - 20
  return (
    <Touchable onPress={() => {}}>
      <Flex alignItems="center" flexDirection="column" width={width}>
        <Image source={{ uri: artwork.imageUrl! }} style={{width, height: width}} />
      </Flex>
    </Touchable>
  )
}

interface ArtistScreenProps
  extends CompositeScreenProps<
    BottomTabScreenProps<TabNavigatorStack, "Artists">,
    StackScreenProps<MainAuthenticatedStackProps, "Artist">
  > {}

export const Artist: React.FC = () => {
  const partnerID = GlobalStore.useAppState((state) => state.activePartnerID)!
  const route = useRoute<RouteProp<MainAuthenticatedStackProps>>()
  const artistID = route.params?.artistID!
  const data = useLazyLoadQuery<ArtistScreenQuery>(
    graphql`
      query ArtistScreenQuery($partnerID: ID!, $artistID: String!) {
        artist(id: $artistID) {
          imageUrl
          displayLabel
          formattedNationalityAndBirthday
          formattedArtworksCount
          initials
          filterArtworksConnection(first: 20, partnerID: $partnerID) {
          	edges {
              node {
                internalID
                displayLabel
                imageUrl
                imageTitle
              }
            }
        	}
        }
      }
    `,
    { partnerID, artistID }
  )

  const artworks = extractNodes(data.artist?.filterArtworksConnection)

  const width = useSafeAreaFrame().width - 20
  return (
    <Flex flex={1} justifyContent="center" alignItems="center" backgroundColor="white" px={2}>
      <FlatList
        data={artworks}
        renderItem={({item: artwork}) => <ArtworkThumbnail artwork={artwork} />}
        keyExtractor={(item) => item?.internalID!}
        numColumns={2}
        style={{width}}
        columnWrapperStyle={{ flex: 1, justifyContent: "space-around", width, marginBottom: 10}}
        stickyHeaderIndices={[0]}
        ListHeaderComponent={<ArtistHeader artist={data?.artist!} />}
        ListEmptyComponent={<Message p={2} textAlign="center" alignItems="center">No artworks available</Message>}
      />
    </Flex>
  )
}

export const ArtistScreen: React.FC<ArtistScreenProps> = () => (
  <React.Suspense
    fallback={() => (
      <Flex flex={1} justifyContent="center" alignItems="center">
        <ActivityIndicator />
      </Flex>
    )}
  >
    <Artist/>
  </React.Suspense>
)
