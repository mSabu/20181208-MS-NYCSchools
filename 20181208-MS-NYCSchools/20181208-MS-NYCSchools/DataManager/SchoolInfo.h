//
//  SchoolInfo.h
//  20181208-MS-NYCSchools
//
//  Created by Manjusha Satheesh Sabu on 12/7/18.
//  Copyright © 2018 msabu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SchoolInfo : NSObject

@property (strong, nonatomic) NSString* schoolName;
@property (strong, nonatomic) NSString* dbnId;
@property (strong, nonatomic) NSDictionary* satStatisticsInfo;
@property (strong, nonatomic) NSArray* schoolInfoDetails;


//@property (strong, nonatomic) NSString* locationInfo; //location - without cordinates



@end

NS_ASSUME_NONNULL_END
