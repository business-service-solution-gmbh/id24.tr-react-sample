This is a new [**React Native**](https://reactnative.dev) project, bootstrapped using [`@react-native-community/cli`](https://github.com/react-native-community/cli).

# Getting Started

# Prerequisites
- Prepare react-native environment: https://reactnative.dev/docs/set-up-your-environment
- React Native v0.74.2

## Additional prerequisites for iOS
- XCode 15.3 or higher
- cocoapods 1.14.3
- access to IdentifySDK (contact Identify team to get it)

# Setup iOS
- in terminal in root folder run `npm install`
- in terminal go to ios folder and run `pod install`
- put `IdentifySDK.xcframework` into /ios folder
- open `reactAppIdentify.xcworkspace` in XCode
- drag&drop `IdentifySDK.xcframework` to reactAppIdentify/iosApp
- go to `reactAppIdentify` target then update `Team` and `Bundle Identifier` in `Signing and Capabilities`
- in the same target go to General and in Frameworks, Libraries and Embedded Content find `IdentifySDK.xcframework` 
  and select `Embed and Sign` option

# Configure App
- Set your api URL in App.tsx:
  `const apiUrl = "XXXXXX-ENTERYOURAPIURLHERE-XXXXXX";`

# run iOS
- in root folder run `npm start`
- open another terminal. run `npm run ios`
  - in case of issues, open `reactAppIdentify.xcworkspace` and try to run the app from there
