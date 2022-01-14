/* tslint:disable */
/* eslint-disable */
// @ts-nocheck

import { ConcreteRequest } from "relay-runtime";
export type CommerceOrderConnectionSortEnum = "STATE_EXPIRES_AT_ASC" | "STATE_EXPIRES_AT_DESC" | "STATE_UPDATED_AT_ASC" | "STATE_UPDATED_AT_DESC" | "UPDATED_AT_ASC" | "UPDATED_AT_DESC" | "%future added value";
export type CommerceOrderDisplayStateEnum = "ABANDONED" | "APPROVED" | "CANCELED" | "FULFILLED" | "IN_TRANSIT" | "PENDING" | "PROCESSING" | "REFUNDED" | "SUBMITTED" | "%future added value";
export type CommerceOrderModeEnum = "BUY" | "OFFER" | "%future added value";
export type CommerceOrderParticipantEnum = "BUYER" | "SELLER" | "%future added value";
export type CommerceOrderStateEnum = "ABANDONED" | "APPROVED" | "CANCELED" | "FULFILLED" | "PENDING" | "REFUNDED" | "SUBMITTED" | "%future added value";
export type OrdersScreenQueryVariables = {
    partnerID: string;
    states?: Array<CommerceOrderStateEnum> | null | undefined;
    sort?: CommerceOrderConnectionSortEnum | null | undefined;
};
export type OrdersScreenQueryResponse = {
    readonly commerceOrders: {
        readonly totalCount: number | null;
        readonly edges: ReadonlyArray<{
            readonly node: {
                readonly internalID: string;
                readonly code: string;
                readonly displayState: CommerceOrderDisplayStateEnum;
                readonly stateUpdatedAt: string | null;
                readonly stateExpiresAt: string | null;
                readonly requestedFulfillment: {
                    readonly __typename: string;
                } | null;
                readonly mode: CommerceOrderModeEnum | null;
                readonly lineItems: {
                    readonly edges: ReadonlyArray<{
                        readonly node: {
                            readonly artwork: {
                                readonly image: {
                                    readonly resized: {
                                        readonly url: string;
                                    } | null;
                                } | null;
                                readonly artistNames: string | null;
                            } | null;
                        } | null;
                    } | null> | null;
                } | null;
                readonly awaitingResponseFrom?: CommerceOrderParticipantEnum | null | undefined;
            } | null;
        } | null> | null;
    } | null;
};
export type OrdersScreenQuery = {
    readonly response: OrdersScreenQueryResponse;
    readonly variables: OrdersScreenQueryVariables;
};



/*
query OrdersScreenQuery(
  $partnerID: String!
  $states: [CommerceOrderStateEnum!]
  $sort: CommerceOrderConnectionSortEnum
) {
  commerceOrders(sellerId: $partnerID, states: $states, first: 10, sort: $sort) @optionalField {
    totalCount
    edges {
      node {
        __typename
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
                id
              }
              id
            }
          }
        }
        ... on CommerceOfferOrder {
          awaitingResponseFrom
        }
        id
      }
    }
  }
}
*/

