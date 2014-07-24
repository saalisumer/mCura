//
//  Severity+Parse.m
//  3GMDoc
//
//  Created by Aakash Chaudhary on 07/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Severity+Parse.h"
#import "JSON.h"

@implementation Severity (Parse)

+(Severity*) SeverityFromDictionary:(NSDictionary*)Severityd{
	if (!Severityd) {
		return Nil;
	}
	
	Severity *app = [[[Severity alloc] init] autorelease];
    
    app.SeverityId = [Severityd objectForKey:@"SeverityId"];
    app.SeverityProperty = [Severityd objectForKey:@"SeverityProperty"];
    
	return app;
    
}

+(NSArray*) SeverityFromArray:(NSArray*) SeverityA{
	if (!SeverityA || [SeverityA isKindOfClass:[NSNull class]]) {
		return Nil;
	}
	
	NSMutableArray *appointments = [[[NSMutableArray alloc] init] autorelease];
    for (int i = 0; i < SeverityA.count; i++) {
        Severity *sch = [Severity SeverityFromDictionary:[SeverityA objectAtIndex:i]];
        if (sch) {
            [appointments addObject:sch];
        }
    }
    
	
	return appointments;	
}

@end
