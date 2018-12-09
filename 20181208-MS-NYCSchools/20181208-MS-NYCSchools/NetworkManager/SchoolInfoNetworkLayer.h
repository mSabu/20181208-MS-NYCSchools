//
//  SchoolInfoNetworkLayer.h
//  20181208-MS-NYCSchools
//
//  Created by Manjusha Satheesh Sabu on 12/8/18.
//  Copyright © 2018 msabu. All rights reserved.
//

#import "NetworkLayer.h"

NS_ASSUME_NONNULL_BEGIN



@interface SchoolInfoNetworkLayer : NetworkLayer

+(instancetype)sharedInstance;

-(void)downloadSchoolDetails:(NSString*)dbnID withCompletionHandler: (void(^)(NSDictionary* response, NSError * error)) handler ;

-(void)downloadSchoolListWithCompletionHandler: (void(^)(NSArray* response, NSError * error)) handler ;

@end

NS_ASSUME_NONNULL_END
