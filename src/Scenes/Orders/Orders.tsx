import { BottomTabScreenProps } from "@react-navigation/bottom-tabs"
import { TabNavigatorStack } from "@routes/AuthenticatedNavigationStacks"
import { Flex, Message, Separator, Pill, Text, Touchable } from "palette"
import React, { useCallback, useEffect, useState } from "react"
import { ActivityIndicator, FlatList, Image } from "react-native"
import { useSafeAreaFrame } from "react-native-safe-area-context"
import { graphql, useLazyLoadQuery, FetchPolicy } from "react-relay"
import { OrdersScreenQuery } from "__generated__/OrdersScreenQuery.graphql"
import { GlobalStore } from "@store/GlobalStore"
import { extractNodes } from "@helpers/utils/extractNodes"
import { calculateTimeRemaining } from "@helpers/utils/time"
import { StatusBadge } from "./components/StatusBadge"

// TYPES
const stateFilters = {
  SUBMITTED: "Open",
  APPROVED: "Ready to ship",
  FULFILLED: "Complete",
  CANCELED: "Canceled"
}

export type OrderType = NonNullable<
  NonNullable<
    NonNullable<
      NonNullable<OrdersScreenQuery["response"]["commerceOrders"]>["edges"]
    >[0]
  >["node"]
>

type StateNameType = keyof typeof stateFilters
interface RefreshQueryState {
  fetchKey: any
  fetchPolicy: FetchPolicy | undefined
}

// ORDER
interface OrderRowProps {
  order: OrderType
}
export const OrderRow: React.FC<OrderRowProps> = ({order}) => {
  const lineItem = extractNodes(order?.lineItems)[0]
  const artwork = lineItem?.artwork

  const { width } = useSafeAreaFrame()

  return (
    <Touchable onPress={() => {}}>
      <Flex flexDirection="row" alignItems="flex-start" justifyContent="space-between" width={width} p={1}>
        <Flex flexDirection="row">
          <Image source={{uri: artwork?.image?.resized?.url!}} style={{ width: 50, height: 50, marginRight: 10 }}/>
          <Flex>
            <Text variant="xs">{artwork?.artistNames!}</Text>
            <Text variant="xs" color="black60">#{order?.code}</Text>
          </Flex>
        </Flex>
        <Flex>
          <StatusBadge order={order}/>
          {!!order?.stateExpiresAt && <Text variant="xs" textAlign="right">Expires: {calculateTimeRemaining(order?.stateExpiresAt!)}</Text>}
        </Flex>
      </Flex>
    </Touchable>
  )
}

// FILTERS
interface FilterHeaderProps {
  onChange: (value: StateNameType) => void
  active: StateNameType
}
export const FilterHeader: React.FC<FilterHeaderProps> = ({ active, onChange }) => {
  const { width } = useSafeAreaFrame()
  return (
    <>
      <Flex flexDirection="row" alignItems="center" justifyContent="center" bg="white" width={width} p={1}>
        {(Object.keys(stateFilters) as Array<StateNameType>).map(state => <Pill onPress={() => { onChange(state) }} key={state} rounded selected={active === state} mx={0.5}>{stateFilters[state]}</Pill>)}
      </Flex>
      <Separator/>
    </>
  )
}

// ORDERS
export interface OrdersScreenProps extends BottomTabScreenProps<TabNavigatorStack, "Orders"> {}
interface OrdersProps {
  refresh: () => void
  queryOptions: RefreshQueryState | {}
}
export const Orders: React.FC<OrdersProps> = ({refresh, queryOptions}) => {
  const [filterState, setFilterState] = useState<StateNameType>("SUBMITTED")
  useEffect(() => {
    refresh()
  }, [filterState])

  const partnerID = GlobalStore.useAppState((state) => state.activePartnerID)!
  const data = useLazyLoadQuery<OrdersScreenQuery>(
    graphql`
      query OrdersScreenQuery($partnerID: String!, $states: [CommerceOrderStateEnum!], $sort: CommerceOrderConnectionSortEnum) {
        commerceOrders(sellerId: $partnerID, states: $states, first: 10, sort: $sort) @optionalField {
          totalCount
          edges {
            node {
              internalID
              code
              displayState
              stateUpdatedAt(format: "MMM D")
              stateExpiresAt
              requestedFulfillment {
                __typename
              }
              mode
              lineItems(first: 1) {
                edges {
                  node {
                    artwork {
                      image {
                        resized(height: 50, version: ["square"]) {
                          url
                        }
                      }
                      artistNames
                    }
                  }
                }
              }
              ... on CommerceOfferOrder {
                awaitingResponseFrom
              }
            }
          }
        }
      }
    `,
    { partnerID, states: [filterState], sort: filterState == 'APPROVED' ? 'STATE_EXPIRES_AT_ASC' : 'STATE_UPDATED_AT_DESC' },
    queryOptions
  )

  const orders = extractNodes(data.commerceOrders)

  return (
    <Flex flex={1} justifyContent="center" alignItems="center" backgroundColor="white">
      <FlatList
        data={orders}
        renderItem={({ item: order }) => <OrderRow order={order} />}
        keyExtractor={(item) => item?.internalID!}
        stickyHeaderIndices={[0]}
        ListHeaderComponent={<FilterHeader active={filterState} onChange={setFilterState}/>}
        ItemSeparatorComponent={Separator}
        ListFooterComponent={!!orders.length ? <Separator/> : null}
        ListEmptyComponent={<Message p={2} textAlign="center" alignItems="center">There are no {stateFilters[filterState].toLowerCase()} orders</Message>}
      />
    </Flex>
  )
}

// SCREEN
export const OrdersScreen: React.FC<OrdersScreenProps> = () => {
  const [refreshedQueryOptions, setRefreshedQueryOptions] = useState<RefreshQueryState | null>(null)
  const refresh = useCallback(() => {
    setRefreshedQueryOptions(prev => ({
      fetchKey: (prev?.fetchKey ?? 0) + 1,
      fetchPolicy: 'network-only',
    }))
  }, []);
  return (
    <React.Suspense
    fallback={() => (
      <Flex flex={1} justifyContent="center" alignItems="center">
        <ActivityIndicator />
      </Flex>
    )}
    >
      <Orders
        refresh={refresh}
        queryOptions={refreshedQueryOptions ?? {}}
      />
    </React.Suspense>
  )
}
