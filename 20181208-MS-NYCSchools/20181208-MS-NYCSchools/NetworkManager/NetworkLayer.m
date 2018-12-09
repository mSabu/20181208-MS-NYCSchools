//
//  NetworkLayer.m
//  20181208-MS-NYCSchools
//
//  Created by Manjusha Satheesh Sabu on 12/8/18.
//  Copyright © 2018 msabu. All rights reserved.
//

#import "NetworkLayer.h"
#import "NYSchoolListViewController.h"
#import "Reachability.h"

@implementation NetworkLayer

+(void)downloadURL:(NSURL*)url WithCompletionHandler: (void(^)(NSData* responseData, NSError * error)) handler {

    if(![NetworkLayer checkInternetAccess]){
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey: NSLocalizedString(@"Network not Available.", nil)};
        NSError *err = [NSError errorWithDomain:kNYCErrorDomain
                                           code:NYNetworkNotReachableError
                                       userInfo:userInfo];
        handler(nil,err);
    }
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithRequest:request
                completionHandler:^(NSData *data,
                                    NSURLResponse *response,
                                    NSError *error) {
                    if (error) {
                        handler(nil,error) ;
                    }
                    if (((NSHTTPURLResponse*)response).statusCode == 200) {
                        handler(data,nil) ;
                    }
                    else {
                        NSDictionary *userInfo = @{ NSLocalizedDescriptionKey: NSLocalizedString(@"Operation was unsuccessful.", nil)};
                        NSError *err = [NSError errorWithDomain:kNYCErrorDomain
                                                           code:((NSHTTPURLResponse*)response).statusCode
                                                       userInfo:userInfo];
                        handler(nil,err) ;
                    }
                }] resume];
}

+(BOOL)checkInternetAccess
{
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    [reach startNotifier];
    NetworkStatus status = [reach currentReachabilityStatus];
    if(status == NotReachable) return NO ;
    else return YES ;
}

@end
