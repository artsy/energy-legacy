import { GlobalStore } from "@store/GlobalStore"
import { compact } from "lodash"
import { Flex, Spacer, Text } from "palette"
import React from "react"
import { ActivityIndicator, FlatList, TouchableOpacity } from "react-native"
import { SafeAreaView, useSafeAreaFrame } from "react-native-safe-area-context"
import { graphql, useLazyLoadQuery } from "react-relay"
import { SelectPartnerQuery } from "__generated__/SelectPartnerQuery.graphql"

type Partners = NonNullable<NonNullable<SelectPartnerQuery["response"]["me"]>["partners"]>
interface SelectPartnerProps {
  partners: Partners
}

export const SelectPartner: React.FC<SelectPartnerProps> = ({ partners }) => {
  const { width } = useSafeAreaFrame()

  return (
    <SafeAreaView style={{ flex: 1, justifyContent: "center", alignItems: "center", backgroundColor: "white" }}>
      <FlatList
        data={compact(new Array(20).fill(partners[0]))}
        keyExtractor={(item) => item.id}
        renderItem={({ item: partner }) => {
          return <PartnerRow partner={partner} />
        }}
        ItemSeparatorComponent={() => <Spacer mt={2} />}
        stickyHeaderIndices={[0]}
        ListHeaderComponent={() => (
          <Flex
            width={width}
            height={100}
            backgroundColor="white"
            justifyContent="center"
            borderTopWidth={1}
            borderBottomWidth={2}
            mb={2}
          >
            <Text variant="md" textAlign="center">
              Select a partner to continue
            </Text>
          </Flex>
        )}
        contentContainerStyle={{ width: width - 20 }}
        showsVerticalScrollIndicator={false}
      />
    </SafeAreaView>
  )
}

interface PartnerRow {
  partner: NonNullable<Partners[0]>
}

const PartnerRow: React.FC<PartnerRow> = ({ partner }) => (
  <TouchableOpacity
    onPress={() => {
      GlobalStore.actions.setActivePartnerID(partner.id)
    }}
  >
    <Flex height={40} border={1} borderRadius={10} justifyContent="center" alignItems="center">
      <Text>{partner.name}</Text>
    </Flex>
  </TouchableOpacity>
)

export const SelectPartnerScreen = () => {
  const data = useLazyLoadQuery<SelectPartnerQuery>(
    graphql`
      query SelectPartnerQuery {
        me {
          partners {
            name
            id
          }
        }
      }
    `,
    {}
  )

  console.log("data => ", data)

  return (
    <React.Suspense
      fallback={() => (
        <Flex flex={1} justifyContent="center" alignItems="center">
          <ActivityIndicator />
        </Flex>
      )}
    >
      {!data.me ? <Text>No Partners Available</Text> : <SelectPartner partners={data.me.partners} />}
    </React.Suspense>
  )
}
