//
//  MedRecNature+Parse.m
//  mCura
//
//  Created by Aakash Chaudhary on 27/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MedRecNature+Parse.h"

@implementation MedRecNature (Parse)

+(MedRecNature*) MedRecNatureFromDictionary:(NSDictionary*)MedRecNatured{
    if (!MedRecNatured) {
		return Nil;
	}
	
	MedRecNature *app = [[[MedRecNature alloc] init] autorelease];
    app.RecNatureId = [MedRecNatured objectForKey:@"RecNatureId"];
    app.RecNatureProperty = [MedRecNatured objectForKey:@"RecNatureProperty"];
    
	return app;
}

+(NSArray*) MedRecNatureFromArray:(NSArray*) MedRecNatureA{
    if (!MedRecNatureA || [MedRecNatureA isKindOfClass:[NSNull class]]) {
		return Nil;
	}
	
	NSMutableArray *appointments = [[[NSMutableArray alloc] init] autorelease];
    for (int i = 0; i < MedRecNatureA.count; i++) {
        MedRecNature *sch = [MedRecNature MedRecNatureFromDictionary:[MedRecNatureA objectAtIndex:i]];
        if (sch) {
            [appointments addObject:sch];
        }
    }
    
	
	return appointments;
}

@end
