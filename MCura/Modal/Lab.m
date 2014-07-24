//
//  Lab.m
//  3GMDoc
//
//  Created by Aakash Chaudhary on 07/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Lab.h"

@implementation Lab
@synthesize SubTenantId,SubTenantName,PriorityIndex;

-(void)dealloc 
{
    self.SubTenantId = nil;
    self.SubTenantName = nil;
	[super dealloc];
}

@end
