//
//  NetworkLayer.h
//  20181208-MS-NYCSchools
//
//  Created by Manjusha Satheesh Sabu on 12/8/18.
//  Copyright © 2018 msabu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NetworkLayer : NSObject

+(void)downloadURL:(NSURL*)url WithCompletionHandler: (void(^)(NSData* responseData, NSError * error)) handler ;


@end

NS_ASSUME_NONNULL_END