const node: ConcreteRequest = (function(){
var v0 = {
  "defaultValue": null,
  "kind": "LocalArgument",
  "name": "partnerID"
},
v1 = {
  "defaultValue": null,
  "kind": "LocalArgument",
  "name": "sort"
},
v2 = {
  "defaultValue": null,
  "kind": "LocalArgument",
  "name": "states"
},
v3 = [
  {
    "kind": "Literal",
    "name": "first",
    "value": 10
  },
  {
    "kind": "Variable",
    "name": "sellerId",
    "variableName": "partnerID"
  },
  {
    "kind": "Variable",
    "name": "sort",
    "variableName": "sort"
  },
  {
    "kind": "Variable",
    "name": "states",
    "variableName": "states"
  }
],
v4 = {
  "alias": null,
  "args": null,
  "kind": "ScalarField",
  "name": "totalCount",
  "storageKey": null
},
v5 = {
  "alias": null,
  "args": null,
  "kind": "ScalarField",
  "name": "internalID",
  "storageKey": null
},
v6 = {
  "alias": null,
  "args": null,
  "kind": "ScalarField",
  "name": "code",
  "storageKey": null
},
v7 = {
  "alias": null,
  "args": null,
  "kind": "ScalarField",
  "name": "displayState",
  "storageKey": null
},
v8 = {
  "alias": null,
  "args": [
    {
      "kind": "Literal",
      "name": "format",
      "value": "MMM D"
    }
  ],
  "kind": "ScalarField",
  "name": "stateUpdatedAt",
  "storageKey": "stateUpdatedAt(format:\"MMM D\")"
},
v9 = {
  "alias": null,
  "args": null,
  "kind": "ScalarField",
  "name": "stateExpiresAt",
  "storageKey": null
},
v10 = {
  "alias": null,
  "args": null,
  "kind": "ScalarField",
  "name": "__typename",
  "storageKey": null
},
v11 = {
  "alias": null,
  "args": null,
  "concreteType": null,
  "kind": "LinkedField",
  "name": "requestedFulfillment",
  "plural": false,
  "selections": [
    (v10/*: any*/)
  ],
  "storageKey": null
},
v12 = {
  "alias": null,
  "args": null,
  "kind": "ScalarField",
  "name": "mode",
  "storageKey": null
},
v13 = [
  {
    "kind": "Literal",
    "name": "first",
    "value": 1
  }
],
v14 = {
  "alias": null,
  "args": null,
  "concreteType": "Image",
  "kind": "LinkedField",
  "name": "image",
  "plural": false,
  "selections": [
    {
      "alias": null,
      "args": [
        {
          "kind": "Literal",
          "name": "height",
          "value": 50
        },
        {
          "kind": "Literal",
          "name": "version",
          "value": [
            "square"
          ]
        }
      ],
      "concreteType": "ResizedImageUrl",
      "kind": "LinkedField",
      "name": "resized",
      "plural": false,
      "selections": [
        {
          "alias": null,
          "args": null,
          "kind": "ScalarField",
          "name": "url",
          "storageKey": null
        }
      ],
      "storageKey": "resized(height:50,version:[\"square\"])"
    }
  ],
  "storageKey": null
},
v15 = {
  "alias": null,
  "args": null,
  "kind": "ScalarField",
  "name": "artistNames",
  "storageKey": null
},
v16 = {
  "kind": "InlineFragment",
  "selections": [
    {
      "alias": null,
      "args": null,
      "kind": "ScalarField",
      "name": "awaitingResponseFrom",
      "storageKey": null
    }
  ],
  "type": "CommerceOfferOrder",
  "abstractKey": null
},
v17 = {
  "alias": null,
  "args": null,
  "kind": "ScalarField",
  "name": "id",
  "storageKey": null
};
return {
  "fragment": {
    "argumentDefinitions": [
      (v0/*: any*/),
      (v1/*: any*/),
      (v2/*: any*/)
    ],
    "kind": "Fragment",
    "metadata": null,
    "name": "OrdersScreenQuery",
    "selections": [
      {
        "alias": null,
        "args": (v3/*: any*/),
        "concreteType": "CommerceOrderConnectionWithTotalCount",
        "kind": "LinkedField",
        "name": "commerceOrders",
        "plural": false,
        "selections": [
          (v4/*: any*/),
          {
            "alias": null,
            "args": null,
            "concreteType": "CommerceOrderEdge",
            "kind": "LinkedField",
            "name": "edges",
            "plural": true,
            "selections": [
              {
                "alias": null,
                "args": null,
                "concreteType": null,
                "kind": "LinkedField",
                "name": "node",
                "plural": false,
                "selections": [
                  (v5/*: any*/),
                  (v6/*: any*/),
                  (v7/*: any*/),
                  (v8/*: any*/),
                  (v9/*: any*/),
                  (v11/*: any*/),
                  (v12/*: any*/),
                  {
                    "alias": null,
                    "args": (v13/*: any*/),
                    "concreteType": "CommerceLineItemConnection",
                    "kind": "LinkedField",
                    "name": "lineItems",
                    "plural": false,
                    "selections": [
                      {
                        "alias": null,
                        "args": null,
                        "concreteType": "CommerceLineItemEdge",
                        "kind": "LinkedField",
                        "name": "edges",
                        "plural": true,
                        "selections": [
                          {
                            "alias": null,
                            "args": null,
                            "concreteType": "CommerceLineItem",
                            "kind": "LinkedField",
                            "name": "node",
                            "plural": false,
                            "selections": [
                              {
                                "alias": null,
                                "args": null,
                                "concreteType": "Artwork",
                                "kind": "LinkedField",
                                "name": "artwork",
                                "plural": false,
                                "selections": [
                                  (v14/*: any*/),
                                  (v15/*: any*/)
                                ],
                                "storageKey": null
                              }
                            ],
                            "storageKey": null
                          }
                        ],
                        "storageKey": null
                      }
                    ],
                    "storageKey": "lineItems(first:1)"
                  },
                  (v16/*: any*/)
                ],
                "storageKey": null
              }
            ],
            "storageKey": null
          }
        ],
        "storageKey": null
      }
    ],
    "type": "Query",
    "abstractKey": null
  },
  "kind": "Request",
  "operation": {
    "argumentDefinitions": [
      (v0/*: any*/),
      (v2/*: any*/),
      (v1/*: any*/)
    ],
    "kind": "Operation",
    "name": "OrdersScreenQuery",
    "selections": [
      {
        "alias": null,
        "args": (v3/*: any*/),
        "concreteType": "CommerceOrderConnectionWithTotalCount",
        "kind": "LinkedField",
        "name": "commerceOrders",
        "plural": false,
        "selections": [
          (v4/*: any*/),
          {
            "alias": null,
            "args": null,
            "concreteType": "CommerceOrderEdge",
            "kind": "LinkedField",
            "name": "edges",
            "plural": true,
            "selections": [
              {
                "alias": null,
                "args": null,
                "concreteType": null,
                "kind": "LinkedField",
                "name": "node",
                "plural": false,
                "selections": [
                  (v10/*: any*/),
                  (v5/*: any*/),
                  (v6/*: any*/),
                  (v7/*: any*/),
                  (v8/*: any*/),
                  (v9/*: any*/),
                  (v11/*: any*/),
                  (v12/*: any*/),
                  {
                    "alias": null,
                    "args": (v13/*: any*/),
                    "concreteType": "CommerceLineItemConnection",
                    "kind": "LinkedField",
                    "name": "lineItems",
                    "plural": false,
                    "selections": [
                      {
                        "alias": null,
                        "args": null,
                        "concreteType": "CommerceLineItemEdge",
                        "kind": "LinkedField",
                        "name": "edges",
                        "plural": true,
                        "selections": [
                          {
                            "alias": null,
                            "args": null,
                            "concreteType": "CommerceLineItem",
                            "kind": "LinkedField",
                            "name": "node",
                            "plural": false,
                            "selections": [
                              {
                                "alias": null,
                                "args": null,
                                "concreteType": "Artwork",
                                "kind": "LinkedField",
                                "name": "artwork",
                                "plural": false,
                                "selections": [
                                  (v14/*: any*/),
                                  (v15/*: any*/),
                                  (v17/*: any*/)
                                ],
                                "storageKey": null
                              },
                              (v17/*: any*/)
                            ],
                            "storageKey": null
                          }
                        ],
                        "storageKey": null
                      }
                    ],
                    "storageKey": "lineItems(first:1)"
                  },
                  (v17/*: any*/),
                  (v16/*: any*/)
                ],
                "storageKey": null
              }
            ],
            "storageKey": null
          }
        ],
        "storageKey": null
      }
    ]
  },
  "params": {
    "cacheID": "2da16c55568763ccd243f67b1040311f",
    "id": null,
    "metadata": {},
    "name": "OrdersScreenQuery",
    "operationKind": "query",
    "text": "query OrdersScreenQuery(\n  $partnerID: String!\n  $states: [CommerceOrderStateEnum!]\n  $sort: CommerceOrderConnectionSortEnum\n) {\n  commerceOrders(sellerId: $partnerID, states: $states, first: 10, sort: $sort) @optionalField {\n    totalCount\n    edges {\n      node {\n        __typename\n        internalID\n        code\n        displayState\n        stateUpdatedAt(format: \"MMM D\")\n        stateExpiresAt\n        requestedFulfillment {\n          __typename\n        }\n        mode\n        lineItems(first: 1) {\n          edges {\n            node {\n              artwork {\n                image {\n                  resized(height: 50, version: [\"square\"]) {\n                    url\n                  }\n                }\n                artistNames\n                id\n              }\n              id\n            }\n          }\n        }\n        ... on CommerceOfferOrder {\n          awaitingResponseFrom\n        }\n        id\n      }\n    }\n  }\n}\n"
  }
};
})();
(node as any).hash = 'a85bb0ca7cd1c11598aecd6ef40318a0';
export default node;
