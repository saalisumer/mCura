//
//  SubTenant.m
//  3GMDoc
//
//  Created by Aakash Chaudhary on 09/02/12.
//  Copyright (c) 2012 aakash272@gmail.com. All rights reserved.
//

#import "SubTenant.h"

@implementation SubTenant
@synthesize SubTenantName,SubTenantId,PriorityIndex,SubTenantIdInteger;

-(void)dealloc 
{
    self.SubTenantId = nil;
    self.SubTenantName = nil;
	[super dealloc];
}

@end
