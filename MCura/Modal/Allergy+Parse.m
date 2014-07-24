//
//  Allergy+Parse.m
//  3GMDoc
//
//  Created by sandeep agrawal on 17/01/12.
//  Copyright (c) 2012 student.san1986@gmail.com. All rights reserved.
//

#import "Allergy+Parse.h"
#import "JSON.h"

@implementation Allergy (Parse)

+(Allergy*) AllergysFromDictionary:(NSDictionary*)Allergysd{
	if (!Allergysd) {
		return Nil;
	}
	Allergy *app = [[[Allergy alloc] init] autorelease];
    app.AllergyTypeId = [Allergysd objectForKey:@"AllergyTypeId"];
    app.AllergyTypeProperty = [Allergysd objectForKey:@"AllergyTypeProperty"];
	return app;
}

+(NSArray*) AllergysFromArray:(NSArray*) AllergysA{
	if (!AllergysA || [AllergysA isKindOfClass:[NSNull class]]) {
		return Nil;
	}
	NSMutableArray *appointments = [[[NSMutableArray alloc] init] autorelease];
    for (int i = 0; i < AllergysA.count; i++) {
        Allergy *sch = [Allergy AllergysFromDictionary:[AllergysA objectAtIndex:i]];
        if (sch) {
            [appointments addObject:sch];
        }
    }    
	return appointments;	
}

+(Allergy*) AllergyTypesFromDictionary:(NSDictionary*)Allergysd{
	if (!Allergysd) {
		return Nil;
	}
	Allergy *app = [[[Allergy alloc] init] autorelease];
    app.AllergyId = [Allergysd objectForKey:@"AllergyId"];
    app.AllergyTypeId = [Allergysd objectForKey:@"AllergyTypeId"];
    app.AllergyName = [Allergysd objectForKey:@"AllergyName"];
	return app;
}

+(NSArray*) AllergyTypesFromArray:(NSArray*) AllergysA{
	if (!AllergysA || [AllergysA isKindOfClass:[NSNull class]]) {
		return Nil;
	}
	NSMutableArray *appointments = [[[NSMutableArray alloc] init] autorelease];
    for (int i = 0; i < AllergysA.count; i++) {
        Allergy *sch = [Allergy AllergyTypesFromDictionary:[AllergysA objectAtIndex:i]];
        if (sch) {
            [appointments addObject:sch];
        }
    }    
	return appointments;	
}

@end
