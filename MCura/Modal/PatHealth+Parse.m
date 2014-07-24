//
//  PatHealth+Parse.m
//  mCura
//
//  Created by Aakash Chaudhary on 02/04/12.
//  Copyright (c) 2012 aakash272@gmail.com. All rights reserved.
//

#import "PatHealth+Parse.h"
#import "JSON.h"

@implementation PatHealth (Parse)

+(PatHealth*) PatHealthsFromDictionary:(NSDictionary*)PatHealthsd{
	if (!PatHealthsd) {
		return Nil;
	}
	
	PatHealth *app = [[[PatHealth alloc] init] autorelease];
    
    app.HConId = [PatHealthsd objectForKey:@"HConId"];
    app.HConTypeId = [PatHealthsd objectForKey:@"HConTypeId"];
    app.Existsfrom = [PatHealthsd objectForKey:@"Existsfrom"];
    app.Mrno = [PatHealthsd objectForKey:@"Mrno"];
    app.EnteredOn = [PatHealthsd objectForKey:@"EnteredOn"];
    app.HConTypeProperty = [(NSDictionary*)[PatHealthsd objectForKey:@"ConType"] objectForKey:@"HConTypeProperty"];
    app.HCondition = [(NSDictionary*)[PatHealthsd objectForKey:@"Conditions"] objectForKey:@"HCondition"];
	return app;
    
}

+(NSArray*) PatHealthsFromArray:(NSDictionary*) PatHealthsA{
	if (!PatHealthsA || [PatHealthsA isKindOfClass:[NSNull class]]) {
		return Nil;
	}
	NSArray *abc = [PatHealthsA objectForKey:@"v_HealthCondtion"];
	NSMutableArray *appointments = [[[NSMutableArray alloc] init] autorelease];
    for (int i = 0; i < abc.count; i++) {
        PatHealth *sch = [PatHealth PatHealthsFromDictionary:[abc objectAtIndex:i]];
        if (sch) {
            [appointments addObject:sch];
        }
    }    
	
	return appointments;	
}


@end