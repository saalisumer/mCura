//
//  DoctorDetails+Parse.h
//  mCura
//
//  Created by Aakash Chaudhary on 16/04/12.
//  Copyright (c) 2012 aakash272@gmail.com. All rights reserved.
//

#import "DoctorDetails.h"

@interface DoctorDetails (Parse)

+(DoctorDetails*) DoctorDetailsFromDictionary:(NSDictionary*)DoctorDetailsd;
+(NSArray*) DoctorDetailsFromArray:(NSArray*)DoctorDetailsA;

@end
