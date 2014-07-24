//
//  MedRecNature.m
//  mCura
//
//  Created by Aakash Chaudhary on 27/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MedRecNature.h"

@implementation MedRecNature
@synthesize RecNatureId,RecNatureProperty;

-(void)dealloc 
{
    self.RecNatureId = nil;
    self.RecNatureProperty = nil;
	[super dealloc];
}

@end
