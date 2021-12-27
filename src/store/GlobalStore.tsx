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
      return null
    } catch (error) {
      throw new Error(error as string)
    }
  },
  async setItem(key: string, data: string) {
    try {
      await AsyncStorage.setItem(key, JSON.stringify(data))
    } catch (error) {
      throw new Error(error as string)
    }
  },
  async removeItem(key: string) {
    try {
      await AsyncStorage.removeItem(key)
    } catch (error) {
      throw new Error(error as string)
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
