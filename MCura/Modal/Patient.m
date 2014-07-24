//
//  Patient.m
//  3GMDoc

#import "Patient.h"

@implementation Patient

@synthesize AddressId, ContactId, Patname, dob, GenderId, PatDemoid, EntryTypeId, MRNO, PatientAddress, PatientContactDetails, RecNatureId, imagepath, patmedrecords, recimages, sub_tenant_id;


-(void)dealloc 
{
    self.AddressId = nil;
    self.ContactId = nil;
    self.Patname = nil;
    self.dob = nil;
    self.GenderId = nil;
    self.PatDemoid = nil;
    self.EntryTypeId = nil;
    self.MRNO = nil;
    self.PatientAddress = nil;
    self.PatientContactDetails = nil;
    self.RecNatureId = nil;
    self.imagepath = nil;
    self.patmedrecords = nil;
    self.recimages = nil;
    self.sub_tenant_id = nil;
	[super dealloc];
}


@end