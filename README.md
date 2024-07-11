This is a new [**React Native**](https://reactnative.dev) project, bootstrapped using [`@react-native-community/cli`](https://github.com/react-native-community/cli).

# Getting Started

## Prerequisites
- Prepare react-native environment: https://reactnative.dev/docs/set-up-your-environment
- React Native v0.74.2
- Latest Android Studio or VS Code as IDE
- Node 18.15.0

## Additional prerequisites for iOS
- XCode 15.3 or higher
- cocoapods 1.14.3
- access to IdentifySDK (contact Identify team to get it)

## Additional prerequisites for Android
- access to IdentifySDK (contact Identify team to get it)

## Setup iOS
- in terminal in root folder run `npm install`
- in terminal go to ios folder and run `pod install`
- open `reactAppIdentify.xcworkspace` in XCode
- drag&drop `IdentifySDK.xcframework` to XCode into the folder reactAppIdentify/iosApp
  - Select `Copy items if needed` option
- go to `reactAppIdentify` target then update `Team` and `Bundle Identifier` in `Signing and Capabilities`
- in the same target go to General and in Frameworks, Libraries and Embedded Content find `IdentifySDK.xcframework` 
  and select `Embed and Sign` option

## Setup Android
- in terminal in root folder run `npm install`
- in android/build.gradle enter correct credentials you obtained from BSS
  `maven {
    url = 'https://maven.pkg.github.com/business-service-solution-gmbh/id24.tr-android-sdk'
    name = "GitHubPackages"
    credentials {
      username = "bssserviceacc"
      password = "xxxxxxxxx"
    }
  }`
- in case you need to change SDK version, you can do it by changing build.gradle in design module:
  `api 'com.identify.sdk:android:1.5.0'` (don't forget to update design folder accordingly)
- run gradle sync

## Configure App
- Set your api URL in App.tsx:
  `const apiUrl = "XXXXXX-ENTERYOURAPIURLHERE-XXXXXX";`

## Run iOS
- in root folder run `npm start` to start dev server
- open another terminal. run `npm run ios`
  - in case of issues, open `reactAppIdentify.xcworkspace` and try to run the app from there

## Run Android
- in root folder run `npm start` to start dev server
- open another terminal. run `npm run android`
  - in case of issues, open android module in your Android IDE and try gradle sync.
    Additionally, you can check logcat for logs 
