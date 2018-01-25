#import "WKWebViewSyncCookies.h"
#import <Cordova/CDV.h>

@implementation WKWebViewSyncCookies

- (void)sync:(CDVInvokedUrlCommand *)command {
  @try {
    NSString *urlHttpMethod = command.arguments[0];
    NSString *urlString = command.arguments[1];
    NSString *postString = command.arguments[2];
    NSURL *url = [NSURL URLWithString:urlString];

    NSData *postData = [postString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES]; 
    NSString *postLength = [NSString stringWithFormat:@"%d",[postData length]]; 

    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setHTTPMethod:urlHttpMethod];
    [urlRequest setValue:postLength forHTTPHeaderField:@"Content-Length"]; 
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [urlRequest setValue:@"application/vnd.mtp.cookie.v1+json" forHTTPHeaderField:@"Content-Type"]
    [urlRequest setHTTPBody:postData];

    NSURLSession *urlSession = [NSURLSession sharedSession];

    [[urlSession dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable urlResponse, NSError * _Nullable error) {
      CDVPluginResult *result;

      if (error) {
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[error localizedDescription]];
      } else {
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
      }

      [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
    }] resume];
  }
  @catch (NSException *exception) {
    CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:exception.reason];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
  }
}

@end
