//#import <Foundation/Foundation.h>
//#import <React/RCTBridgeModule.h>
//#import <React/RCTEventEmitter.h>
//
//
//@interface RCT_EXTERN_MODULE(IdentifyModule, NSObject)
//
//RCT_EXTERN_METHOD(startIdentification:
//                  apiUrl:(NSString *)apiUrl
//                  identId:(NSString *)identId
//                  language:(NSString *)language) {
//  RCTLogInfo(@"Starting identification with URL: %@, ID: %@, Language: %@", apiUrl, identId, language);
//}
//@end


#import "IdentifyModule.h"
#import <React/RCTLog.h>
#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>

@implementation IdentifyModule

RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(startIdentification:(NSString *)apiUrl
                  identId:(NSString *)identId
                  language:(NSString *)language)
{
  RCTLogInfo(@"Starting identification with URL: %@, ID: %@, Language: %@", apiUrl, identId, language);
  // Burada startIdentification fonksiyonunuzu implement edin
}

@end
