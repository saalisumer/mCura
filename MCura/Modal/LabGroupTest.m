//
//  LabGroupTest.m
//  3GMDoc
//
//  Created by Aakash Chaudhary on 15/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LabGroupTest.h"

@implementation LabGroupTest
@synthesize Cost,LabGrpId,LabGrpName,SubTenantId,TestInsId,arrayOfTests;

-(void)dealloc 
{
    self.Cost = nil;
    self.LabGrpId = nil;
    self.LabGrpName = nil;
    self.SubTenantId = nil;
    self.TestInsId = nil;
    self.arrayOfTests = nil;
	[super dealloc];
}

@end
