This is a new [**React Native**](https://reactnative.dev) project, bootstrapped using [`@react-native-community/cli`](https://github.com/react-native-community/cli).

# Getting Started

# Prerequisites
- Prepare react-native environment: https://reactnative.dev/docs/set-up-your-environment

## Additional prerequisites for iOS
- XCode 15.3 or higher
- cocoapods 1.14.3
- access to IdentifySDK (contact Identify team to get it)

# Setup iOS
- put `IdentifySDK.xcframework` into /ios folder
- in terminal in root folder run `npm install`
- in terminal go to ios folder and run `pod install`
- open `reactAppIdentify.xcworkspace` in XCode
- go to `reactAppIdentify` target update `Team` and `Bundle Identifier` in `Signing and Capabilities`
- in the same target go to general and in Frameworks, Libraries and Embedded Content find `IdentifySDK.xcframework` 
  and select `Embed and Sign` option

# run iOS
  npm start
  in another terminal: npm run android