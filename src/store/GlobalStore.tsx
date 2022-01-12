import React from "react"
import AsyncStorage from "@react-native-async-storage/async-storage"
import { StoreProvider, createStore, createTypedHooks, persist } from "easy-peasy"
import { GlobalStoreModel } from "./Models/GlobalStoreModel"
import { Platform } from "react-native"

const STORE_VERSION = 0

if (Platform.OS === "ios") {
  // @ts-ignore
  window.requestIdleCallback = null
}

const asynchStorage = {
  async getItem(key: string) {
    try {
      const res = await AsyncStorage.getItem(key)
      if (res) {
        return JSON.parse(res)
      }
    } catch (error) {
      throw error
    }
  },
  async setItem(key: string, data: string) {
    try {
      await AsyncStorage.setItem(key, JSON.stringify(data))
    } catch (error) {
      throw error
    }
  },
  async removeItem(key: string) {
    try {
      await AsyncStorage.removeItem(key)
    } catch (error) {
      throw error
    }
  },
}

function createGlobalStore() {
  const store = createStore<GlobalStoreModel>(
    persist(GlobalStoreModel, {
      storage: asynchStorage,
    }),
    {
      name: "GlobalStore",
      version: STORE_VERSION,
      devTools: __DEV__,
    }
  )
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
