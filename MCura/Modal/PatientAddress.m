//
//  PatientAddress.m
//  3GMDoc

#import "PatientAddress.h"

@implementation PatientAddress

@synthesize Address1, Address2, AddressId, AreaId, Zipcode;

-(void)dealloc 
{
    self.Address1 = nil;
    self.Address2 = nil;
    self.AddressId = nil;
    self.AreaId = nil;
    self.Zipcode = nil;
    
	[super dealloc];
}

@end