import { computed, Computed } from "easy-peasy"

type Environment = "staging" | "production"

interface EnvironmentOptionDescriptor {
  readonly description: string
  readonly presets: { readonly [k in Environment]: string }
}

// helper to get good typings and intellisense
function defineEnvironmentOptions<EnvOptionName extends string>(options: {
  readonly [k in EnvOptionName]: EnvironmentOptionDescriptor
}) {
  return options
}

export const environmentOptions = defineEnvironmentOptions({
  gravityURL: {
    description: "Gravity URL",
    presets: {
      staging: "https://stagingapi.artsy.net",
      production: "https://api.artsy.net",
    },
  },
  metaphysicsURL: {
    description: "Metaphysics URL",
    presets: {
      staging: "https://metaphysics-staging.artsy.net/v2",
      production: "https://metaphysics-production.artsy.net/v2",
    },
  },
})

export type EnvironmentKey = keyof typeof environmentOptions

interface EnvironmentModelState {
  activeEnvironment: Environment
}

export interface EnvironmentModel extends EnvironmentModelState {
  strings: Computed<EnvironmentModel, { [k in EnvironmentKey]: string }>
}

export const EnvironmentModel: EnvironmentModel = {
  // TODO:
  // CRITICAL!
  // Detect if this is a test build or a production build
  // WE CAN NOT GO LIVE WITH THIS
  // See https://github.com/artsy/eigen/blob/2c4797a6f6395fd2a054570de0f70c37996e4533/src/lib/store/config/EnvironmentModel.tsx#L80
  // Reach out to #practice-mobile for more information
  activeEnvironment: "staging",
  strings: computed(({ activeEnvironment }) => {
    const result: { [k in EnvironmentKey]: string } = {} as any

    for (const [key, val] of Object.entries(environmentOptions)) {
      result[key as EnvironmentKey] = val.presets[activeEnvironment]
    }

    return result
  }),
}
