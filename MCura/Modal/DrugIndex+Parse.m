//
//  DrugIndex+Parse.m
//  mCura
//
//  Created by Aakash Chaudhary on 20/07/12.
//  Copyright (c) 2012 aakash272@gmail.com. All rights reserved.
//

#import "DrugIndex+Parse.h"

@implementation DrugIndex (Parse)

+(DrugIndex*) DrugIndicesFromDictionary:(NSDictionary*)DrugIndicesD{
	if (!DrugIndicesD) {
		return Nil;
	}
	DrugIndex *app = [[[DrugIndex alloc] init] autorelease];
    app.Crossreaction = [DrugIndicesD objectForKey:@"Crossreaction"];
    app.DrugBrands = [DrugIndicesD objectForKey:@"DrugBrands"];//array check
    app.Modeofaction = [DrugIndicesD objectForKey:@"Modeofaction"];
    app.Id = [DrugIndicesD objectForKey:@"Id"];
    app.Name = [DrugIndicesD objectForKey:@"Name"];
    app.Safety = [DrugIndicesD objectForKey:@"Safety"];//array check
    app.Sideeffect = [DrugIndicesD objectForKey:@"Sideeffect"];
	return app;
}

+(NSArray*) DrugIndicesFromArray:(NSArray*) DrugIndicesA{
	if (!DrugIndicesA || [DrugIndicesA isKindOfClass:[NSNull class]]) {
		return Nil;
	}
	NSMutableArray *appointments = [[[NSMutableArray alloc] init] autorelease];
    for (int i = 0; i < DrugIndicesA.count; i++) {
        DrugIndex *sch = [DrugIndex DrugIndicesFromDictionary:[DrugIndicesA objectAtIndex:i]];
        if (sch) {
            [appointments addObject:sch];
        }
    }    
	return appointments;	
}

@end
