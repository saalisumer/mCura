//
//  PatMedRecords.m
//  3GMDoc
//
//  Created by Aakash Chaudhary on 05/02/12.
//  Copyright (c) 2012 aakash272@gmail.com. All rights reserved.
//

#import "PatMedRecords.h"

@implementation PatMedRecords
@synthesize Date,EntryTypeId,Mrno,RecordId,RecNatureId,UserRoleId,ImagePath;

-(void)dealloc 
{
    self.Date = nil;
    self.EntryTypeId = nil;
    self.Mrno = nil;
    self.UserRoleId = nil;
    self.RecordId = nil;
    self.RecNatureId = nil;
    self.ImagePath = nil;
	[super dealloc];
}

@end
