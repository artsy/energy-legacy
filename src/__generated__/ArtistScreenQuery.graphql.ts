/* tslint:disable */
/* eslint-disable */
// @ts-nocheck

import { ConcreteRequest } from "relay-runtime";
export type ArtistScreenQueryVariables = {
    partnerID: string;
    artistID: string;
};
export type ArtistScreenQueryResponse = {
    readonly artist: {
        readonly imageUrl: string | null;
        readonly displayLabel: string | null;
        readonly formattedNationalityAndBirthday: string | null;
        readonly formattedArtworksCount: string | null;
        readonly initials: string | null;
        readonly filterArtworksConnection: {
            readonly edges: ReadonlyArray<{
                readonly node: {
                    readonly internalID: string;
                    readonly displayLabel: string | null;
                    readonly imageUrl: string | null;
                    readonly imageTitle: string | null;
                    readonly href: string | null;
                    readonly artistNames: string | null;
                    readonly title: string | null;
                    readonly date: string | null;
                } | null;
            } | null> | null;
        } | null;
    } | null;
};
export type ArtistScreenQuery = {
    readonly response: ArtistScreenQueryResponse;
    readonly variables: ArtistScreenQueryVariables;
};



/*
query ArtistScreenQuery(
  $partnerID: ID!
  $artistID: String!
) {
  artist(id: $artistID) {
    imageUrl
    displayLabel
    formattedNationalityAndBirthday
    formattedArtworksCount
    initials
    filterArtworksConnection(first: 20, partnerID: $partnerID) {
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
          id
        }
      }
      id
    }
    id
  }
}
*/

