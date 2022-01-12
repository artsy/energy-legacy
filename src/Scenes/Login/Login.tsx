import { NativeStackScreenProps } from "@react-navigation/native-stack"
import { GlobalStore } from "@store/GlobalStore"
import { FormikProvider, useFormik, useFormikContext } from "formik"
import { MainNavigationStack } from "MainNavigationStack"
import { Box, Button, Flex, Input, Spacer, Text, useColor, useSpace } from "palette"
import React, { useRef } from "react"
import { Alert, Image, Linking, Platform, ScrollView, TouchableOpacity } from "react-native"
import LinearGradient from "react-native-linear-gradient"
import { useSafeAreaInsets } from "react-native-safe-area-context"
import * as Yup from "yup"

export interface LoginSchema {
  email: string
  password: string
}

export const loginSchema = Yup.object().shape({
  email: Yup.string().email("Please provide a valid email address"),
  password: Yup.string().test("password", "Password field is required", (value) => value !== ""),
})

interface LoginScreenProps extends NativeStackScreenProps<MainNavigationStack, "Home"> {}

const PLAY_STORE_URL = "https://play.google.com/store/apps/details?id=net.artsy.app"
const PLAY_STORE_SCHEME_URL = "artsy://"
const APP_STORE_URL = "https://apps.apple.com/us/app/artsy-buy-sell-original-art/id703796080"
const APP_SCHEME_URL = "artsy:///"

export const LoginScreenContent: React.FC<LoginScreenProps> = ({}) => {
  const color = useColor()
  const space = useSpace()
  const insets = useSafeAreaInsets()

  const { values, handleSubmit, handleChange, validateForm, errors, isValid, dirty, isSubmitting, setErrors } =
    useFormikContext<LoginSchema>()

  const passwordInputRef = useRef<Input>(null)
  const emailInputRef = useRef<Input>(null)

  // TODO: Test this on Android
  const handleOpenArtsyMobile = async () => {
    const storeURL = Platform.OS === "android" ? PLAY_STORE_URL : APP_STORE_URL
    const appSchemeURL = Platform.OS === "android" ? PLAY_STORE_SCHEME_URL : APP_SCHEME_URL

    try {
      const supported = await Linking.canOpenURL(appSchemeURL)

      if (supported) {
        Linking.openURL(appSchemeURL)
      } else {
        Linking.openURL(storeURL)
      }
    } catch (error) {
      console.error("couldn't open artsy mobile app")
    }
  }

  return (
    <LinearGradient
      colors={["#8D8D8D", "#999999", "#A9A9A9", "#B9B9B9", "#838383", "#6A6A6A"]}
      start={{ x: 0, y: 0 }}
      end={{ x: 1, y: 1 }}
      style={{ flex: 1, flexGrow: 1 }}
    >
      <ScrollView
        contentContainerStyle={{ paddingTop: insets.top, paddingHorizontal: space(2) }}
        keyboardShouldPersistTaps="always"
        bounces={false}
      >
        <Text variant="xl" color="white" fontWeight="bold">
          Folio
        </Text>
        <Spacer mt={60} />
        <Text variant="lg" color="white">
          Log In
        </Text>
        <Text variant="md" mt={0.5} color="white">
          With Your Artsy Partner Account
        </Text>
        <Spacer mt={50} />
        <Box>
          <Input
            ref={emailInputRef}
            autoCapitalize="none"
            autoCompleteType="email"
            keyboardType="email-address"
            onChangeText={(text) => {
              handleChange("email")(text.trim())
            }}
            onSubmitEditing={() => {
              validateForm()
              passwordInputRef.current?.focus()
            }}
            onBlur={() => validateForm()}
            blurOnSubmit={false} // This is needed to avoid UI jump when the user submits
            placeholder="Email address"
            placeholderTextColor={color("black30")}
            title="Email"
            titleStyle={{ color: "white" }}
            value={values.email}
            returnKeyType="next"
            spellCheck={false}
            autoCorrect={false}
            // We need to to set textContentType to username (instead of emailAddress) here
            // enable autofill of login details from the device keychain.
            textContentType="username"
            error={errors.email}
          />
          <Spacer mt={2} />
          <Input
            autoCapitalize="none"
            autoCompleteType="password"
            autoCorrect={false}
            onChangeText={(text) => {
              // Hide error when the user starts to type again
              if (errors.password) {
                setErrors({
                  password: undefined,
                })
                validateForm()
              }
              handleChange("password")(text)
            }}
            onSubmitEditing={handleSubmit}
            onBlur={() => validateForm()}
            placeholder="Password"
            placeholderTextColor={color("black30")}
            ref={passwordInputRef}
            secureTextEntry
            title="Password"
            titleStyle={{ color: "white" }}
            returnKeyType="done"
            // We need to to set textContentType to password here
            // enable autofill of login details from the device keychain.
            textContentType="password"
            value={values.password}
            error={errors.password}
          />
        </Box>

        <Spacer mt={1} />

        <TouchableOpacity
          onPress={() => {
            Alert.alert("Oups, not yet implemented")
          }}
        >
          {/* eslint-disable-next-line react-native/no-inline-styles */}
          <Text variant="sm" color="white" style={{ textDecorationLine: "underline" }} textAlign="right">
            Forgot password?
          </Text>
        </TouchableOpacity>

        <Spacer mt={3} />

        <Button
          onPress={handleSubmit}
          block
          haptic="impactMedium"
          disabled={!(isValid && dirty) || isSubmitting} // isSubmitting to prevent weird appearances of the errors caused by async submiting
          loading={isSubmitting}
          testID="loginButton"
          variant="fillDark"
        >
          Log in
        </Button>

        <Spacer mt={2} />

        <Text variant="xs" color="white" textAlign={"center"}>
          Once you log in. Artsy Folio will begin downloading your artworks. We recommend using a stable Wifi
          connection.
        </Text>
      </ScrollView>
      <Flex px={2} paddingBottom={20}>
        <TouchableOpacity onPress={handleOpenArtsyMobile}>
          <Flex flexDirection="row">
            <Image
              resizeMode="contain"
              style={{ height: 50, width: 50 }}
              source={require("images/short-white-logo.png")}
            />
            <Text color="white" ml={1} textAlign="left">
              Looking for Artsy Mobile?{"\n"}Tap here to open
            </Text>
          </Flex>
        </TouchableOpacity>
      </Flex>
    </LinearGradient>
  )
}

const initialValues: LoginSchema = { email: "", password: "" }

export const LoginScreen: React.FC<LoginScreenProps> = ({ navigation, route }) => {
  const formik = useFormik<LoginSchema>({
    enableReinitialize: true,
    validateOnChange: false,
    validateOnBlur: true,
    initialValues,
    initialErrors: {},
    onSubmit: async ({ email, password }) => {
      GlobalStore.actions.auth
        .signInUsingEmail({ email, password })
        .then((res: { success: boolean; message: string }) => {
          if (!res.success) {
            if (res.message) {
              Alert.alert(res.message)
            }
          }
        })
        .catch((error: string) => {
          console.warn(error)
        })
      // const res = await GlobalStore.actions.auth.signInUsingEmail({ email, password })
    },
    validationSchema: loginSchema,
  })

  return (
    <FormikProvider value={formik}>
      <LoginScreenContent navigation={navigation} route={route} />
    </FormikProvider>
  )
}
