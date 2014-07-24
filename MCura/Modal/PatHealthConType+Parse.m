//
//  PatHealthConType+Parse.m
//  mCura
//
//  Created by Aakash Chaudhary on 24/04/12.
//  Copyright (c) 2012 aakash272@gmail.com. All rights reserved.
//

#import "PatHealthConType+Parse.h"

@implementation PatHealthConType (Parse)

+(PatHealthConType*) PatHealthConTypesFromDictionary:(NSDictionary*)PatHealthsd{
	if (!PatHealthsd) {
		return Nil;
	}
	
	PatHealthConType *app = [[[PatHealthConType alloc] init] autorelease];
    
    app.HConTypeId = [PatHealthsd objectForKey:@"HConTypeId"];
    app.HConTypeProperty = [PatHealthsd objectForKey:@"HConTypeProperty"];
	return app;
    
}

+(NSArray*) PatHealthsFromArray:(NSArray*) PatHealthsA{
	if (!PatHealthsA || [PatHealthsA isKindOfClass:[NSNull class]]) {
		return Nil;
	}
	NSMutableArray *appointments = [[[NSMutableArray alloc] init] autorelease];
    for (int i = 0; i < PatHealthsA.count; i++) {
        PatHealthConType *sch = [PatHealthConType PatHealthConTypesFromDictionary:[PatHealthsA objectAtIndex:i]];
        if (sch) {
            [appointments addObject:sch];
        }
    }    
	
	return appointments;	
}

@end
