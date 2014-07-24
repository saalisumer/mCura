//
//  Pharmacy.m
//  3GMDoc
//
//  Created by sandeep agrawal on 18/01/12.
//  Copyright (c) 2012 student.san1986@gmail.com. All rights reserved.
//

#import "Pharmacy.h"

@implementation Pharmacy

@synthesize SubTenantId,SubTenantName,PriorityIndex;

-(void)dealloc 
{
    self.SubTenantId = nil;
    self.SubTenantName = nil;
	[super dealloc];
}

@end
