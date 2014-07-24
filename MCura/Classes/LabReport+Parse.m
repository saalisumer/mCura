//
//  LabReport+Parse.m
//  mCura
//
//  Created by Aakash Chaudhary on 05/03/12.
//  Copyright (c) 2012 aakash272@gmail.com. All rights reserved.
//

#import "LabReport+Parse.h"

@implementation LabReport (Parse)

+(LabReport*) LabReportFromDictionary:(NSDictionary*)LabReportD{
    if (!LabReportD) {
        return Nil;
    }
    LabReport *app = [[[LabReport alloc] init] autorelease];
    
    app.ImagePathId = [LabReportD objectForKey:@"ImagePathId"];
    app.imagePath = [LabReportD objectForKey:@"imagepath"];
    return app;

}

+(NSArray*) LabReportFromArray:(NSArray*) LabReportA{
    if (!LabReportA || [LabReportA isKindOfClass:[NSNull class]]) {
		return Nil;
	}
	
	NSMutableArray *appointments = [[[NSMutableArray alloc] init] autorelease];
    for (int i = 0; i < LabReportA.count; i++) {
        LabReport *sch = [LabReport LabReportFromDictionary:[LabReportA objectAtIndex:i]];
        if (sch) {
            [appointments addObject:sch];
        }
    }    
	
	return appointments;
}

@end
