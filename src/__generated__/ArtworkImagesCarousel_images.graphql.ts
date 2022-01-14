/* tslint:disable */
/* eslint-disable */
// @ts-nocheck

import { ReaderFragment } from "relay-runtime";
import { FragmentRefs } from "relay-runtime";
export type ArtworkImagesCarousel_images = ReadonlyArray<{
    readonly imageURL: string | null;
    readonly width: number | null;
    readonly height: number | null;
    readonly imageVersions: ReadonlyArray<string | null> | null;
    readonly " $refType": "ArtworkImagesCarousel_images";
}>;
export type ArtworkImagesCarousel_images$data = ArtworkImagesCarousel_images;
export type ArtworkImagesCarousel_images$key = ReadonlyArray<{
    readonly " $data"?: ArtworkImagesCarousel_images$data | undefined;
    readonly " $fragmentRefs": FragmentRefs<"ArtworkImagesCarousel_images">;
}>;



const node: ReaderFragment = {
  "argumentDefinitions": [],
  "kind": "Fragment",
  "metadata": {
    "plural": true
  },
  "name": "ArtworkImagesCarousel_images",
  "selections": [
    {
      "alias": null,
      "args": null,
      "kind": "ScalarField",
      "name": "imageURL",
      "storageKey": null
    },
    {
      "alias": null,
      "args": null,
      "kind": "ScalarField",
      "name": "width",
      "storageKey": null
    },
    {
      "alias": null,
      "args": null,
      "kind": "ScalarField",
      "name": "height",
      "storageKey": null
    },
    {
      "alias": null,
      "args": null,
      "kind": "ScalarField",
      "name": "imageVersions",
      "storageKey": null
    }
  ],
  "type": "Image",
  "abstractKey": null
};
(node as any).hash = 'a523c614574bc87cf59473d36a49686d';
export default node;
