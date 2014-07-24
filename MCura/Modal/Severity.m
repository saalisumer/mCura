//
//  Severity.m
//  3GMDoc
//
//  Created by Aakash Chaudhary on 07/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Severity.h"

@implementation Severity
@synthesize SeverityId,SeverityProperty;

-(void)dealloc 
{
    self.SeverityId = nil;
    self.SeverityProperty = nil;
	[super dealloc];
}

@end
