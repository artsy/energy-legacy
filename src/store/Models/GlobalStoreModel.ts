import { AuthModel } from "./AuthModel"
import { ConfigModel } from "./ConfigModel"

interface GlobalStoreStateModel {
  auth: AuthModel
  config: ConfigModel
}

export interface GlobalStoreModel extends GlobalStoreStateModel {}

export const GlobalStoreModel: GlobalStoreModel = {
  auth: AuthModel,
  config: ConfigModel,
}
