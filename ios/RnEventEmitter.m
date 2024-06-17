//
//  RnEventEmitter.m
//  reactAppIdentify
//
//  Created by Emir Beytekin on 13.06.2024.
//

#import <Foundation/Foundation.h>
#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>


@interface RCT_EXTERN_MODULE(RNEventEmitter, RCTEventEmitter)
RCT_EXTERN_METHOD(supportedEvents)
@end
