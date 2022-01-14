import { NavigationProp, useNavigation } from "@react-navigation/native"
import { StackScreenProps } from "@react-navigation/stack"
import { MainAuthenticatedStackProps } from "@routes/AuthenticatedNavigationStacks"
import { Avatar, Flex, Message, Separator, Text, Touchable } from "palette"
import { ActivityIndicator, FlatList, Image } from "react-native"
import { useSafeAreaFrame } from "react-native-safe-area-context"
import React from "react"
import { graphql, useLazyLoadQuery } from "react-relay"
import { ArtistScreenQuery } from "__generated__/ArtistScreenQuery.graphql"
import { GlobalStore } from "@store/GlobalStore"
import { extractNodes } from "@helpers/utils/extractNodes"

interface ArtistHeaderProps {
  artist: NonNullable<ArtistScreenQuery["response"]["artist"]>
}
export const ArtistHeader: React.FC<ArtistHeaderProps> = ({ artist }) => {
  return (
    <Flex backgroundColor="white" mb={2} justifyContent="center">
      <Flex p={1} flexDirection="row" alignItems="center">
        <Avatar src={artist?.imageUrl!} size="md" initials={artist?.imageUrl ? "" : artist?.initials!} />
        <Flex ml={1}>
          <Text variant="sm">{artist?.displayLabel}</Text>
          <Text variant="sm" color="black60">
            {artist?.formattedNationalityAndBirthday || "-"}
          </Text>
          <Text variant="xs">{artist?.formattedArtworksCount || "-"}</Text>
        </Flex>
      </Flex>
      <Separator />
    </Flex>
  )
}

interface ArtworkThumbnailProps {
  artwork: NonNullable<
    NonNullable<
      NonNullable<
        NonNullable<NonNullable<ArtistScreenQuery["response"]["artist"]>["filterArtworksConnection"]>["edges"]
      >[0]
    >["node"]
  >
}
export const ArtworkThumbnail: React.FC<ArtworkThumbnailProps> = ({ artwork }) => {
  const navigation = useNavigation<NavigationProp<MainAuthenticatedStackProps>>()
  const width = Math.floor(useSafeAreaFrame().width / 2) - 20
  return (
    <Touchable
      onPress={() => {
        navigation.navigate("Artwork", { id: artwork.internalID })
      }}
    >
      <Flex flexDirection="column" width={width}>
        <Image source={{ uri: artwork.imageUrl! }} style={{ width, height: width }} />
        <Text variant="sm">{artwork.artistNames}</Text>
        <Text variant="xs" color="black60">
          {artwork.title}, {artwork.date}
        </Text>
      </Flex>
    </Touchable>
  )
}

interface Artist {
  id: string
}

export const Artist: React.FC<Artist> = ({ id }) => {
  const partnerID = GlobalStore.useAppState((state) => state.activePartnerID)!

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
                href
                artistNames
                title
                date
              }
            }
          }
        }
      }
    `,
    { partnerID, artistID: id }
  )

  if (!data.artist) {
    return <Text textAlign="center">Artist Unavailable</Text>
  }

  const artworks = extractNodes(data.artist?.filterArtworksConnection)

  const width = useSafeAreaFrame().width - 20
  return (
    <Flex flex={1} justifyContent="center" alignItems="center" backgroundColor="white" px={2}>
      <FlatList
        data={artworks}
        renderItem={({ item: artwork }) => <ArtworkThumbnail artwork={artwork} />}
        keyExtractor={(item) => item?.internalID!}
        numColumns={2}
        style={{ width }}
        columnWrapperStyle={{ flex: 1, justifyContent: "space-around", width, marginBottom: 20 }}
        stickyHeaderIndices={[0]}
        ListHeaderComponent={<ArtistHeader artist={data?.artist!} />}
        ListEmptyComponent={<Message p={2} textAlign="center" alignItems="center">No artworks available</Message>}
      />
    </Flex>
  )
}

interface ArtistScreenProps extends StackScreenProps<MainAuthenticatedStackProps, "Artist"> {}

export const ArtistScreen: React.FC<ArtistScreenProps> = ({ route }) => {
  const { id } = route.params
  return (
    <React.Suspense
      fallback={() => (
        <Flex flex={1} justifyContent="center" alignItems="center">
          <ActivityIndicator />
        </Flex>
      )}
    >
      <Artist id={id} />
    </React.Suspense>
  )
}
