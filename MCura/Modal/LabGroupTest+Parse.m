//
//  LabGroupTest+Parse.m
//  3GMDoc
//
//  Created by Aakash Chaudhary on 15/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LabGroupTest+Parse.h"

@implementation LabGroupTest (Parse)

+(LabGroupTest*) LabGroupTestFromDictionary:(NSDictionary*)LabGroupTestD{
    if (!LabGroupTestD) {
		return Nil;
	}
	LabGroupTest *app = [[[LabGroupTest alloc] init] autorelease];
    
    app.Cost = [LabGroupTestD objectForKey:@"Cost"];
    app.LabGrpId = [LabGroupTestD objectForKey:@"LabGrpId"];
    app.LabGrpName = [LabGroupTestD objectForKey:@"LabGrpName"];
    app.SubTenantId = [LabGroupTestD objectForKey:@"SubTenantId"];
    app.TestInsId = [LabGroupTestD objectForKey:@"TestInsId"];
    
	return app;
}

+(NSArray*) LabGroupTestFromArray:(NSArray*) LabGroupTestA{
    if (!LabGroupTestA || [LabGroupTestA isKindOfClass:[NSNull class]]) {
		return Nil;
	}
	
	NSMutableArray *appointments = [[[NSMutableArray alloc] init] autorelease];
    for (int i = 0; i < LabGroupTestA.count; i++) {
        LabGroupTest *sch = [LabGroupTest LabGroupTestFromDictionary:[LabGroupTestA objectAtIndex:i]];
        if (sch) {
            [appointments addObject:sch];
        }
    }    
	
	return appointments;
}

@end
