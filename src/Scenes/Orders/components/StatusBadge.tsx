import { Color, Flex, Text } from "palette"
import React from "react"
import { OrderType } from "../Orders"

type StatusLabel =
  | "Ship order"
  | "Hold for collector"
  | "Confirm order"
  | "Review offer"
  | "Offer sent"
  | "Complete"
  | "Hold for ARTA"
  | "In transit"
  | "Shipping cancelled"

type StatusEnum =
  | "SUBMITTED"
  | "APPROVED"
  | "PROCESSING"
  | "IN_TRANSIT"
  | "FULFILLED"
  | "CANCELED"

interface StatusLabelData {
  label: StatusLabel
  color: Color
  dotColor?: Color | null
}

export const statusLabelData = (order: OrderType): StatusLabelData => {
  const { displayState, requestedFulfillment, mode } = order
  const fulfillmentType = requestedFulfillment?.__typename
  const offer = mode === "OFFER"

  const getSubmittedState = (): StatusLabelData => {
    const awaitingBuyerOfferResponse: boolean =
      offer && order.awaitingResponseFrom === "BUYER"

    if (awaitingBuyerOfferResponse) {
      return {
        label: "Offer sent",
        color: "black10"
      }
    }
    return {
      label: offer ? "Review offer" : "Confirm order",
      color: "blue10",
      dotColor: "blue100"
    }
  }

  const getApprovedState = (): StatusLabelData => {
    if (fulfillmentType === "CommerceShip") {
      return {
        label: "Ship order",
        color: "blue10",
        dotColor: "blue100"
      }
    }
    return {
      label: "Hold for collector",
      color: "copper10",
      dotColor: "copper100"
    }
  }

  const getProcessingState = (): StatusLabelData => {
    if (fulfillmentType === "CommerceShip") {
      return {
        label: "Ship order",
        color: "blue10",
        dotColor: "blue100"
      }
    } else {
      return {
        label: "Hold for ARTA",
        color: "copper10",
        dotColor: "copper100"
      }
    }
  }

  const orderDisplayStatesMap = {
    SUBMITTED: getSubmittedState(),
    APPROVED: getApprovedState(),
    PROCESSING: getProcessingState(),
    IN_TRANSIT: {
      label: "In transit",
      color: "green10",
      dotColor: "green100"
    } as StatusLabelData,
    FULFILLED: {
      label: "Complete",
      color: "black10"
    } as StatusLabelData,
    CANCELED: {
      label: "Shipping cancelled",
      color: "red10",
      dotColor: "red100"
    } as StatusLabelData
  }

  const orderState: StatusLabelData = orderDisplayStatesMap[displayState as StatusEnum]

  return {
    label: orderState.label,
    color: orderState.color,
    dotColor: orderState.dotColor || null
  }
}

interface StatusBadgeProps {
  order: OrderType
}

export const StatusBadge: React.FC<StatusBadgeProps> = ({ order }) => {
  const { label, color, dotColor } = statusLabelData(order)
  return (
    <Flex bg={color} flexDirection="row" p={0.5} borderRadius="2" alignItems="center" >
      {!!dotColor && <Flex bg={dotColor} mr={0.5} style={{width: 5, height: 5}} borderRadius={100}/>}
      <Text variant="xs">
        {label}
      </Text>
    </Flex>
  )
}
