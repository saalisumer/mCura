//
//  DosageFrm+Parse.m
//  3GMDoc
//
//  Created by sandeep agrawal on 18/01/12.
//  Copyright (c) 2012 student.san1986@gmail.com. All rights reserved.
//

#import "DosageFrm+Parse.h"

@implementation DosageFrm (Parse)

+(DosageFrm*) DosageFrmsFromDictionary:(NSDictionary*)DosageFrmsd{
	if (!DosageFrmsd) {
		return Nil;
	}
	
	DosageFrm *app = [[[DosageFrm alloc] init] autorelease];
    
    app.DosageFormId = [DosageFrmsd objectForKey:@"DosageFormId"];
    app.DosageFormProperty = [DosageFrmsd objectForKey:@"DosageFormProperty"];
    
	return app;
    
}

+(NSArray*) DosageFrmsFromArray:(NSArray*) DosageFrmsA{
	if (!DosageFrmsA || [DosageFrmsA isKindOfClass:[NSNull class]]) {
		return Nil;
	}
	
	NSMutableArray *appointments = [[[NSMutableArray alloc] init] autorelease];
    for (int i = 0; i < DosageFrmsA.count; i++) {
        DosageFrm *sch = [DosageFrm DosageFrmsFromDictionary:[DosageFrmsA objectAtIndex:i]];
        if (sch) {
            [appointments addObject:sch];
        }
    }    
	
	return appointments;	
}


@end
