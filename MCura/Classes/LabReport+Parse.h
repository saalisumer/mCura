//
//  LabReport+Parse.h
//  mCura
//
//  Created by Aakash Chaudhary on 05/03/12.
//  Copyright (c) 2012 aakash272@gmail.com. All rights reserved.
//

#import "LabReport.h"

@interface LabReport (Parse)

+(LabReport*) LabReportFromDictionary:(NSDictionary*)LabReportD;
+(NSArray*) LabReportFromArray:(NSArray*) LabReportA;

@end
