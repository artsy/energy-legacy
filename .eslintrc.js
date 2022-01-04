module.exports = {
  root: true,
  extends: ["@react-native-community", "prettier"],
  settings: {
    // This is needed to make eslint happy with name aliases
    "import/resolver": {
      "babel-module": {}
    }
  },
}
