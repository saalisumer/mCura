//
//  Allergy.m
//  3GMDoc
//
//  Created by sandeep agrawal on 17/01/12.
//  Copyright (c) 2012 student.san1986@gmail.com. All rights reserved.
//

#import "Allergy.h"

@implementation Allergy

@synthesize AllergyTypeId,AllergyTypeProperty,AllergyId,AllergyName;

-(void)dealloc 
{
    self.AllergyTypeId = nil;
    self.AllergyTypeProperty = nil;
    self.AllergyId = nil;
    self.AllergyName = nil;
	[super dealloc];
}

@end
