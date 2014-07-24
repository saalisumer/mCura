//
//  PatAllergy.m
//  mCura
//
//  Created by Aakash Chaudhary on 02/04/12.
//  Copyright (c) 2012 aakash272@gmail.com. All rights reserved.
//

#import "PatAllergy.h"

@implementation PatAllergy

@synthesize AllergyTypeId,AllergyTypeProperty,AllergyId,AllergyName,Existsfrom,CurrentStatusId,Mrno;

-(void)dealloc 
{
    self.AllergyTypeId = nil;
    self.AllergyTypeProperty = nil;
    self.AllergyId = nil;
    self.AllergyName = nil;
    self.Existsfrom = nil;
    self.CurrentStatusId = nil;
    self.Mrno = nil;
	[super dealloc];
}

@end
