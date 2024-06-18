//
//  RNEventEmitter.swift
//  reactAppIdentify
//
//  Created by Emir Beytekin on 13.06.2024.
//

import Foundation
import React

@objc(RNEventEmitter)
open class RNEventEmitter:RCTEventEmitter{
  public static var emitter: RCTEventEmitter!
  
  public override static func requiresMainQueueSetup() -> Bool {
    return true;
  }
  
  
  override public init() {
    super.init()
    RNEventEmitter.emitter = self
  }
  
  open override func supportedEvents() -> [String]! {
    return IdentifyEventName.allCases.map { $0.rawValue }
  }
}

enum IdentifyEventName: String, CaseIterable {
    case onCallProcessFinished = "IdentifyReactNative:callProcessFinished"
    case onNfcProcessFinished = "IdentifyReactNative:nfcProcessFinished"
    case onSpeechProcessFinished = "IdentifyReactNative:speechProcessFinished"
    case onTakeCardPhotoProcessFinished = "IdentifyReactNative:takeCardPhotoProcessFinished"
    case onTakeSelfieProcessFinished = "IdentifyReactNative:takeSelfieProcessFinished"
    case onValidateAddressProcessFinished = "IdentifyReactNative:validateAddressProcessFinished"
    case onVideoRecordProcessFinished = "IdentifyReactNative:videoRecordProcessFinished"
    case onLivenessDetectionProcessFinished = "IdentifyReactNative:livenessDetectionProcessFinished"
    case onSignatureProcessFinished = "IdentifyReactNative:signatureProcessFinished"
    case onBackPressed = "IdentifyReactNative:backPressed"
    case onRedirectCallProcess = "IdentifyReactNative:redirectCallProcess"
    case onSdkDestroyed = "IdentifyReactNative:sdkDestroyed"
    case onSdkPaused = "IdentifyReactNative:sdkPaused"
    case onSdkResumed = "IdentifyReactNative:sdkResumed"
    case onWebRTCInitCall = "IdentifyReactNative:onInitCall"
    case onWebRTCStartCall = "IdentifyReactNative:onStartCall"
    case onWebRTCTerminatedCall = "IdentifyReactNative:onTerminatedCall"
    case onWebRTCCustomerIsOnline = "IdentifyReactNative:onCustomerIsOnline"
    case onWebRTCCustomerIsOffline = "IdentifyReactNative:onCustomerIsOffline"
    case onWebRTCSubscribed = "IdentifyReactNative:onSubscribed"
    case onWebRTCSubRejected = "IdentifyReactNative:onSubRejected"
    case onWebRTCMissedCall = "IdentifyReactNative:onMissedCall"
    case onWebRTCToggledCamera = "IdentifyReactNative:onToggledCamera"
    case onAllProcessFinished = "IdentifyReactNative:allProcessFinished"
}
