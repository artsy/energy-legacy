import { AuthModel, authModel } from "./AuthModel"

interface GlobalStoreStateModel {
  auth: AuthModel
}

export interface GlobalStoreModel extends GlobalStoreStateModel {}

export const GlobalStoreModel: GlobalStoreModel = {
  auth: authModel,
}
