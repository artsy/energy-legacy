import { AuthModel } from "./AuthModel"
import { ConfigModel } from "./ConfigModel"
import { action, Action } from "easy-peasy"

interface GlobalStoreStateModel {
  auth: AuthModel
  config: ConfigModel

  activePartnerID: string | null
}

export interface GlobalStoreModel extends GlobalStoreStateModel {
  setActivePartnerID: Action<this, string | null>
}

export const GlobalStoreModel: GlobalStoreModel = {
  auth: AuthModel,
  config: ConfigModel,

  activePartnerID: null,

  setActivePartnerID: action((state, partnerID) => {
    state.activePartnerID = partnerID
  }),
}
