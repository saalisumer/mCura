//
//  Generic+Parse.m
//  3GMDoc
//
//  Created by sandeep agrawal on 18/01/12.
//  Copyright (c) 2012 student.san1986@gmail.com. All rights reserved.
//

#import "Generic+Parse.h"
#import "JSON.h"

@implementation Generic (Parse)

+(Generic*) GenericsFromDictionary:(NSDictionary*)Genericsd{
	if (!Genericsd) {
		return Nil;
	}
	
	Generic *app = [[[Generic alloc] init] autorelease];
    
    app.Generic = [Genericsd objectForKey:@"Name"];
    app.GenericId = [Genericsd objectForKey:@"Id"];
    
	return app;
    
}

+(NSArray*) PGenericsFromArray:(NSArray*) GenericsA{
	if (!GenericsA || [GenericsA isKindOfClass:[NSNull class]]) {
		return Nil;
	}
	
	NSMutableArray *appointments = [[[NSMutableArray alloc] init] autorelease];
    for (int i = 0; i < GenericsA.count; i++) {
        Generic *sch = [Generic GenericsFromDictionary:[GenericsA objectAtIndex:i]];
        if (sch) {
            [appointments addObject:sch];
        }
    }    
	
	return appointments;	
}


@end
