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
  
  var mainController: UINavigationController?
  var loginController: SDKIdentifyLoginViewController?
  
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
      firstVC.loginDelegate = self
      
      self.loginController = firstVC
      self.mainController = UINavigationController(rootViewController: self.loginController!)
      
      firstVC.setupSDK()

//      appDelegate.window.rootViewController = self.mainController!
//      appDelegate.window.makeKeyAndVisible()
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

extension IdentifyModule: SDKIdentifyLoginDelegate {
  func onIdentifyLoginSuccess() {
    DispatchQueue.main.async {
      guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
        return
      }
      appDelegate.window.rootViewController = self.mainController!
      appDelegate.window.makeKeyAndVisible()
      self.loginController!.startSDK()
    }
  }
  
  func onIdentifyLoginFailure() {
    print("FAILED")
  }
  
  
}
