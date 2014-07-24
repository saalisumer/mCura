//
//  PharmacyOrder+Parse.m
//  3GMDoc
//
//  Created by Aakash Chaudhary on 15/02/12.
//  Copyright (c) 2012 aakash272@gmail.com. All rights reserved.
//

#import "PharmacyOrder+Parse.h"

@implementation PharmacyOrder (Parse)

+(PharmacyOrder*) PharmacyOrderFromDictionary:(NSDictionary*)PharmacyOrderD{
    if (!PharmacyOrderD) {
        return Nil;
    }
    PharmacyOrder *app = [[[PharmacyOrder alloc] init] autorelease];

    app.Generic = [PharmacyOrderD objectForKey:@"Generic"];
    app.brand_id = [PharmacyOrderD objectForKey:@"brand_id"];
    app.brand_name = [PharmacyOrderD objectForKey:@"brand_name"];
    app.dosage = [PharmacyOrderD objectForKey:@"dosage"];
    app.dosage_form = [PharmacyOrderD objectForKey:@"dosage_form"];
    app.dosage_form_id = [PharmacyOrderD objectForKey:@"dosage_form_id"];
    app.dosage_id = [PharmacyOrderD objectForKey:@"dosage_id"];
    app.dosage_ins_id = [PharmacyOrderD objectForKey:@"dosage_ins_id"];
    app.durationno = [PharmacyOrderD objectForKey:@"durationno"];
    app.durationunits = [PharmacyOrderD objectForKey:@"durationunits"];
    app.followup_id = [PharmacyOrderD objectForKey:@"followup_id"];
    app.instruction = [PharmacyOrderD objectForKey:@"instruction"];
    app.med_id = [PharmacyOrderD objectForKey:@"med_id"];
    app.prescription_id = [PharmacyOrderD objectForKey:@"prescription_id"];
    
    return app;
}

+(NSArray*) PharmacyOrderFromArray:(NSArray*) PharmacyOrderA{
    if (!PharmacyOrderA || [PharmacyOrderA isKindOfClass:[NSNull class]]) {
		return Nil;
	}
	
	NSMutableArray *appointments = [[[NSMutableArray alloc] init] autorelease];
    for (int i = 0; i < PharmacyOrderA.count; i++) {
        PharmacyOrder *sch = [PharmacyOrder PharmacyOrderFromDictionary:[PharmacyOrderA objectAtIndex:i]];
        if (sch) {
            [appointments addObject:sch];
        }
    }    
	
	return appointments;
}

+(PharmacyOrder*) PharmacyOrderTemplateFromDictionary:(NSDictionary*)PharmacyOrderD{
    if (!PharmacyOrderD) {
        return Nil;
    }
    
    PharmacyOrder *app = [[[PharmacyOrder alloc] init] autorelease];
    
    app.brand_id = [PharmacyOrderD objectForKey:@"BrandID"];
    app.dosage_form_id = [PharmacyOrderD objectForKey:@"DosageFormId"];
    app.dosage_id = [PharmacyOrderD objectForKey:@"DosageId"];
    app.dosage_ins_id = [PharmacyOrderD objectForKey:@"DosageInsId"];
    app.followup_id = [PharmacyOrderD objectForKey:@"Followupid"];
    app.Generic = [PharmacyOrderD objectForKey:@"GenericName"];
    app.generic_id = [PharmacyOrderD objectForKey:@"GenericsID"];
    app.brand_name = [PharmacyOrderD objectForKey:@"BrandName"];
    app.dosage_form = [PharmacyOrderD objectForKey:@"DosageFromName"];
    app.dosage = [PharmacyOrderD objectForKey:@"DosageName"];
    return app;
}

+(NSArray*) PharmacyOrderTemplateFromArray:(NSArray*) PharmacyOrderA{
    if (!PharmacyOrderA || [PharmacyOrderA isKindOfClass:[NSNull class]]) {
		return Nil;
	}
	
	NSMutableArray *appointments = [[[NSMutableArray alloc] init] autorelease];
    for (int i = 0; i < PharmacyOrderA.count; i++) {
        PharmacyOrder *sch = [PharmacyOrder PharmacyOrderTemplateFromDictionary:[PharmacyOrderA objectAtIndex:i]];
        if (sch) {
            [appointments addObject:sch];
        }
    }    
	
	return appointments;
}


@end
