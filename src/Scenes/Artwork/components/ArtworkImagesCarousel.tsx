import { createGeminiUrl } from "@helpers/utils/createGeminiUrl"
import { useSizeToFitScreen } from "@helpers/utils/useSizeToFit"
import { compact } from "lodash"
import { Flex } from "palette"
import React, { useRef } from "react"
import { Dimensions, FlatList, Image } from "react-native"
import { graphql, useFragment } from "react-relay"
import {
  ArtworkImagesCarousel_images,
  ArtworkImagesCarousel_images$key,
} from "__generated__/ArtworkImagesCarousel_images.graphql"

interface ArtworkImagesCarouselProps {
  images: ArtworkImagesCarousel_images$key
}

const ArtworkImagesCarouselFragment = graphql`
  fragment ArtworkImagesCarousel_images on Image @relay(plural: true) {
    imageURL
    width
    height
    imageVersions
  }
`

export const ArtworkImagesCarousel: React.FC<ArtworkImagesCarouselProps> = (props) => {
  const images = useFragment(ArtworkImagesCarouselFragment, props.images)

  return (
    <FlatList
      data={images}
      scrollEventThrottle={0.0000000001}
      keyExtractor={(item) => item.url!}
      renderItem={({ item: image, index }) => {
        return <ArtworkImage image={image} />
      }}
      horizontal
      pagingEnabled
    />
  )
}

const IMAGE_CAROUSEL_HEIGHT = 340

interface ArtworkImageProps {
  image: ArtworkImagesCarousel_images[0]
}

const ArtworkImage: React.FC<ArtworkImageProps> = ({ image }) => {
  const { width: screenWidth } = Dimensions.get("window")

  const { height, width } = useSizeToFitScreen(
    { height: image.height!, width: image.width! },
    { height: IMAGE_CAROUSEL_HEIGHT, width: screenWidth }
  )

  return (
    <Flex
      style={[
        {
          width: screenWidth,
          height: IMAGE_CAROUSEL_HEIGHT,
          justifyContent: "center",
          alignItems: "center",
        },
      ]}
    >
      <Image
        source={{
          uri: createGeminiUrl({
            imageURL: image.imageURL!.replace(
              ":version",
              getBestImageVersionForThumbnail(compact(image.imageVersions!))
            ),
            // upscale to match screen resolution
            width,
            height,
          }),
        }}
        style={{ width, height }}
      />
    </Flex>
  )
}

const imageVersionsSortedBySize = ["normalized", "larger", "large", "medium", "small"] as const

// we used to rely on there being a "normalized" version of every image, but that
// turns out not to be the case, so in those rare situations we order the image versions
// by size and pick the largest avaialable. These large images will then be resized by
// gemini for the actual thumbnail we fetch.
function getBestImageVersionForThumbnail(imageVersions: readonly string[]) {
  for (const size of imageVersionsSortedBySize) {
    if (imageVersions.includes(size)) {
      return size
    }
  }

  if (!__DEV__) {
    console.log("No appropriate image size found for artwork (see breadcrumbs for artwork slug)")
  } else {
    console.warn("No appropriate image size found!")
  }

  // doesn't really matter what we return here, the gemini image url
  // will fail to load and we'll see a gray square. I haven't come accross an image
  // that this will happen for, but better safe than sorry.
  return "normalized"
}
