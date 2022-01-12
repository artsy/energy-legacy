import { createStore, createTypedHooks, StoreProvider } from "easy-peasy"
import React from "react"
import { Middleware } from "redux"
import { GlobalStoreModel } from "./Models/GlobalStoreModel"
import { getPersistedState, persistenceMiddleware } from "./persistence"

function createGlobalStore() {
  const middlewares: Middleware[] = []

  middlewares.push(persistenceMiddleware)

  if (__DEV__) {
    const reduxInFlipper = require("redux-flipper").default
    middlewares.push(reduxInFlipper())
  }

  const store = createStore<GlobalStoreModel>(GlobalStoreModel, {
    middleware: middlewares,
  })

  // // // Rehydrate the store state
  getPersistedState().then(async (state) => {
    console.log("store => ", state)

    store.getActions().rehydrate(state)
  })

  return store
}

let globalStoreInstance = createGlobalStore()

const hooks = createTypedHooks<GlobalStoreModel>()

export const GlobalStore = {
  useAppState: hooks.useStoreState,
  get actions() {
    return globalStoreInstance.getActions()
  },
}

export const GlobalStoreProvider: React.FC<{}> = ({ children }) => {
  return <StoreProvider store={globalStoreInstance}>{children}</StoreProvider>
}

/**
 * This is marked as unsafe because it will not cause a re-render
 */
export function unsafe__getEnvironment() {
  return { ...globalStoreInstance.getState().config.environment }
}

/**
 * This is marked as unsafe because it will not cause a re-render
 */
export function unsafe__getAuth() {
  return { ...globalStoreInstance.getState().auth }
}
