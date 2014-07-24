//
//  LabPackage+Parse.m
//  3GMDoc
//
//  Created by Aakash Chaudhary on 15/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LabPackage+Parse.h"

@implementation LabPackage (Parse)

+(LabPackage*) LabPackagesFromDictionary:(NSDictionary*)LabPackagesD{
    if (!LabPackagesD) {
		return Nil;
	}
	LabPackage *app = [[[LabPackage alloc] init] autorelease];
    
    app.Cost = [LabPackagesD objectForKey:@"Cost"];
    app.PackageId = [LabPackagesD objectForKey:@"PackageId"];
    app.Packagename = [LabPackagesD objectForKey:@"Packagename"];
    app.SubTenantId = [LabPackagesD objectForKey:@"SubTenantId"];
    app.TestInsId = [LabPackagesD objectForKey:@"TestInsId"];
    
	return app;
}

+(NSArray*) LabPackagesFromArray:(NSArray*) LabPackagesA{
    if (!LabPackagesA || [LabPackagesA isKindOfClass:[NSNull class]]) {
		return Nil;
	}
	
	NSMutableArray *appointments = [[[NSMutableArray alloc] init] autorelease];
    for (int i = 0; i < LabPackagesA.count; i++) {
        LabPackage *sch = [LabPackage LabPackagesFromDictionary:[LabPackagesA objectAtIndex:i]];
        if (sch) {
            [appointments addObject:sch];
        }
    }    
	
	return appointments;
}

@end
