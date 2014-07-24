//
//  PharmacyOrder.m
//  3GMDoc
//
//  Created by Aakash Chaudhary on 15/02/12.
//  Copyright (c) 2012 aakash272@gmail.com. All rights reserved.
//

#import "PharmacyOrder.h"

@implementation PharmacyOrder
@synthesize Generic, brand_id,brand_name,dosage,dosage_form,dosage_form_id,dosage_id,dosage_ins_id;
@synthesize durationno,durationunits,followup_id,instruction,med_id,prescription_id,generic_id,isTemplate;

-(void)dealloc 
{
    self.Generic = nil;
    self.generic_id = nil;
    self.brand_id = nil;
    self.brand_name = nil;
    self.dosage = nil;
    self.dosage_form = nil;
    self.dosage_form_id = nil;
    self.dosage_id = nil;
    self.dosage_ins_id = nil;
    self.durationno = nil;
    self.durationunits = nil;
    self.followup_id = nil;
    self.instruction = nil;
    self.med_id = nil;
    self.prescription_id = nil;
	[super dealloc];
}

@end
