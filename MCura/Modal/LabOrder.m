//
//  LabOrder.m
//  3GMDoc
//
//  Created by Aakash Chaudhary on 15/02/12.
//  Copyright (c) 2012 aakash272@gmail.com. All rights reserved.
//

#import "LabOrder.h"

@implementation LabOrder

@synthesize Testname,Packagename,imagePath;

-(void)dealloc 
{
    self.Testname = nil;
    self.Packagename = nil;
    self.imagePath = nil;
    
	[super dealloc];
}

@end
