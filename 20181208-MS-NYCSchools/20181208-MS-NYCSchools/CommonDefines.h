//
//  CommonDefines.h
//  20181208-MS-NYCSchools
//
//  Created by Manjusha Satheesh Sabu on 12/9/18.
//  Copyright © 2018 msabu. All rights reserved.
//

#ifndef CommonDefines_h
#define CommonDefines_h

#define kNYCErrorDomain @"com.nycschoolist.error"

#define NYNetworkNotReachableError 500

#define kSchoolDetailJsonURL @"https://data.cityofnewyork.us/resource/734v-jeq5.json"
#define kSchoolListJsonURL @"https://data.cityofnewyork.us/resource/97mf-9njv.json"


#define kSectionTitle @"sectionTitle"
#define kSectionItem @"sectionItem"
#define kSectionTag @"sectionTag"

#define kShowDetailId @"showSchoolDetail"

typedef enum {
    NYSSchoolInfo,
    NYSLocationInfo,
    NYSStudentInfo,
    NYSContactInfo,
    NYSOverviewInfo,
    NYSPriorityInfo,
    NYSOpportunityInfo,
    NYSRequirementInfo,
    NYSTransportInfo
} kNYSSectionTag;


#endif /* CommonDefines_h */
