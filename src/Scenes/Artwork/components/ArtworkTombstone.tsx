import { deviceLocale } from "@helpers/utils/deviceLocale"
import { NavigationProp, useNavigation } from "@react-navigation/native"
import { Box, Flex, Sans, Spacer } from "palette"
import React, { useState } from "react"
import { Text, TouchableWithoutFeedback } from "react-native"
import { createFragmentContainer, graphql } from "react-relay"
import { ArtworkTombstone_artwork } from "__generated__/ArtworkTombstone_artwork.graphql"
import { MainAuthenticatedStackProps } from "@routes/AuthenticatedNavigationStacks"

type Artist = NonNullable<NonNullable<ArtworkTombstone_artwork["artists"]>[0]>

export interface ArtworkTombstoneProps {
  artwork: ArtworkTombstone_artwork
}

const ArtworkTombstone: React.FC<ArtworkTombstoneProps> = ({ artwork }) => {
  const [showingMoreArtists, setShowingMoreArtists] = useState(false)
  const navigation = useNavigation<NavigationProp<MainAuthenticatedStackProps>>()

  const handleArtistTap = (internalID: string) => {
    navigation.navigate("Artist", { id: internalID })
  }

  const renderSingleArtist = (artist: Artist) => {
    return (
      <Text>
        {renderArtistName(artist.name!, artist.internalID)}
        <Sans size="4t" weight="medium">
          {"  "}·{"  "}
        </Sans>
      </Text>
    )
  }

  const renderArtistName = (artistName: string, internalID: string | null) => {
    return !!internalID ? (
      <TouchableWithoutFeedback onPress={() => handleArtistTap(internalID)}>
        <Sans size="4t" weight="medium">
          {artistName}
        </Sans>
      </TouchableWithoutFeedback>
    ) : (
      <Sans size="4t" weight="medium">
        {artistName}
      </Sans>
    )
  }

  const renderMultipleArtists = () => {
    const { artists } = artwork

    const truncatedArtists = !showingMoreArtists ? artists!.slice(0, 3) : artists
    const artistNames = truncatedArtists!.map((artist, index) => {
      const artistNameWithComma = index !== artists!.length - 1 ? artist!.name + ", " : artist!.name
      return (
        <React.Fragment key={artist!.href}>{renderArtistName(artistNameWithComma!, artist!.internalID)}</React.Fragment>
      )
    })

    return (
      <Flex flexDirection="row" flexWrap="wrap">
        <Sans size="4t">
          {artistNames}
          {!showingMoreArtists && artists!.length > 3 && (
            <TouchableWithoutFeedback onPress={() => setShowingMoreArtists(!showingMoreArtists)}>
              <Sans size="4t" weight="medium">
                {artists!.length - 3} more
              </Sans>
            </TouchableWithoutFeedback>
          )}
        </Sans>
      </Flex>
    )
  }

  const addedComma = artwork.date ? ", " : ""
  const displayAuctionLotLabel =
    artwork.isInAuction && artwork.saleArtwork && artwork.saleArtwork.lotLabel && artwork.sale && !artwork.sale.isClosed
  const firstArtistName = artwork.artists![0]
  return (
    <Box textAlign="left">
      <Flex flexDirection="row" flexWrap="wrap">
        {artwork.artists!.length === 1 ? renderSingleArtist(firstArtistName!) : renderMultipleArtists()}
        {!!(artwork.artists!.length === 0 && artwork.cultural_maker) && renderArtistName(artwork.cultural_maker, null)}
      </Flex>
      <Spacer mb={1} />
      {!!displayAuctionLotLabel && (
        <Sans color="black100" size="3" weight="medium">
          Lot {artwork.saleArtwork.lotLabel}
        </Sans>
      )}
      <Flex flexDirection="row" flexWrap="wrap">
        <Sans size="3">
          <Sans color="black60" size="3">
            {artwork.title + addedComma}
          </Sans>
          {!!artwork.date && (
            <Sans color="black60" size="3">
              {artwork.date}
            </Sans>
          )}
        </Sans>
      </Flex>
      {!!artwork.medium && (
        <Sans color="black60" size="3">
          {artwork.medium}
        </Sans>
      )}
      {!!artwork.dimensions!.in && !!artwork.dimensions!.cm && (
        <Sans color="black60" size="3">
          {deviceLocale === "en_US" ? artwork.dimensions!.in : artwork.dimensions!.cm}
        </Sans>
      )}
      {!!artwork.edition_of && (
        <Sans color="black60" size="3">
          {artwork.edition_of}
        </Sans>
      )}
      {!!artwork.attribution_class && (
        <Sans color="black60" size="3" mt={1}>
          <TouchableWithoutFeedback
            onPress={() => {
              // Navigate to classification page
            }}
          >
            <Text style={{ textDecorationLine: "underline" }}>{artwork.attribution_class.shortDescription}</Text>
          </TouchableWithoutFeedback>
          .
        </Sans>
      )}
      {!!artwork.isInAuction && !!artwork.sale && !artwork.sale.isClosed && (
        <>
          <Spacer mb={1} />
          {!!artwork.partner && (
            <Sans color="black100" size="3" weight="medium">
              {artwork.partner.name}
            </Sans>
          )}
          {!!artwork.saleArtwork && !!artwork.saleArtwork.estimate && (
            <Sans size="3" color="black60">
              Estimated value: {artwork.saleArtwork.estimate}
            </Sans>
          )}
        </>
      )}
    </Box>
  )
}

export const ArtworkTombstoneFragmentContainer = createFragmentContainer(ArtworkTombstone, {
  artwork: graphql`
    fragment ArtworkTombstone_artwork on Artwork {
      title
      isInAuction
      medium
      date
      cultural_maker: culturalMaker
      saleArtwork {
        lotLabel
        estimate
      }
      partner {
        name
      }
      sale {
        isClosed
      }
      artists {
        name
        href
        internalID
      }
      dimensions {
        in
        cm
      }
      edition_of: editionOf
      attribution_class: attributionClass {
        shortDescription
      }
    }
  `,
})
