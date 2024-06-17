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
class IdentifyModule: NSObject, RCTBridgeModule{
  
  static func moduleName() -> String! {
    "IdentifyModule"
  }

  static func requiresMainQueueSetup() -> Bool {
    return true;
  }
  
  @objc
  func startIdentification(_ apiUrl: String!, identId: String!, language: String!) {
    
    DispatchQueue.main.async {
      guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
          return
      }

      let firstVC = SDKIdentifyLoginViewController()
      let firstNC = UINavigationController(rootViewController: firstVC)
      UINavigationBar.appearance().tintColor = .white
      appDelegate.window.rootViewController = firstNC
      appDelegate.window.makeKeyAndVisible()
    }
    
  }
}
