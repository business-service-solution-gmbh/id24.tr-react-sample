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


@objc(IdentifyModule)
class IdentifyModule: RCTEventEmitter {
  
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
      return ["TrackingEventReceived"]
  }
  
  @objc
  func startIdentification(_ apiUrl: String!, identId: String!, language: String!) {
    
    DispatchQueue.main.async {
      guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
          return
      }

      let firstVC = SDKIdentifyLoginViewController()
      firstVC.reactEventListener = self
      firstVC.cominId = identId
      firstVC.cominUrl = apiUrl
      firstVC.cominLang = language
      let firstNC = UINavigationController(rootViewController: firstVC)
      UINavigationBar.appearance().tintColor = .white
      appDelegate.window.rootViewController = firstNC
      appDelegate.window.makeKeyAndVisible()
    }
    
  }
}

extension IdentifyModule: ReactEventListener {
  func sendTrackingMessage(message: IdentifySDK.TrackingEvent) {
    let eventTypeDescription = message.eventType.map { String(describing: $0) } ?? "Unknown"
    
    let body: [String: Any?] = [
      "eventType": eventTypeDescription,
      "context": message.context ?? [:],
      "time": message.time ?? "No Time"
    ]
        
    sendEvent(withName: "TrackingEventReceived", body: body)
  }
}
