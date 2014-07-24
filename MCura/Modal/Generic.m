//
//  Generic.m
//  3GMDoc
//
//  Created by sandeep agrawal on 18/01/12.
//  Copyright (c) 2012 student.san1986@gmail.com. All rights reserved.
//

#import "Generic.h"

@implementation Generic

@synthesize Generic,GenericId;

-(void)dealloc 
{
    self.Generic = nil;
    self.GenericId = nil;
    
	[super dealloc];
}

@end
