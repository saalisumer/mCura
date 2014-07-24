//
//  Response.m
//  3GMDoc

#import "Response.h"

@implementation Response

@synthesize loginID, userRoleID, loginName, pwd, pin, currentStatusID;

-(void)dealloc 
{
    self.loginID = nil;
    self.userRoleID = nil;
    self.loginName = nil;
    self.pwd = nil;
    self.pin = nil;
    self.currentStatusID = nil;
	[super dealloc];
}

@end
