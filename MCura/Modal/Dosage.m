//
//  Dosage.m
//  3GMDoc
//
//  Created by sandeep agrawal on 17/01/12.
//  Copyright (c) 2012 student.san1986@gmail.com. All rights reserved.
//

#import "Dosage.h"

@implementation Dosage

@synthesize DosageId,DosageProperty;

-(void)dealloc 
{
    self.DosageId = nil;
    self.DosageProperty = nil;
    
	[super dealloc];
}

@end
