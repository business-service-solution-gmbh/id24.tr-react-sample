//
//  IdentifyModule.m
//  reactAppIdentify
//
//  Created by Emir Beytekin on 17.06.2024.
//

#import <Foundation/Foundation.h>
#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(IdentifyModule, NSObject)
RCT_EXTERN_METHOD(startIdentification:(NSString *)apiUrl
                  identId:(NSString *)identId
                  language:(NSString *)language)
@end
