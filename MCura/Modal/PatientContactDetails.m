//
//  PatientContactDetails.m
//  3GMDoc

#import "PatientContactDetails.h"

@implementation PatientContactDetails

@synthesize ContactId,Email,FixLine,FixLineExtn,Mobile,Optemail,Optmobile,Skypeid;

-(void)dealloc 
{
    self.ContactId = nil;
    self.Email = nil;
    self.FixLine = nil;
    self.FixLineExtn = nil;
    self.Mobile = nil;
    self.Optemail = nil;
    self.Optmobile = nil;
    self.Skypeid = nil;
	[super dealloc];
}

@end


