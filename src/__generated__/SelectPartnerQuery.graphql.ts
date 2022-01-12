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
    (v0/*: any*/)
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
    "cacheID": "2dee3547dc930c9952f24c95ef39fe4f",
    "id": null,
    "metadata": {},
    "name": "SelectPartnerQuery",
    "operationKind": "query",
    "text": "query SelectPartnerQuery {\n  me {\n    partners {\n      name\n      id\n    }\n    id\n  }\n}\n"
  }
};
})();
(node as any).hash = 'b8dfc43002d236ea997f3379ea616724';
export default node;
