import { assignDeep } from "@store/persistence"
import { action, Action, State } from "easy-peasy"
import { AuthModel } from "./AuthModel"
import { ConfigModel } from "./ConfigModel"
import { CURRENT_APP_VERSION } from "../migration"

interface GlobalStoreStateModel {
  sessionState: {
    isHydrated: boolean
  }
  version: number

  auth: AuthModel
  config: ConfigModel
}

export interface GlobalStoreModel extends GlobalStoreStateModel {
  rehydrate: Action<this, DeepPartial<State<GlobalStoreStateModel>>>
}

export const GlobalStoreModel: GlobalStoreModel = {
  sessionState: {
    isHydrated: false,
  },

  version: CURRENT_APP_VERSION,

  auth: AuthModel,
  config: ConfigModel,

  rehydrate: action((state, unpersistedState) => {
    console.log("initialState => ", state.sessionState)

    if (state.sessionState.isHydrated) {
      console.error("The store was already hydrated. `rehydrate` should only be called once.")
      return
    }
    assignDeep(state, unpersistedState)
    state.sessionState.isHydrated = true
  }),
}
