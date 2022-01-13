/* tslint:disable */
/* eslint-disable */
// @ts-nocheck

import { ConcreteRequest } from "relay-runtime";
export type SelectPartnerQueryVariables = {};
export type SelectPartnerQueryResponse = {
    readonly me: {
        readonly partners: ReadonlyArray<{
            readonly name: string | null;
            readonly id: string;
            readonly internalID: string;
        } | null> | null;
    } | null;
};
export type SelectPartnerQuery = {
    readonly response: SelectPartnerQueryResponse;
    readonly variables: SelectPartnerQueryVariables;
};



/*
query SelectPartnerQuery {
  me {
    partners {
      name
      id
      internalID
    }
    id
  }
}
*/

const node: ConcreteRequest = (function(){
var v0 = {
  "alias": null,
  "args": null,
  "kind": "ScalarField",
  "name": "id",
  "storageKey": null
},
v1 = {
  "alias": null,
  "args": null,
  "concreteType": "Partner",
  "kind": "LinkedField",
  "name": "partners",
  "plural": true,
  "selections": [
    {
      "alias": null,
      "args": null,
      "kind": "ScalarField",
      "name": "name",
      "storageKey": null
    },
    (v0/*: any*/),
    {
      "alias": null,
      "args": null,
      "kind": "ScalarField",
      "name": "internalID",
      "storageKey": null
    }
  ],
  "storageKey": null
};
return {
  "fragment": {
    "argumentDefinitions": [],
    "kind": "Fragment",
    "metadata": null,
    "name": "SelectPartnerQuery",
    "selections": [
      {
        "alias": null,
        "args": null,
        "concreteType": "Me",
        "kind": "LinkedField",
        "name": "me",
        "plural": false,
        "selections": [
          (v1/*: any*/)
        ],
        "storageKey": null
      }
    ],
    "type": "Query",
    "abstractKey": null
  },
  "kind": "Request",
  "operation": {
    "argumentDefinitions": [],
    "kind": "Operation",
    "name": "SelectPartnerQuery",
    "selections": [
      {
        "alias": null,
        "args": null,
        "concreteType": "Me",
        "kind": "LinkedField",
        "name": "me",
        "plural": false,
        "selections": [
          (v1/*: any*/),
          (v0/*: any*/)
        ],
        "storageKey": null
      }
    ]
  },
  "params": {
    "cacheID": "23dd36e2533f08c324b4353d40f70593",
    "id": null,
    "metadata": {},
    "name": "SelectPartnerQuery",
    "operationKind": "query",
    "text": "query SelectPartnerQuery {\n  me {\n    partners {\n      name\n      id\n      internalID\n    }\n    id\n  }\n}\n"
  }
};
})();
(node as any).hash = '2828b074c44941863dba2e6ac8c12b92';
export default node;
