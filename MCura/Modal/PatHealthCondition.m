//
//  PatHealthCondition.m
//  mCura
//
//  Created by Aakash Chaudhary on 24/04/12.
//  Copyright (c) 2012 aakash272@gmail.com. All rights reserved.
//

#import "PatHealthCondition.h"

@implementation PatHealthCondition
@synthesize HConId,HCondition;

-(void)dealloc 
{
    self.HConId = nil;
    self.HCondition = nil;
	[super dealloc];
}

@end