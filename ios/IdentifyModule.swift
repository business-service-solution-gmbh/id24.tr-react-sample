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
    
    DispatchQueue.main.async {
      guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
        return
      }
      
      let firstVC = SDKIdentifyLoginViewController()
      firstVC.cominId = identId
      firstVC.cominUrl = apiUrl
      firstVC.cominLang = language
      let firstNC = UINavigationController(rootViewController: firstVC)
      UINavigationBar.appearance().tintColor = .white
      appDelegate.window.rootViewController = firstNC
      appDelegate.window.makeKeyAndVisible()
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
}
