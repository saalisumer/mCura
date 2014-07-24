//
//  LabReport.m
//  mCura
//
//  Created by Aakash Chaudhary on 05/03/12.
//  Copyright (c) 2012 aakash272@gmail.com. All rights reserved.
//

#import "LabReport.h"

@implementation LabReport

@synthesize ImagePathId,imagePath;

-(void)dealloc 
{
    self.ImagePathId = nil;
    self.imagePath = nil;
    
	[super dealloc];
}
@end
