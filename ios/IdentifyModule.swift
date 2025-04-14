//
//  IdentifyReactNative.swift
//  reactAppIdentify
//
//  Created by Emir Beytekin on 13.06.2024.
//

import Foundation
import UIKit
import IQKeyboardManagerSwift
import netfox
import IdentifySDK
import React

public enum IdentifyEvents {
  case sendTrackingMessage
  case callTerminated
}

@objc(IdentifyModule)
class IdentifyModule: RCTEventEmitter {
  
  static var instance: IdentifyModule?
  
  let manager = IdentifyManager.shared
  
  var subRejected = false
  
  override init() {
    super.init()
    IdentifyModule.instance = self
  }
  
  override static func moduleName() -> String! {
    "IdentifyModule"
  }
  
  override static func requiresMainQueueSetup() -> Bool {
    return true;
  }
  
  override func addListener(_ eventName: String!) {
    super.addListener(eventName)
  }
  
  override func removeListeners(_ count: Double) {
    super.removeListeners(count)
  }
  
  override func supportedEvents() -> [String]! {
    return ["TrackingEventReceived", "CallTerminated"]
  }
  
  @objc
  func startIdentification(_ apiUrl: String!, identId: String!, language: String!) {
    UINavigationBar.appearance().tintColor = .white
    DispatchQueue.main.async {
      self.configureSDK(language)
      self.connectSDK(apiUrl, identId: identId, language: language)
    }
  }
  
  public func sendEventToReact(event: IdentifyEvents, message: [String: Any?]?) {
    switch (event) {
    case .sendTrackingMessage:
      sendEvent(withName: "TrackingEventReceived", body: message)
    case .callTerminated:
      sendEvent(withName: "CallTerminated", body: nil)
    }
  }
  
  func configureSDK(_ language: String) {
    if language == "tr" {
        self.manager.setSDKLang(lang: .tr)
    } else if language == "en" {
        self.manager.setSDKLang(lang: .eng)
    } else if language == "de" {
        self.manager.setSDKLang(lang: .de)
    }
        
    self.manager.loginModuleController = SDKLoginViewController.instantiate()
    self.manager.selfieModuleController = SDKSelfieViewController.instantiate()
    self.manager.idCardModuleController = SDKCardReaderViewController.instantiate()
    self.manager.nfcModuleController = SDKNfcViewController.instantiate()
    self.manager.signatureModuleController = SDKSignatureViewController.instantiate()
    self.manager.videoRecorderModuleController = SDKVideoRecorderViewController.instantiate()
    self.manager.livenessModuleController = SDKLivenessViewController.instantiate()
    self.manager.addressModuleController = SDKAddressConfirmViewController.instantiate()
    self.manager.liveStreamModuleController = SDKCallScreenViewController.instantiate()
    self.manager.speechModuleController = SDKSpeechRecViewController.instantiate()
    self.manager.thankYouViewController = SDKThankYouViewController.instantiate()
    self.manager.prepareViewController = SDKPrepareViewController.instantiate()
    
    self.manager.socketMessageListener = self // use the listener to detect if another person is present in the room.
    self.manager.trackingDelegate = self  // receive tracking events

    if manager.jailBreakStatus {
//      Jailbreak detected on the device — handle this case as needed
    }
  }
  
  // You are able to pass more properties here in order to configure the SDK
  private func connectSDK(_ apiUrl: String!, identId: String!, language: String!) {
      if language == "tr" {
          self.manager.setSDKLang(lang: .tr)
      } else if language == "en" {
          self.manager.setSDKLang(lang: .eng)
      } else if language == "de" {
          self.manager.setSDKLang(lang: .de)
      }
    
      self.manager.setupSDK(
          identId: identId,
          baseApiUrl: apiUrl,
          networkOptions: SDKNetworkOptions(timeoutIntervalForRequest: 30, timeoutIntervalForResource: 30, useSslPinning: false),
          kpsData: nil, // if data is comming from KPS, configure it here
//          kpsData: SDKKpsData(birthDate: "860704", validDate: "130627", serialNo: "YZM33MR63"),
          identCardType: [.idCard, .passport, .oldSchool], // supported card types
          signLangSupport: false, // representative support for tje hearing impaired
          nfcMaxErrorCount: 3,
          logLevel: .all,
          bigCustomerCam: false,
          selectedModules: [],
          idCardLang: .TR
      ) { socketStats, apiResp, webErr in
          print("socket resp : \(socketStats)")
          if let err = webErr, let errorMessage = err.errorMessages, errorMessage != "" { // error from backend
            print("error connecting to server: \(errorMessage)")
          } else { // in case no errors, continue
              if socketStats?.isConnected ==  true {
                  if apiResp.result ?? false {
                    self.manager.moduleStepOrder = 0
                    self.manager.getNextModule { nextVC in
                      let navigationC = UINavigationController(rootViewController: nextVC)
                      navigationC.isModalInPresentation = true
                      
                      UINotificationFeedbackGenerator().notificationOccurred(.success)
                      
                      let topController = UIApplication.topViewController()

                      DispatchQueue.main.async {
//                        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
//                          return
//                        }
//                        appDelegate.window.rootViewController = navigationC
//                        appDelegate.window.makeKeyAndVisible()
                        topController?.present(navigationC, animated: true) // best to use topController, so we can present SDK modally
                      }
                    }
                  } else if (socketStats?.isConnected == false) {
                      print("socket result false")
                  }
              } else {
                  print("socket not connected")
              }
          }
        }
    }
}


extension IdentifyModule: SDKSocketListener {
    func listenSocketMessage(message: SDKCallActions) {
        switch message {
            case .wrongSocketActionErr(let error):
                print("wrongSocketActionErr: \(error)")
                break
            case .subrejectedDismiss:
                self.subRejected = true
                break
            default:
                self.subRejected = false
                break
        }
    }
}

extension IdentifyModule: IdentifyTrackingListener {
    func eventReceived(event: IdentifySDK.TrackingEvent) {
        let eventTypeDescription = event.eventType.map { String(describing: $0) } ?? "Unknown"
        
        let body: [String: Any?] = [
          "eventType": eventTypeDescription,
          "context": event.context ?? [:],
          "time": event.time ?? "No Time"
        ]
      
        self.sendEventToReact(event: .sendTrackingMessage, message: body)
    }
}
