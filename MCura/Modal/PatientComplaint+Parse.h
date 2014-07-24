//
//  PatientComplaint+Parse.h
//  3GMDoc
//
//  Created by Aakash Chaudhary on 05/02/12.
//  Copyright (c) 2012 aakash272@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PatientComplaint.h"

@interface PatientComplaint (Parse)

+(NSArray*) PatientComplaintsFromArray:(NSArray*) PatientComplaintsA;
+(PatientComplaint*) PatientComplaintDetailsFromDictionary:(NSDictionary*)PatientComplaintsD;

@end
