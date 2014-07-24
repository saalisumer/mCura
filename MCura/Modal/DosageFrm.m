//
//  DosageFrm.m
//  3GMDoc
//
//  Created by sandeep agrawal on 18/01/12.
//  Copyright (c) 2012 student.san1986@gmail.com. All rights reserved.
//

#import "DosageFrm.h"

@implementation DosageFrm

@synthesize DosageFormId,DosageFormProperty;

-(void)dealloc 
{
    self.DosageFormId = nil;
    self.DosageFormProperty = nil;
    
	[super dealloc];
}

@end
