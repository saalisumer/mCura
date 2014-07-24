//
//  PatHealth.m
//  mCura
//
//  Created by Aakash Chaudhary on 02/04/12.
//  Copyright (c) 2012 aakash272@gmail.com. All rights reserved.
//

#import "PatHealth.h"

@implementation PatHealth

@synthesize HConId, HConTypeId, Existsfrom, Mrno,HCondition,HConTypeProperty,EnteredOn;

-(void)dealloc 
{
    self.HConId = nil;
    self.HConTypeId = nil;
    self.Existsfrom = nil;
    self.Mrno = nil;
    self.EnteredOn = nil;
    self.HConTypeProperty = nil;
    self.HCondition = nil;
	[super dealloc];
}

@end