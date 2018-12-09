//
//  SchoolInfoNetworkLayer.m
//  20181208-MS-NYCSchools
//
//  Created by Manjusha Satheesh Sabu on 12/8/18.
//  Copyright © 2018 msabu. All rights reserved.
//

#import "SchoolInfoNetworkLayer.h"
#import "DataParser.h"

@implementation SchoolInfoNetworkLayer

+(instancetype)sharedInstance {
    static SchoolInfoNetworkLayer * sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^ {
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

-(void)downloadSchoolDetails:(NSString*)dbnID withCompletionHandler: (void(^)(NSDictionary* response, NSError * error)) handler {
    
    NSString * query = [NSString stringWithFormat:@"%@?dbn=%@",kSchoolDetailJsonURL ,dbnID];
    [SchoolInfoNetworkLayer downloadURL:[NSURL URLWithString:query] WithCompletionHandler:^(NSData * _Nonnull responseData, NSError * _Nonnull error) {
        if (error) {
            handler(nil,error);
        }
        if(responseData) {
            NSDictionary * schoolDict = [DataParser parseSchoolDetailJson:responseData] ;
            handler(schoolDict,nil);
        }
    }] ;
}

-(void)downloadSchoolListWithCompletionHandler: (void(^)(NSArray* response, NSError * error)) handler {
    [SchoolInfoNetworkLayer downloadURL:[NSURL URLWithString:kSchoolListJsonURL] WithCompletionHandler:^(NSData * _Nonnull responseData, NSError * _Nonnull error) {
        if (error) {
            if (error.code == NYNetworkNotReachableError) {
                responseData = [self getJSONFileFromSaved:@"SchoolList.json"];
            }
            if (!responseData) {
                handler(nil,error);
            }
        }
        if (responseData) {
            NSArray * schoolList = [DataParser parseSchoolListJson:responseData] ;
            [self saveJSONFileToDocuments:responseData withFileName:@"SchoolList.json"];
            handler(schoolList,nil);
        }
    }];
}

-(void)saveJSONFileToDocuments: (NSData *) data withFileName: (NSString *)fileName  {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *filePath = [documentsPath stringByAppendingPathComponent:fileName];
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        [data writeToFile:filePath atomically:YES];
    }
}

-(NSData *)getJSONFileFromSaved:(NSString *)fileName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * filePath = [NSString stringWithFormat:@"%@/%@",[paths objectAtIndex:0], fileName] ;
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSData * data = [NSData dataWithContentsOfFile:filePath];
        return data;
    }
    return nil;
}

@end
