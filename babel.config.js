const presets = [
  "module:metro-react-native-babel-preset"
]

const plugins = [
  // the relay plugin should run before other plugins or presets
  // to ensure the graphql template literals are correctly transformed
  "relay",
  [
      "module-resolver",
      {
        "root": ["./"],
        "alias": {
          "@Scenes": "./src/Scenes",
          "@store": "./src/store",
          "@relay": "./src/relay",
          "@helpers": "./src/helpers",
          "@assets": "./src/assets",
        }
      }
  ],
]

if (process.env.CI) {
  // When running a bundled app, these statements can cause a big bottleneck in the JavaScript thread.
  // This includes calls from debugging libraries and logs we might forget to remove
  plugins.push("transform-remove-console")
}

module.exports = { presets, plugins }
