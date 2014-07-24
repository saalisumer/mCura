//
//  GraphObject.m
//  mCura
//
//  Created by Aakash Chaudhary on 31/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GraphObject.h"

@implementation GraphObject
@synthesize fromDate,toDate,count;

-(void)dealloc 
{
    self.fromDate = nil;
    self.toDate = nil;
    self.count = nil;
	[super dealloc];
}

@end
