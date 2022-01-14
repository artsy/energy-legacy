import { Box, Spacer } from "palette"
import React from "react"
import { graphql, useFragment } from "react-relay"
import { ArtworkHeader_artwork$key } from "__generated__/ArtworkHeader_artwork.graphql"
import { ArtworkImagesCarousel } from "./ArtworkImagesCarousel"
import { ArtworkTombstoneFragmentContainer } from "./ArtworkTombstone"

interface ArtworkHeaderProps {
  artwork: ArtworkHeader_artwork$key
}

const ArtworkHeaderFragment = graphql`
  fragment ArtworkHeader_artwork on Artwork {
    ...ArtworkTombstone_artwork
    title
    href
    internalID
    slug
    artists {
      name
    }
    images {
      ...ArtworkImagesCarousel_images
    }
  }
`

export const ArtworkHeader: React.FC<ArtworkHeaderProps> = (props) => {
  const artwork = useFragment(ArtworkHeaderFragment, props.artwork)

  return (
    <>
      <Box>
        <ArtworkImagesCarousel images={artwork.images} />
        <Spacer mb={2} />
        <Box px={2}>
          <ArtworkTombstoneFragmentContainer artwork={artwork} />
        </Box>
      </Box>
    </>
  )
}
