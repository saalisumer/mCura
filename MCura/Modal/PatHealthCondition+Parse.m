//
//  PatHealthCondition+Parse.m
//  mCura
//
//  Created by Aakash Chaudhary on 24/04/12.
//  Copyright (c) 2012 aakash272@gmail.com. All rights reserved.
//

#import "PatHealthCondition+Parse.h"

@implementation PatHealthCondition (Parse)

+(PatHealthCondition*) PatHealthConditionsFromDictionary:(NSDictionary*)PatHealthsd{
	if (!PatHealthsd) {
		return Nil;
	}
	
	PatHealthCondition *app = [[[PatHealthCondition alloc] init] autorelease];
    
    app.HConId = [PatHealthsd objectForKey:@"HConId"];
    app.HCondition = [PatHealthsd objectForKey:@"HCondition"];
	return app;
    
}

+(NSArray*) PatHealthsFromArray:(NSArray*) PatHealthsA{
	if (!PatHealthsA || [PatHealthsA isKindOfClass:[NSNull class]]) {
		return Nil;
	}
	NSMutableArray *appointments = [[[NSMutableArray alloc] init] autorelease];
    for (int i = 0; i < PatHealthsA.count; i++) {
        PatHealthCondition *sch = [PatHealthCondition PatHealthConditionsFromDictionary:[PatHealthsA objectAtIndex:i]];
        if (sch) {
            [appointments addObject:sch];
        }
    }    
	
	return appointments;	
}

@end
