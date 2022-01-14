import {
  createRequestError,
  MiddlewareNextFn,
  RelayNetworkLayerResponse,
} from "react-relay-network-modern/node8"

import { GraphQLResponse } from "relay-runtime/lib/network/RelayNetworkTypes"
import { GraphQLRequest } from "./types"

const isErrorStatus = (status: number | undefined) => {
  return (status ?? 200) >= 400
}

const throwError = (req: GraphQLRequest, res: RelayNetworkLayerResponse) => {
  throw createRequestError(req, res)
}

const trackError = (queryName: string, queryKind: string, handler: "optionalField" | "principalField" | "default") => {
  console.log({
    type: "increment",
    name: "graphql-request-with-errors",
    tags: [`query:${queryName}`, `kind:${queryKind}`, `handler: ${handler}`],
  })
}

export const errorMiddleware = () => {
  console.log("ARGH ", __DEV__)
  return (next: MiddlewareNextFn) => async (req: GraphQLRequest) => {
    const res = await next(req)
    const resJson = res?.json as GraphQLResponse

    // @ts-ignore RELAY 12 MIGRATION
    const hasErrors: boolean = Boolean(resJson.errors?.length)

    if (!hasErrors) {
      return res
    }

    // @ts-ignore RELAY 12 MIGRATION
    const allErrorsAreOptional = resJson.extensions?.optionalFields?.length === resJson.errors?.length
    if (allErrorsAreOptional) {
      trackError(req.operation.name, req.operation.kind, "optionalField")
      return res
    }

    // at this point, we have errors that are not optional

    const requestHasPrincipalField = req.operation.text?.includes("@principalField")

    if (!requestHasPrincipalField) {
      trackError(req.operation.name, req.operation.kind, "default")
      return throwError(req, res)
    }

    // at this point, we have errors and we have a principalField

    // This represents whether or not the query experienced an error and that error was thrown while resolving
    // a field marked with the @principalField directive, or any sub-selection of such a field.
    // @ts-ignore RELAY 12 MIGRATION
    const principalFieldWasInvolvedInError = isErrorStatus(resJson.extensions?.principalField?.httpStatusCode)

    if (principalFieldWasInvolvedInError) {
      trackError(req.operation.name, req.operation.kind, "principalField")
      return throwError(req, res)
    }

    return res
  }
}
