import { EnvironmentModel } from "./EnvironmentModel"

interface ConfigModelState {
  environment: EnvironmentModel
}

export interface ConfigModel extends ConfigModelState {}

export const ConfigModel: ConfigModel = {
  environment: EnvironmentModel,
}
