//
//  UserDetail.m
//  3GMDoc


#import "UserDetail.h"

@implementation UserDetail

@synthesize userId, genderId, u_name, dob, addressId, contactId, currentStatusId;


-(void)dealloc 
{
    self.userId = nil;
    self.genderId = nil;
    self.u_name = nil;
    self.dob = nil;
    self.addressId = nil;
    self.contactId = nil;
    self.currentStatusId = nil;
	[super dealloc];
}


@end


