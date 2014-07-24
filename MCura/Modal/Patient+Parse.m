//
//  Patient+Parse.m
//  3GMDoc

#import "Patient+Parse.h"
#import "Patient.h"
#import "JSON.h"
#import "PatientAddress.h"
#import "PatientAddress+Parse.h"
#import "PatientContactDetails.h"
#import "PatientContactDetails+Parse.h"

@implementation Patient (Parse)

+(Patient*) PatientsFromDictionary:(NSDictionary*)Patientsd{
	if (!Patientsd) {
		return Nil;
	}
    
	Patient *app = [[[Patient alloc] init] autorelease];
    
    app.AddressId = [Patientsd objectForKey:@"AddressId"];
    app.ContactId = [Patientsd objectForKey:@"ContactId"];
    app.dob = [Patientsd objectForKey:@"Dob"];
    app.GenderId = [Patientsd objectForKey:@"GenderId"];
    app.PatDemoid = [Patientsd objectForKey:@"PatDemoid"];
    app.Patname = [Patientsd objectForKey:@"Patname"];
    app.EntryTypeId = [Patientsd objectForKey:@"EntryTypeId"];
    app.MRNO = [Patientsd objectForKey:@"MRNO"];
    app.RecNatureId = [Patientsd objectForKey:@"RecNatureId"];
    app.imagepath = [Patientsd objectForKey:@"imagepath"];
    app.patmedrecords = [Patientsd objectForKey:@"patmedrecords"];
    app.recimages = [Patientsd objectForKey:@"recimages"];
    app.sub_tenant_id = [Patientsd objectForKey:@"sub_tenant_id"];
    app.PatientAddress = [PatientAddress PatientAddressFromArray:[Patientsd objectForKey:@"PatientAddress"]];
    app.PatientContactDetails = [PatientContactDetails PatientContactDetailsFromArray:[Patientsd objectForKey:@"PatientContactDetails"]];
    
	return app;
    
}

+(NSArray*) PatientsFromArray:(NSArray*) PatientsA{
	if (!PatientsA) {
		return Nil;
	}
	
	NSMutableArray *appointments = [[[NSMutableArray alloc] init] autorelease];
	for (int i = 0; i < PatientsA.count; i++) {
        Patient *app = [Patient PatientsFromDictionary:[PatientsA objectAtIndex:i]];
        if (app) {
            [appointments addObject:app];
        }
    }
	
	return appointments;	
}


@end

