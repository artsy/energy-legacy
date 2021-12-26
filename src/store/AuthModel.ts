import { action, Action } from "easy-peasy"

interface AuthModelState {
  userAccessToken: string | null
  xAppToken: string | null
  xApptokenExpiresIn: string | null
}

export interface AuthModel extends AuthModelState {
  setState: Action<this, Partial<AuthModelState>>
}

export const authModel: AuthModel = {
  userAccessToken: null,
  xAppToken: null,
  xApptokenExpiresIn: null,
  setState: action((state, payload) => Object.assign(state, payload)),
}
