/* tslint:disable */
/* eslint-disable */
// @ts-nocheck

import { ReaderFragment } from "relay-runtime";
import { FragmentRefs } from "relay-runtime";
export type HomeUser_me = {
    readonly email: string | null;
    readonly name: string | null;
    readonly " $refType": "HomeUser_me";
};
export type HomeUser_me$data = HomeUser_me;
export type HomeUser_me$key = {
    readonly " $data"?: HomeUser_me$data | undefined;
    readonly " $fragmentRefs": FragmentRefs<"HomeUser_me">;
};



const node: ReaderFragment = {
  "argumentDefinitions": [],
  "kind": "Fragment",
  "metadata": null,
  "name": "HomeUser_me",
  "selections": [
    {
      "alias": null,
      "args": null,
      "kind": "ScalarField",
      "name": "email",
      "storageKey": null
    },
    {
      "alias": null,
      "args": null,
      "kind": "ScalarField",
      "name": "name",
      "storageKey": null
    }
  ],
  "type": "Me",
  "abstractKey": null
};
(node as any).hash = 'b01dbd9dd968ca63f6994e732356582d';
export default node;
