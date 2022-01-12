import { action, Action, thunk, Thunk } from "easy-peasy"
import Config from "react-native-config"
import { GlobalStoreModel } from "./GlobalStoreModel"
import { stringify } from "qs"
import { getUserAgent } from "@helpers/getUserAgent"

interface AuthModelState {
  userAccessToken: string | null
  userAccessTokenExpiresIn: string | null
  userID: string | null
  xAppToken: string | null
  xApptokenExpiresIn: string | null
}

const authModelInitialState: AuthModelState = {
  userAccessToken: null,
  userAccessTokenExpiresIn: null,
  userID: null,
  xAppToken: null,
  xApptokenExpiresIn: null,
}
export interface AuthModel extends AuthModelState {
  setState: Action<this, Partial<AuthModelState>>
  setUserID: Thunk<this, void, {}, GlobalStoreModel>
  getXAppToken: Thunk<this, void, {}, GlobalStoreModel, Promise<string>>
  gravityUnauthenticatedRequest: Thunk<
    this,
    {
      path: string
      method?: "GET" | "PUT" | "POST" | "DELETE"
      body?: object
      headers?: RequestInit["headers"]
    },
    {},
    GlobalStoreModel,
    ReturnType<typeof fetch>
  >
  signInUsingEmail: Thunk<this, { email: string; password: string }>
  signOut: Thunk<this>
}

export const AuthModel: AuthModel = {
  ...authModelInitialState,

  setState: action((state, payload) => Object.assign(state, payload)),

  setUserID: thunk(async (actions, _payload, context) => {
    try {
      const user = await (
        await actions.gravityUnauthenticatedRequest({
          path: `/api/v1/me`,
          method: "GET",
          headers: {
            "Content-Type": "application/json",
            "X-ACCESS-TOKEN": context.getState().userAccessToken!,
          },
        })
      ).json()

      actions.setState({
        userID: user.id,
      })
    } catch (error) {
      fail(error)
    }
  }),

  getXAppToken: thunk(async (actions, _payload, context) => {
    const { xAppToken, xApptokenExpiresIn } = context.getState()
    if (xAppToken && xApptokenExpiresIn && new Date() < new Date(xApptokenExpiresIn)) {
      return xAppToken
    }

    const gravityBaseURL = context.getStoreState().config.environment.strings.gravityURL

    const tokenURL = `${gravityBaseURL}/api/v1/xapp_token?${stringify({
      client_id: Config.ARTSY_API_CLIENT_KEY,
      client_secret: Config.ARTSY_API_CLIENT_SECRET,
    })}`

    try {
      const res = await await fetch(tokenURL, {
        headers: {
          "User-Agent": getUserAgent(),
        },
      })

      const resJson = await res.json()
      if (resJson.xapp_token && resJson.expires_in) {
        actions.setState({
          xAppToken: resJson.xapp_token,
          xApptokenExpiresIn: resJson.expires_in,
        })
        return resJson.xapp_token
      }
    } catch (error) {
      fail(error)
    }
  }),

  gravityUnauthenticatedRequest: thunk(async (actions, payload, context) => {
    const gravityBaseURL = context.getStoreState().config.environment.strings.gravityURL
    const xAppToken = await actions.getXAppToken()

    try {
      const res = await fetch(`${gravityBaseURL}${payload.path}`, {
        method: payload.method || "GET",
        headers: {
          "X-Xapp-Token": xAppToken,
          Accept: "application/json",
          "User-Agent": getUserAgent(),
          ...payload.headers,
        },
        body: payload.body ? JSON.stringify(payload.body) : undefined,
      })
      return res
    } catch (error) {
      fail(error)
    }
  }),

  signInUsingEmail: thunk(async (actions, { email, password }) => {
    try {
      const result = await actions.gravityUnauthenticatedRequest({
        path: `/oauth2/access_token`,
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: {
          email,
          oauth_provider: "email",
          password,
          grant_type: "credentials",
          scope: "offline_access",
          client_id: Config.ARTSY_API_CLIENT_KEY,
          client_secret: Config.ARTSY_API_CLIENT_SECRET,
        },
      })
      const resJson = await result.json()
      // // The user has successfully logged in
      if (result.status === 201) {
        const { expires_in, access_token } = resJson
        await actions.setUserID()
        actions.setState({
          userAccessToken: access_token,
          userAccessTokenExpiresIn: expires_in,
        })
        return {
          success: true,
          message: null,
        }
      }
      return {
        success: false,
        message: resJson.error_description || "Unable to log in, please try again later",
      }
    } catch (error) {
      return {
        success: false,
        message: "Something went wrong",
      }
    }
  }),

  signOut: thunk(async (actions) => {
    actions.setState(authModelInitialState)
  }),
}
