//
//  PatAllergy+Parse.m
//  mCura
//
//  Created by Aakash Chaudhary on 02/04/12.
//  Copyright (c) 2012 aakash272@gmail.com. All rights reserved.
//

#import "PatAllergy+Parse.h"
#import "JSON.h"

@implementation PatAllergy (Parse)

+(PatAllergy*) PatAllergysFromDictionary:(NSDictionary*)PatAllergysd{
	if (!PatAllergysd) {
		return Nil;
	}
	
	PatAllergy *app = [[[PatAllergy alloc] init] autorelease];
    
    app.AllergyTypeId = [(NSDictionary*)[PatAllergysd objectForKey:@"allergytype"] objectForKey:@"AllergyTypeId"];
    app.AllergyTypeProperty = [(NSDictionary*)[PatAllergysd objectForKey:@"allergytype"] objectForKey:@"AllergyTypeProperty"];
    app.AllergyId = [PatAllergysd objectForKey:@"AllergyId"];
    app.CurrentStatusId = [PatAllergysd objectForKey:@"CurrentStatusId"];
    app.Existsfrom = [PatAllergysd objectForKey:@"Existsfrom"];
    app.Mrno = [PatAllergysd objectForKey:@"Mrno"];
    app.AllergyName = [(NSDictionary*)[PatAllergysd objectForKey:@"Allergy"] objectForKey:@"AllergyName"];
    
	return app;
    
}

+(NSArray*) PatAllergysFromArray:(NSDictionary*) PatAllergysA{
	if (!PatAllergysA || [PatAllergysA isKindOfClass:[NSNull class]]) {
		return Nil;
	}
    NSArray *abc = [PatAllergysA objectForKey:@"v_patallergy"];
	NSMutableArray *appointments = [[[NSMutableArray alloc] init] autorelease];
    for (int i = 0; i < abc.count; i++) {
        PatAllergy *sch = [PatAllergy PatAllergysFromDictionary:[abc objectAtIndex:i]];
        if (sch) {
            [appointments addObject:sch];
        }
    }    
	
	return appointments;	
}


@end
