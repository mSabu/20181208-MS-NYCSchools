//
//  DataParser.h
//  20181208-MS-NYCSchools
//
//  Created by Manjusha Satheesh Sabu on 12/7/18.
//  Copyright © 2018 msabu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DataParser : NSObject

+(NSArray *)parseSchoolListJson:(NSData *)data;

+(NSDictionary *)parseSchoolDetailJson:(NSData *)data;

@end

NS_ASSUME_NONNULL_END
