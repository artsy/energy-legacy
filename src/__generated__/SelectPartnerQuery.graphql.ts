/* tslint:disable */
/* eslint-disable */
// @ts-nocheck

import { ConcreteRequest } from "relay-runtime";
export type SelectPartnerQueryVariables = {};
export type SelectPartnerQueryResponse = {
    readonly me: {
        readonly partners: ReadonlyArray<{
            readonly name: string | null;
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
      internalID
      id
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
  "name": "name",
  "storageKey": null
},
v1 = {
  "alias": null,
  "args": null,
  "kind": "ScalarField",
  "name": "internalID",
  "storageKey": null
},
v2 = {
  "alias": null,
  "args": null,
  "kind": "ScalarField",
  "name": "id",
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
          {
            "alias": null,
            "args": null,
            "concreteType": "Partner",
            "kind": "LinkedField",
            "name": "partners",
            "plural": true,
            "selections": [
              (v0/*: any*/),
              (v1/*: any*/)
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
          {
            "alias": null,
            "args": null,
            "concreteType": "Partner",
            "kind": "LinkedField",
            "name": "partners",
            "plural": true,
            "selections": [
              (v0/*: any*/),
              (v1/*: any*/),
              (v2/*: any*/)
            ],
            "storageKey": null
          },
          (v2/*: any*/)
        ],
        "storageKey": null
      }
    ]
  },
  "params": {
    "cacheID": "a26b2138bbc0c761cdb437ecf48303db",
    "id": null,
    "metadata": {},
    "name": "SelectPartnerQuery",
    "operationKind": "query",
    "text": "query SelectPartnerQuery {\n  me {\n    partners {\n      name\n      internalID\n      id\n    }\n    id\n  }\n}\n"
  }
};
})();
(node as any).hash = '560c92d439aabd2ab93c91723384007c';
export default node;
