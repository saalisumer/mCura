//
//  LabTestList+Parse.m
//  3GMDoc
//
//  Created by Aakash Chaudhary on 15/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LabTestList+Parse.h"

@implementation LabTestList (Parse)

+(LabTestList*) LabTestListFromDictionary:(NSDictionary*)LabTestListD{
    if (!LabTestListD) {
		return Nil;
	}
	LabTestList *app = [[[LabTestList alloc] init] autorelease];
    
    app.Cost = [LabTestListD objectForKey:@"Cost"];
    app.TestId = [LabTestListD objectForKey:@"TestId"];
    app.Testname = [LabTestListD objectForKey:@"Testname"];
    app.SubTenantId = [LabTestListD objectForKey:@"SubTenantId"];
    app.TestInsId = [LabTestListD objectForKey:@"TestInsId"];
    
	return app;
}

+(NSArray*) LabTestListFromArray:(NSArray*) LabTestListA{
    if (!LabTestListA || [LabTestListA isKindOfClass:[NSNull class]]) {
		return Nil;
	}
	
	NSMutableArray *appointments = [[[NSMutableArray alloc] init] autorelease];
    for (int i = 0; i < LabTestListA.count; i++) {
        LabTestList *sch = [LabTestList LabTestListFromDictionary:[LabTestListA objectAtIndex:i]];
        if (sch) {
            [appointments addObject:sch];
        }
    }    
	
	return appointments;
}

@end
