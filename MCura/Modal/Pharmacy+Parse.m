//
//  Pharmacy+Parse.m
//  3GMDoc
//
//  Created by sandeep agrawal on 18/01/12.
//  Copyright (c) 2012 student.san1986@gmail.com. All rights reserved.
//

#import "Pharmacy+Parse.h"
#import "JSON.h"

@implementation Pharmacy (Parse)

+(Pharmacy*) PharmacysFromDictionary:(NSDictionary*)Pharmacysd{
	if (!Pharmacysd) {
		return Nil;
	}
	
	Pharmacy *app = [[[Pharmacy alloc] init] autorelease];
    
    app.SubTenantId = [Pharmacysd objectForKey:@"SubTenantId"];
    app.SubTenantName = [Pharmacysd objectForKey:@"SubTenantName"];
    
	return app;
    
}

+(NSArray*) PharmacysFromArray:(NSArray*) PharmacysA{
	if (!PharmacysA || [PharmacysA isKindOfClass:[NSNull class]]) {
		return Nil;
	}
	
	NSMutableArray *appointments = [[[NSMutableArray alloc] init] autorelease];
    for (int i = 0; i < PharmacysA.count; i++) {
        Pharmacy *sch = [Pharmacy PharmacysFromDictionary:[PharmacysA objectAtIndex:i]];
        if (sch) {
            [appointments addObject:sch];
        }
    }    
	
	return appointments;	
}


@end