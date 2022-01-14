/* tslint:disable */
/* eslint-disable */
// @ts-nocheck

import { ReaderFragment } from "relay-runtime";
import { FragmentRefs } from "relay-runtime";
export type ArtworkHeader_artwork = {
    readonly title: string | null;
    readonly href: string | null;
    readonly internalID: string;
    readonly slug: string;
    readonly artists: ReadonlyArray<{
        readonly name: string | null;
    } | null> | null;
    readonly images: ReadonlyArray<{
        readonly " $fragmentRefs": FragmentRefs<"ArtworkImagesCarousel_images">;
    } | null> | null;
    readonly " $fragmentRefs": FragmentRefs<"ArtworkTombstone_artwork">;
    readonly " $refType": "ArtworkHeader_artwork";
};
export type ArtworkHeader_artwork$data = ArtworkHeader_artwork;
export type ArtworkHeader_artwork$key = {
    readonly " $data"?: ArtworkHeader_artwork$data | undefined;
    readonly " $fragmentRefs": FragmentRefs<"ArtworkHeader_artwork">;
};



const node: ReaderFragment = {
  "argumentDefinitions": [],
  "kind": "Fragment",
  "metadata": null,
  "name": "ArtworkHeader_artwork",
  "selections": [
    {
      "alias": null,
      "args": null,
      "kind": "ScalarField",
      "name": "title",
      "storageKey": null
    },
    {
      "alias": null,
      "args": null,
      "kind": "ScalarField",
      "name": "href",
      "storageKey": null
    },
    {
      "alias": null,
      "args": null,
      "kind": "ScalarField",
      "name": "internalID",
      "storageKey": null
    },
    {
      "alias": null,
      "args": null,
      "kind": "ScalarField",
      "name": "slug",
      "storageKey": null
    },
    {
      "alias": null,
      "args": null,
      "concreteType": "Artist",
      "kind": "LinkedField",
      "name": "artists",
      "plural": true,
      "selections": [
        {
          "alias": null,
          "args": null,
          "kind": "ScalarField",
          "name": "name",
          "storageKey": null
        }
      ],
      "storageKey": null
    },
    {
      "alias": null,
      "args": null,
      "concreteType": "Image",
      "kind": "LinkedField",
      "name": "images",
      "plural": true,
      "selections": [
        {
          "args": null,
          "kind": "FragmentSpread",
          "name": "ArtworkImagesCarousel_images"
        }
      ],
      "storageKey": null
    },
    {
      "args": null,
      "kind": "FragmentSpread",
      "name": "ArtworkTombstone_artwork"
    }
  ],
  "type": "Artwork",
  "abstractKey": null
};
(node as any).hash = 'd580237e7cd2024bff2dc224ac83ccd2';
export default node;
