//
//  Dosage+Parse.m
//  3GMDoc
//
//  Created by sandeep agrawal on 17/01/12.
//  Copyright (c) 2012 student.san1986@gmail.com. All rights reserved.
//

#import "Dosage+Parse.h"
#import "JSON.h"

@implementation Dosage (Parse)

+(Dosage*) DosagesFromDictionary:(NSDictionary*)Dosagesd{
	if (!Dosagesd) {
		return Nil;
	}
	
	Dosage *app = [[[Dosage alloc] init] autorelease];
    
    app.DosageId = [Dosagesd objectForKey:@"DosageId"];
    app.DosageProperty = [Dosagesd objectForKey:@"DosageProperty"];
    
	return app;
    
}

+(NSArray*) DosagesFromArray:(NSArray*) DosagesA{
	if (!DosagesA || [DosagesA isKindOfClass:[NSNull class]]) {
		return Nil;
	}
	
	NSMutableArray *appointments = [[[NSMutableArray alloc] init] autorelease];
    for (int i = 0; i < DosagesA.count; i++) {
        Dosage *sch = [Dosage DosagesFromDictionary:[DosagesA objectAtIndex:i]];
        if (sch) {
            [appointments addObject:sch];
        }
    }    
	
	return appointments;
}


@end

