//
//  Lab+Parse.m
//  3GMDoc
//
//  Created by Aakash Chaudhary on 07/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Lab+Parse.h"
#import "JSON.h"

@implementation Lab (Parse)

+(Lab*) LabsFromDictionary:(NSDictionary*)Labsd{
	if (!Labsd) {
		return Nil;
	}
	
	Lab *app = [[[Lab alloc] init] autorelease];
    app.SubTenantId = [Labsd objectForKey:@"SubTenantId"];
    app.SubTenantName = [Labsd objectForKey:@"SubTenantName"];
    
	return app;
}

+(NSArray*) LabsFromArray:(NSArray*) LabsA{
	if (!LabsA || [LabsA isKindOfClass:[NSNull class]]) {
		return Nil;
	}
	
	NSMutableArray *appointments = [[[NSMutableArray alloc] init] autorelease];
    for (int i = 0; i < LabsA.count; i++) {
        Lab *sch = [Lab LabsFromDictionary:[LabsA objectAtIndex:i]];
        if (sch) {
            [appointments addObject:sch];
        }
    }    
	
	return appointments;	
}

@end
