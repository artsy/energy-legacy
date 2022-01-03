module.exports = {
  presets: ["module:metro-react-native-babel-preset"],
  plugins: [
    // the relay plugin should run before other plugins or presets
    // to ensure the graphql template literals are correctly transformed
    "relay",
  ],
}
