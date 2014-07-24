//
//  PatVital+Parse.m
//  mCura
//
//  Created by Aakash Chaudhary on 02/04/12.
//  Copyright (c) 2012 aakash272@gmail.com. All rights reserved.
//

#import "PatVital+Parse.h"
#import "JSON.h"

@implementation PatVital (Parse)

+(PatVital*) PatVitalsFromDictionary:(NSDictionary*)PatVitalsd{
	if (!PatVitalsd) {
		return Nil;
	}
	
	PatVital *app = [[[PatVital alloc] init] autorelease];
    
    app.Date_ = [PatVitalsd objectForKey:@"Date"];
    app.Units = [PatVitalsd objectForKey:@"Units"];
    app.VitalName = [PatVitalsd objectForKey:@"VitalName"];
    app.VitalNatureId = [PatVitalsd objectForKey:@"VitalNatureId"];
    app.PatReadingsId = [PatVitalsd objectForKey:@"PatReadingsId"];
    app.PatVitalId = [PatVitalsd objectForKey:@"PatVitalId"];
    app.Mrno = [PatVitalsd objectForKey:@"Mrno"];
    app.Reading = [PatVitalsd objectForKey:@"Readings"];
	return app;
    
}

+(NSArray*) PatVitalsFromArray:(NSArray*) PatVitalsA{
	if (!PatVitalsA || [PatVitalsA isKindOfClass:[NSNull class]]) {
		return Nil;
	}
	
	NSMutableArray *appointments = [[[NSMutableArray alloc] init] autorelease];
    for (int i = 0; i < PatVitalsA.count; i++) {
        PatVital *sch = [PatVital PatVitalsFromDictionary:[PatVitalsA objectAtIndex:i]];
        if (sch) {
            [appointments addObject:sch];
        }
    }    
	
	return appointments;	
}


@end
