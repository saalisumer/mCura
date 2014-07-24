//
//  DoctorDetails.m
//  mCura
//
//  Created by Aakash Chaudhary on 16/04/12.
//  Copyright (c) 2012 aakash272@gmail.com. All rights reserved.
//

#import "DoctorDetails.h"

@implementation DoctorDetails
@synthesize Dob,AddressId,ContactId,CurrentStatusId,Uname,GenderId,UserId;

-(void)dealloc 
{
    self.Dob = nil;
    self.AddressId = nil;
    self.ContactId = nil;
    self.Uname = nil;
    self.GenderId = nil;
    self.CurrentStatusId = nil;
    self.UserId = nil;
	[super dealloc];
}

@end
