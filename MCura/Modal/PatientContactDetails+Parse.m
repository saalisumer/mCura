//
//  PatientContactDetails+Parse.m
//  3GMDoc

#import "PatientContactDetails+Parse.h"
#import "JSON.h"

@implementation PatientContactDetails (Parse)

+(PatientContactDetails*) PatientContactDetailsFromDictionary:(NSDictionary*)PatientContactDetailsd{
	if (!PatientContactDetailsd) {
		return Nil;
	}
	
	PatientContactDetails *app = [[[PatientContactDetails alloc] init] autorelease];
    
    app.ContactId = [PatientContactDetailsd objectForKey:@"ContactId"];
    app.Email = [PatientContactDetailsd objectForKey:@"Email"];
    app.FixLine = [PatientContactDetailsd objectForKey:@"FixLine"];
    app.FixLineExtn = [PatientContactDetailsd objectForKey:@"FixLineExtn"];
    app.Mobile = [PatientContactDetailsd objectForKey:@"Mobile"];
    app.Optemail = [PatientContactDetailsd objectForKey:@"Optemail"];
    app.Optmobile = [PatientContactDetailsd objectForKey:@"Optmobile"];
    app.Skypeid = [PatientContactDetailsd objectForKey:@"Skypeid"];
    
	return app;
    
}

+(NSArray*) PatientContactDetailsFromArray:(NSDictionary*) PatientContactDetailsA{
	if (!PatientContactDetailsA || [PatientContactDetailsA isKindOfClass:[NSNull class]]) {
		return Nil;
	}
	
	NSMutableArray *appointments = [[[NSMutableArray alloc] init] autorelease];
    PatientContactDetails *app = [PatientContactDetails PatientContactDetailsFromDictionary:PatientContactDetailsA];
    if (app) {
        [appointments addObject:app];
    }
    
	
	return appointments;	
}


@end
