//
//  FollowUp.m
//  3GMDoc
//
//  Created by sandeep agrawal on 18/01/12.
//  Copyright (c) 2012 student.san1986@gmail.com. All rights reserved.
//

#import "FollowUp.h"

@implementation FollowUp

@synthesize Durationno, Durationunits, FollowupId;

-(void)dealloc 
{
    self.Durationno = nil;
    self.Durationunits = nil;
    self.FollowupId = nil;
	[super dealloc];
}

@end
