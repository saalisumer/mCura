//
//  PatHealthConType.m
//  mCura
//
//  Created by Aakash Chaudhary on 24/04/12.
//  Copyright (c) 2012 aakash272@gmail.com. All rights reserved.
//

#import "PatHealthConType.h"

@implementation PatHealthConType
@synthesize HConTypeId,HConTypeProperty;

-(void)dealloc 
{
    self.HConTypeId = nil;
    self.HConTypeProperty = nil;
	[super dealloc];
}

@end
