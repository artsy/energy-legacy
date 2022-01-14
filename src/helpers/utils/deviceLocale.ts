import { Platform, NativeModules } from "react-native"

export const deviceLocale: string =
  Platform.OS === "ios"
    ? NativeModules.SettingsManager.settings.AppleLocale || NativeModules.SettingsManager.settings.AppleLanguages[0] //iOS 13
    : NativeModules.I18nManager.localeIdentifier
