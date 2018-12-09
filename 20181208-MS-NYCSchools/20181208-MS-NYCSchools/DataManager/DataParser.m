//
//  DataParser.m
//  20181208-MS-NYCSchools
//
//  Created by Manjusha Satheesh Sabu on 12/7/18.
//  Copyright © 2018 msabu. All rights reserved.
//

#import "DataParser.h"

@implementation DataParser

+(NSArray*)parseSchoolListJson:(NSData *)data{
    
    NSArray *resultArray = [[NSJSONSerialization JSONObjectWithData:data  options:NSJSONReadingAllowFragments error:NULL] mutableCopy] ;
    
    if (resultArray && [resultArray isKindOfClass:[NSArray class]] ) {
        __block NSMutableArray * schoolsList = [NSMutableArray array];
        [resultArray enumerateObjectsUsingBlock:^(NSDictionary * schoolDict, NSUInteger idx, BOOL * _Nonnull stop) {
            
            SchoolInfo * schoolInfo = [SchoolInfo new];
            schoolInfo.dbnId = schoolDict[@"dbn"];
            schoolInfo.schoolName = schoolDict[@"school_name"];
            
            NSMutableArray * schoolDetails = [NSMutableArray array] ;
            
            NSMutableString * address = [schoolDict[@"location"] mutableCopy] ? : @"";
            NSRegularExpression *regex = [NSRegularExpression
                                          regularExpressionWithPattern:@"\\(.+?\\)"
                                          options:NSRegularExpressionCaseInsensitive
                                          error:NULL];
            if (address && address.length) {
                [regex replaceMatchesInString:address
                                      options:0
                                        range:NSMakeRange(0, [address length])
                                 withTemplate:@""];
            }
            

            [schoolDetails addObject:@{ kSectionTag : @(NYSLocationInfo),
                                        kSectionTitle : @"Location" ,
                                        kSectionItem : @{@"Address" : address,
                                                        @"City" : schoolDict[@"city"],
                                                         @"Boro" :schoolDict[@"boro"]
                                                         }
                                       }];
            
            [schoolDetails addObject:@{ kSectionTag : @(NYSOverviewInfo),
                                        kSectionTitle : @"School Overview" ,
                                        kSectionItem : schoolDict[@"overview_paragraph"]
                                        }];
            
            NSMutableDictionary * contactDict = [NSMutableDictionary dictionary];
            if (schoolDict[@"website"]) {
                [contactDict setObject:schoolDict[@"website"] forKey:@"website"];
            }
            if (schoolDict[@"phone_number"]) {
                [contactDict setObject:schoolDict[@"phone_number"] forKey:@"phoneNum"];
            }
            if (schoolDict[@"school_email"]) {
                [contactDict setObject:schoolDict[@"school_email"] forKey:@"email"];
            }
            [schoolDetails addObject:@{ kSectionTag : @(NYSContactInfo),
                                        kSectionTitle : @"Contact Us" ,
                                        kSectionItem : contactDict
                                        }];
            
            NSMutableArray * oppArray = [NSMutableArray array];
            if (schoolDict[@"academicopportunities1"]) {
                [oppArray addObject:schoolDict[@"academicopportunities1"]];
            }
            if (schoolDict[@"academicopportunities2"]) {
                [oppArray addObject:schoolDict[@"academicopportunities2"]];
            }
            if (schoolDict[@"academicopportunities3"]) {
                [oppArray addObject:schoolDict[@"academicopportunities3"]];
            }
            [schoolDetails addObject:@{ kSectionTag : @(NYSOpportunityInfo),
                                        kSectionTitle : @"Student Opportunities" ,
                                        kSectionItem : oppArray
                                        }];
            
            NSMutableArray * reqtArray = [NSMutableArray array];
            if (schoolDict[@"requirement1_1"]) {
                [reqtArray addObject:schoolDict[@"requirement1_1"]];
            }
            if (schoolDict[@"requirement2_1"]) {
                [reqtArray addObject:schoolDict[@"requirement2_1"]];
            }
            if (schoolDict[@"requirement3_1"]) {
                [reqtArray addObject:schoolDict[@"requirement3_1"]];
            }
            if (reqtArray.count) {
                [schoolDetails addObject:@{ kSectionTag : @(NYSRequirementInfo),
                                            kSectionTitle : @"Admission Requirements" ,
                                            kSectionItem : reqtArray
                                            }];
            }
            
            NSMutableArray * priorityArray = [NSMutableArray array];
            if (schoolDict[@"admissionspriority11"]) {
                [priorityArray addObject:schoolDict[@"admissionspriority11"]];
            }
            if (schoolDict[@"admissionspriority21"]) {
                [priorityArray addObject:schoolDict[@"admissionspriority21"]];
            }
            if (schoolDict[@"admissionspriority31"]) {
                [priorityArray addObject:schoolDict[@"admissionspriority31"]];
            }
            
            if (priorityArray && priorityArray.count) {
                [schoolDetails addObject:@{ kSectionTag : @(NYSPriorityInfo),
                                            kSectionTitle : @"Admissions Priority" ,
                                            kSectionItem : priorityArray
                                            }] ;
            }
            
            [schoolDetails addObject:@{ kSectionTag : @(NYSStudentInfo),
                                        kSectionTitle : @"Student Info",
                                        kSectionItem : @{@"Attendance Rate" : [NSString stringWithFormat:@"%2.0f %%",  ([schoolDict[@"attendance_rate"]floatValue] * 100)],
                                                        @"Total Students" : schoolDict[@"total_students"]}
                                       }];
             
            [schoolDetails addObject:@{ kSectionTag : @(NYSTransportInfo),
                                        kSectionTitle : @"Transport Info" ,
                                        kSectionItem : @{@"Subway" : schoolDict[@"subway"],
                                                         @"Bus" : schoolDict[@"bus"] }
                                        }];
              
            schoolInfo.schoolInfoDetails = schoolDetails ;

            [schoolsList addObject:schoolInfo];
        }];
        
        return schoolsList;
    }
    
    return nil;
}

+(NSDictionary *)parseSchoolDetailJson:(NSData *)data {
    
    NSArray *results = [[NSJSONSerialization JSONObjectWithData:data  options:NSJSONReadingAllowFragments error:NULL] mutableCopy]  ;

    NSLog(@"results : %@", results);
    
    // SAT Statisctics
    if (results && [results isKindOfClass:[NSArray class]]) {
        NSDictionary *resultDictionary = [results firstObject];
        if (resultDictionary && [resultDictionary isKindOfClass:[NSDictionary class]]) {
            NSMutableDictionary * satStatistics = [NSMutableDictionary dictionary];
            
            if (resultDictionary[@"num_of_sat_test_takers"]) {
                [satStatistics setObject:resultDictionary[@"num_of_sat_test_takers"] forKey:@"TestTakers"];
            }
            if (resultDictionary[@"sat_critical_reading_avg_score"]) {
                [satStatistics setObject:resultDictionary[@"sat_critical_reading_avg_score"] forKey:@"ReadingScore"];
            }
            if (resultDictionary[@"sat_math_avg_score"]) {
                [satStatistics setObject:resultDictionary[@"sat_math_avg_score"] forKey:@"MathScore"];
            }
            if (resultDictionary[@"sat_writing_avg_score"]) {
                [satStatistics setObject:resultDictionary[@"sat_writing_avg_score"] forKey:@"WritingScore"];
            }
            
            return satStatistics ;
        }
    }
    return nil ;
}

@end
