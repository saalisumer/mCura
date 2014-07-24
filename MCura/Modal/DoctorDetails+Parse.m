//
//  DoctorDetails+Parse.m
//  mCura
//
//  Created by Aakash Chaudhary on 16/04/12.
//  Copyright (c) 2012 aakash272@gmail.com. All rights reserved.
//

#import "DoctorDetails+Parse.h"

@implementation DoctorDetails (Parse)

+(DoctorDetails*) DoctorDetailsFromDictionary:(NSDictionary*)DoctorDetailsd{
    if (!DoctorDetailsd) {
		return Nil;
	}
	
	DoctorDetails *app = [[[DoctorDetails alloc] init] autorelease];
    app.Dob = [DoctorDetailsd objectForKey:@"Dob"];
    app.AddressId = [DoctorDetailsd objectForKey:@"AddressId"];
    app.ContactId = [DoctorDetailsd objectForKey:@"ContactId"];
    app.CurrentStatusId = [DoctorDetailsd objectForKey:@"CurrentStatusId"];
    app.Uname = [DoctorDetailsd objectForKey:@"Uname"];
    app.GenderId = [DoctorDetailsd objectForKey:@"GenderId"];
    app.UserId = [DoctorDetailsd objectForKey:@"UserId"];
	return app;
}

+(NSArray*) DoctorDetailsFromArray:(NSArray*)DoctorDetailsA{
    if (!DoctorDetailsA || [DoctorDetailsA isKindOfClass:[NSNull class]]) {
		return Nil;
	}
	
	NSMutableArray *appointments = [[[NSMutableArray alloc] init] autorelease];
    for (int i = 0; i < DoctorDetailsA.count; i++) {
        DoctorDetails *sch = [DoctorDetails DoctorDetailsFromDictionary:[DoctorDetailsA objectAtIndex:i]];
        if (sch) {
            [appointments addObject:sch];
        }
    }
    
	return appointments;
}

@end