const node: ConcreteRequest = (function(){
var v0 = {
  "defaultValue": null,
  "kind": "LocalArgument",
  "name": "artistID"
},
v1 = {
  "defaultValue": null,
  "kind": "LocalArgument",
  "name": "partnerID"
},
v2 = [
  {
    "kind": "Variable",
    "name": "id",
    "variableName": "artistID"
  }
],
v3 = {
  "alias": null,
  "args": null,
  "kind": "ScalarField",
  "name": "imageUrl",
  "storageKey": null
},
v4 = {
  "alias": null,
  "args": null,
  "kind": "ScalarField",
  "name": "displayLabel",
  "storageKey": null
},
v5 = {
  "alias": null,
  "args": null,
  "kind": "ScalarField",
  "name": "formattedNationalityAndBirthday",
  "storageKey": null
},
v6 = {
  "alias": null,
  "args": null,
  "kind": "ScalarField",
  "name": "formattedArtworksCount",
  "storageKey": null
},
v7 = {
  "alias": null,
  "args": null,
  "kind": "ScalarField",
  "name": "initials",
  "storageKey": null
},
v8 = [
  {
    "kind": "Literal",
    "name": "first",
    "value": 20
  },
  {
    "kind": "Variable",
    "name": "partnerID",
    "variableName": "partnerID"
  }
],
v9 = {
  "alias": null,
  "args": null,
  "kind": "ScalarField",
  "name": "internalID",
  "storageKey": null
},
v10 = {
  "alias": null,
  "args": null,
  "kind": "ScalarField",
  "name": "imageTitle",
  "storageKey": null
},
v11 = {
  "alias": null,
  "args": null,
  "kind": "ScalarField",
  "name": "href",
  "storageKey": null
},
v12 = {
  "alias": null,
  "args": null,
  "kind": "ScalarField",
  "name": "artistNames",
  "storageKey": null
},
v13 = {
  "alias": null,
  "args": null,
  "kind": "ScalarField",
  "name": "title",
  "storageKey": null
},
v14 = {
  "alias": null,
  "args": null,
  "kind": "ScalarField",
  "name": "date",
  "storageKey": null
},
v15 = {
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
      (v1/*: any*/)
    ],
    "kind": "Fragment",
    "metadata": null,
    "name": "ArtistScreenQuery",
    "selections": [
      {
        "alias": null,
        "args": (v2/*: any*/),
        "concreteType": "Artist",
        "kind": "LinkedField",
        "name": "artist",
        "plural": false,
        "selections": [
          (v3/*: any*/),
          (v4/*: any*/),
          (v5/*: any*/),
          (v6/*: any*/),
          (v7/*: any*/),
          {
            "alias": null,
            "args": (v8/*: any*/),
            "concreteType": "FilterArtworksConnection",
            "kind": "LinkedField",
            "name": "filterArtworksConnection",
            "plural": false,
            "selections": [
              {
                "alias": null,
                "args": null,
                "concreteType": "FilterArtworksEdge",
                "kind": "LinkedField",
                "name": "edges",
                "plural": true,
                "selections": [
                  {
                    "alias": null,
                    "args": null,
                    "concreteType": "Artwork",
                    "kind": "LinkedField",
                    "name": "node",
                    "plural": false,
                    "selections": [
                      (v9/*: any*/),
                      (v4/*: any*/),
                      (v3/*: any*/),
                      (v10/*: any*/),
                      (v11/*: any*/),
                      (v12/*: any*/),
                      (v13/*: any*/),
                      (v14/*: any*/)
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
        "storageKey": null
      }
    ],
    "type": "Query",
    "abstractKey": null
  },
  "kind": "Request",
  "operation": {
    "argumentDefinitions": [
      (v1/*: any*/),
      (v0/*: any*/)
    ],
    "kind": "Operation",
    "name": "ArtistScreenQuery",
    "selections": [
      {
        "alias": null,
        "args": (v2/*: any*/),
        "concreteType": "Artist",
        "kind": "LinkedField",
        "name": "artist",
        "plural": false,
        "selections": [
          (v3/*: any*/),
          (v4/*: any*/),
          (v5/*: any*/),
          (v6/*: any*/),
          (v7/*: any*/),
          {
            "alias": null,
            "args": (v8/*: any*/),
            "concreteType": "FilterArtworksConnection",
            "kind": "LinkedField",
            "name": "filterArtworksConnection",
            "plural": false,
            "selections": [
              {
                "alias": null,
                "args": null,
                "concreteType": "FilterArtworksEdge",
                "kind": "LinkedField",
                "name": "edges",
                "plural": true,
                "selections": [
                  {
                    "alias": null,
                    "args": null,
                    "concreteType": "Artwork",
                    "kind": "LinkedField",
                    "name": "node",
                    "plural": false,
                    "selections": [
                      (v9/*: any*/),
                      (v4/*: any*/),
                      (v3/*: any*/),
                      (v10/*: any*/),
                      (v11/*: any*/),
                      (v12/*: any*/),
                      (v13/*: any*/),
                      (v14/*: any*/),
                      (v15/*: any*/)
                    ],
                    "storageKey": null
                  }
                ],
                "storageKey": null
              },
              (v15/*: any*/)
            ],
            "storageKey": null
          },
          (v15/*: any*/)
        ],
        "storageKey": null
      }
    ]
  },
  "params": {
    "cacheID": "8aaf6baf5bf92e363bcb2bc595e50755",
    "id": null,
    "metadata": {},
    "name": "ArtistScreenQuery",
    "operationKind": "query",
    "text": "query ArtistScreenQuery(\n  $partnerID: ID!\n  $artistID: String!\n) {\n  artist(id: $artistID) {\n    imageUrl\n    displayLabel\n    formattedNationalityAndBirthday\n    formattedArtworksCount\n    initials\n    filterArtworksConnection(first: 20, partnerID: $partnerID) {\n      edges {\n        node {\n          internalID\n          displayLabel\n          imageUrl\n          imageTitle\n          href\n          artistNames\n          title\n          date\n          id\n        }\n      }\n      id\n    }\n    id\n  }\n}\n"
  }
};
})();
(node as any).hash = '64242140ac84fdb4df65caf60b65c382';
export default node;
