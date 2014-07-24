//
//  LabPackage.m
//  3GMDoc
//
//  Created by Aakash Chaudhary on 15/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LabPackage.h"

@implementation LabPackage
@synthesize Cost,PackageId,Packagename,SubTenantId,TestInsId;

-(void)dealloc 
{
    self.Cost = nil;
    self.PackageId = nil;
    self.Packagename = nil;
    self.SubTenantId = nil;
    self.TestInsId = nil;
	[super dealloc];
}

@end
