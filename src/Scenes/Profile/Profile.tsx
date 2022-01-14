import { BottomTabScreenProps } from "@react-navigation/bottom-tabs"
import { TabNavigatorStack } from "@routes/AuthenticatedNavigationStacks"
import { useNavigation } from "@react-navigation/native"
import { StackNavigationProp } from "@react-navigation/stack"
import { MainAuthenticatedStackProps } from "@routes/AuthenticatedNavigationStacks"
import {
  BarChart,
  LineChart
} from "react-native-chart-kit"
import { Flex, Separator, SettingsIcon, Text, Touchable } from "palette"
import { ActivityIndicator, ScrollView } from "react-native"
import { useSafeAreaFrame } from "react-native-safe-area-context"
import React from "react"
import { graphql, useLazyLoadQuery } from "react-relay"
import { ProfileTopWorksQuery } from "__generated__/ProfileTopWorksQuery.graphql"
import { GlobalStore } from "@store/GlobalStore"
import { extractNodes } from "@helpers/utils/extractNodes"
import { ArtworkThumbnail } from "@Scenes/Artist/Artist"

const TopWorks: React.FC = () => {
  const partnerID = GlobalStore.useAppState((state) => state.activePartnerID)!

  const data = useLazyLoadQuery<ProfileTopWorksQuery>(
    graphql`
      query ProfileTopWorksQuery($partnerID: String!) {
        partner(id: $partnerID) {
          artworksConnection(first: 2, sort: MERCHANDISABILITY_DESC) {
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
    { partnerID }
  )
  const artworks = extractNodes(data.partner?.artworksConnection)
  const width = useSafeAreaFrame().width
  return (
    <Flex width={width} p={1}>
      <Text mb={2} variant="md">Top works this week</Text>
      <Flex flexDirection="row" justifyContent="space-between">
        {artworks.map((artwork) => <ArtworkThumbnail artwork={artwork} />)}
      </Flex>
    </Flex>
  )
}

const Activity: React.FC = () => {
  const { width } = useSafeAreaFrame()
  const data = {
      labels: ["Jul 15", "Jul 21", "Jul 28", "Aug 04", "Aug 11"],
      datasets: [
        {
          data: [Math.random(), Math.random(), Math.random(), Math.random(), Math.random(), Math.random(), Math.random(), Math.random()],
          colors: new Array(8).fill(() => `#e5e5e5`),
        }
      ]
    }
  return (
    <Flex width={width} p={1}>
      <Text mb={2} variant="md">Activity</Text>
      <Flex>
        <Text variant="lg">10,000</Text>
        <Text variant="xs" color="black60">Total views</Text>
        <Text color="green100" variant="xs">+61% from prev. period</Text>
      </Flex>
      <BarChart
        data={data}
        width={width + 60}
        height={120}
        yAxisLabel=""
        yAxisSuffix=""
        withInnerLines={false}
        chartConfig={{
          backgroundColor: "#ffffff",
          backgroundGradientFrom: "#ffffff",
          backgroundGradientTo: "#ffffff",
          color: (opacity = 1) => `rgba(0, 0, 0, ${opacity})`,
          labelColor: (opacity = 1) => `rgba(0, 0, 0, ${opacity})`,
          barPercentage: 1.3,
          barRadius: 3,
          fillShadowGradientOpacity: 1,
          fillShadowGradient: "#e5e5e5",
        }}
        showBarTops={false}
        withVerticalLabels={true}
        withHorizontalLabels={false}
        fromZero={true}
        flatColor={true}
        withCustomBarColorFromData={true}
        style={{ marginLeft: -85 }}
      />
    </Flex>
  )
}

const Sales: React.FC = () => {
  const { width } = useSafeAreaFrame()
  const data = {
      labels: ["Jul 15", "Jul 21", "Jul 28", "Aug 04", "Aug 11"],
      datasets: [
        {
          data: [Math.random(), Math.random(), Math.random(), Math.random(), Math.random(), Math.random(), Math.random(), Math.random()],
          colors: new Array(8).fill(() => `#e5e5e5`),
        }
      ]
    }
  return (
    <Flex width={width} p={1}>
      <Text mb={2} variant="md">Sales</Text>
      <Flex>
        <Text variant="lg">$5,150</Text>
        <Text variant="xs" color="black60">Total sales from Buy Now / Make Offer</Text>
      </Flex>
      <LineChart
        data={data}
        width={width + 60}
        height={120}
        yAxisLabel=""
        yAxisSuffix=""
        withInnerLines={false}
        chartConfig={{
          backgroundColor: "#ffffff",
          backgroundGradientFrom: "#ffffff",
          backgroundGradientTo: "#ffffff",
          color: () => `rgba(0, 0, 0, 0.2)`,
          labelColor: () => `rgba(0, 0, 0, 0.2)`,
          barPercentage: 1.3,
          barRadius: 3,
          fillShadowGradientOpacity: 1,
          fillShadowGradient: "#e5e5e5",
        }}
        withVerticalLabels={true}
        withHorizontalLabels={false}
        withVerticalLines={false}
        withHorizontalLines={false}
        fromZero={true}
        style={{ marginLeft: -55 }}
        withShadow={false}
        getDotColor={() => `rgba(209, 209, 209, 1)`}
      />
    </Flex>
  )
}

export const Profile: React.FC = () => {
  return (
    <ScrollView style={{backgroundColor: "white"}}>
      <Flex flex={1} justifyContent="flex-start" alignItems="center" bg="white" p={1}>
        <TopWorks/>
        <Separator my={2} />
        <Activity />
        <Separator my={2} />
        <Sales />
      </Flex>
    </ScrollView>
  )
}

export interface ProfileScreenProps extends BottomTabScreenProps<TabNavigatorStack, "Profile"> {}

export const ProfileScreen: React.FC<ProfileScreenProps> = () => {
  const navigation = useNavigation<StackNavigationProp<MainAuthenticatedStackProps>>()
  return (
    <React.Suspense
      fallback={() => (
        <Flex flex={1} justifyContent="center" alignItems="center">
          <ActivityIndicator />
        </Flex>
      )}
    >
      <Flex flexDirection="row" bg="white" alignContent="flex-end" justifyContent="flex-end">
        <Touchable onPress={() => navigation.navigate("Settings")}>
          <SettingsIcon p={1} m={1} />
        </Touchable>
      </Flex>
      <Profile />
    </React.Suspense>
  )
}
