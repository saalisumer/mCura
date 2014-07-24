//
//  LabTestList.m
//  3GMDoc
//
//  Created by Aakash Chaudhary on 15/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LabTestList.h"

@implementation LabTestList
@synthesize Cost,TestId,Testname,SubTenantId,TestInsId;

-(void)dealloc 
{
    self.Cost = nil;
    self.TestId = nil;
    self.Testname = nil;
    self.SubTenantId = nil;
    self.TestInsId = nil;
	[super dealloc];
}

@end
