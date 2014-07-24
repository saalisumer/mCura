//
//  LabOrder+Parse.m
//  3GMDoc
//
//  Created by Aakash Chaudhary on 15/02/12.
//  Copyright (c) 2012 aakash272@gmail.com. All rights reserved.
//

#import "LabOrder+Parse.h"

@implementation LabOrder (Parse)

+(LabOrder*) LabOrderFromDictionary:(NSDictionary*)LabOrderD{
    if (!LabOrderD) {
		return Nil;
	}
	LabOrder *app = [[[LabOrder alloc] init] autorelease];
    
    if([(NSArray*)[LabOrderD objectForKey:@"LabPackageTest"] count]!=0)
        app.Packagename = [(NSDictionary*)[(NSArray*)[LabOrderD objectForKey:@"LabPackageTest"] objectAtIndex:0] objectForKey:@"Packagename"];
    else
        app.Packagename = @"Package name unavailable";
    if([(NSArray*)[LabOrderD objectForKey:@"LabTestList"] count]!=0)
        app.Testname = [(NSDictionary*)[(NSArray*)[LabOrderD objectForKey:@"LabTestList"] objectAtIndex:0] objectForKey:@"Testname"];
    else
        app.Testname = @"Test name unavailable";
    
    if(![(NSArray*)[LabOrderD objectForKey:@"file"] isKindOfClass:[NSNull class]])
        if([(NSArray*)[LabOrderD objectForKey:@"file"] count]!=0)
            app.imagePath = [(NSDictionary*)[(NSArray*)[LabOrderD objectForKey:@"file"] objectAtIndex:0] objectForKey:@"FilePath"];
    
	return app;
}

@end
