//
//  Instruction.m
//  3GMDoc
//
//  Created by sandeep agrawal on 18/01/12.
//  Copyright (c) 2012 student.san1986@gmail.com. All rights reserved.
//

#import "Instruction.h"

@implementation Instruction

@synthesize DosageInsId,Instruction;

-(void)dealloc 
{
    self.DosageInsId = nil;
    self.Instruction = nil;
    
	[super dealloc];
}

@end
