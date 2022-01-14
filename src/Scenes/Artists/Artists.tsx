import { BottomTabScreenProps } from "@react-navigation/bottom-tabs"
import { CompositeScreenProps, useNavigation } from "@react-navigation/native"
import { StackScreenProps, StackNavigationProp } from "@react-navigation/stack"
import { MainAuthenticatedStackProps, TabNavigatorStack } from "@routes/AuthenticatedNavigationStacks"
import { Avatar, Button, Flex, Text, Touchable } from "palette"
import React from "react"
import { ActivityIndicator, FlatList } from "react-native"
import { useSafeAreaFrame } from "react-native-safe-area-context"
import { graphql, useLazyLoadQuery } from "react-relay"
import { ArtistsScreenQuery } from "__generated__/ArtistsScreenQuery.graphql"
import { GlobalStore } from "@store/GlobalStore"
import { extractNodes } from "@helpers/utils/extractNodes"

const ARTIST_CARD_WIDTH = 160

interface ArtistThumbnailProps {
  artist: NonNullable<
    NonNullable<
      NonNullable<
        NonNullable<NonNullable<ArtistsScreenQuery["response"]["partner"]>["allArtistsConnection"]>["edges"]
      >[0]
    >["node"]
  >
}

export const ArtistThumbnail: React.FC<ArtistThumbnailProps> = ({ artist }) => {
  const navigation = useNavigation<StackNavigationProp<MainAuthenticatedStackProps>>()
  return (
    <Touchable onPress={() => navigation.navigate("Artist", { id: artist.internalID })}>
      <Flex m={1} alignItems="center" flexDirection="column" width={ARTIST_CARD_WIDTH}>
        <Avatar src={artist.imageUrl!} size="md" initials={artist.imageUrl ? "" : artist.initials!} />
        <Text variant="sm">{artist.displayLabel}</Text>
        <Text variant="sm" color="black60">
          {artist.formattedNationalityAndBirthday || "-"}
        </Text>
        <Text variant="xs">{artist.formattedArtworksCount || "-"}</Text>
      </Flex>
    </Touchable>
  )
}

interface ArtistsScreenProps
  extends CompositeScreenProps<
    BottomTabScreenProps<TabNavigatorStack, "Artists">,
    StackScreenProps<MainAuthenticatedStackProps, "TabNavigatorStack">
  > {}

export const Artists: React.FC = () => {
  const partnerID = GlobalStore.useAppState((state) => state.activePartnerID)!
  const data = useLazyLoadQuery<ArtistsScreenQuery>(
    graphql`
      query ArtistsScreenQuery($partnerID: String!) {
        partner(id: $partnerID) {
          allArtistsConnection {
            totalCount
            edges {
              node {
                internalID
                imageUrl
                formattedNationalityAndBirthday
                displayLabel
                formattedArtworksCount
                initials
                slug
              }
            }
          }
        }
      }
    `,
    { partnerID }
  )

  const artists = extractNodes(data.partner?.allArtistsConnection)

  const navigation = useNavigation<StackNavigationProp<MainAuthenticatedStackProps>>()
  const { width } = useSafeAreaFrame()
  const numColumns = Math.floor(width / (ARTIST_CARD_WIDTH + 20))

  return (
    <Flex flex={1} justifyContent="center" alignItems="center" backgroundColor="white">
      <FlatList
        data={artists}
        renderItem={({ item: artist }) => <ArtistThumbnail artist={artist} />}
        keyExtractor={(item) => item?.internalID!}
        numColumns={numColumns}
        key={numColumns}
        columnWrapperStyle={{ flex: 1, justifyContent: "space-around", width }}
      />
      <Button onPress={() => navigation.navigate("Settings")}>Settings</Button>
    </Flex>
  )
}

export const ArtistsScreen: React.FC<ArtistsScreenProps> = () => (
  <React.Suspense
    fallback={() => (
      <Flex flex={1} justifyContent="center" alignItems="center">
        <ActivityIndicator />
      </Flex>
    )}
  >
    <Artists />
  </React.Suspense>
)
