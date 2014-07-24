//
//  FollowUp+Parse.m
//  3GMDoc
//
//  Created by sandeep agrawal on 18/01/12.
//  Copyright (c) 2012 student.san1986@gmail.com. All rights reserved.
//

#import "FollowUp+Parse.h"

@implementation FollowUp (Parse)

+(FollowUp*) FollowUpsFromDictionary:(NSDictionary*)FollowUpsd{
	if (!FollowUpsd) {
		return Nil;
	}
	
	FollowUp *app = [[[FollowUp alloc] init] autorelease];
    
    app.Durationno = [FollowUpsd objectForKey:@"Durationno"];
    app.Durationunits = [FollowUpsd objectForKey:@"Durationunits"];
    app.FollowupId = [FollowUpsd objectForKey:@"FollowupId"];
    
	return app;
    
}

+(NSArray*) FollowUpsFromArray:(NSArray*) FollowUpsA{
	if (!FollowUpsA || [FollowUpsA isKindOfClass:[NSNull class]]) {
		return Nil;
	}
	
	NSMutableArray *appointments = [[[NSMutableArray alloc] init] autorelease];
    for (int i = 0; i < FollowUpsA.count; i++) {
        FollowUp *sch = [FollowUp FollowUpsFromDictionary:[FollowUpsA objectAtIndex:i]];
        if (sch) {
            [appointments addObject:sch];
        }
    }    
	
	return appointments;	
}


@end
