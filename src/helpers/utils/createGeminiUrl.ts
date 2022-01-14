import { Platform } from "react-native"

export function createGeminiUrl({
  imageURL,
  width,
  height,
  geminiHost = "d7hftxdivxxvm.cloudfront.net",
  imageQuality = 80,
  resizeMode = "fit",
}: {
  imageURL: string
  width: number
  height: number
  geminiHost?: string
  imageQuality?: number
  resizeMode?: "fit" | "fill"
}) {
  const src = encodeURIComponent(imageURL)

  const params = [
    `height=${height}`,
    `quality=${imageQuality}`,
    `resize_to=${resizeMode}`,
    `src=${src}`,
    `width=${width}`,
  ]

  return `https://${geminiHost}/?${params.join("&")}`
}
