//
//  PatientAddress+Parse.m
//  3GMDoc

#import "PatientAddress+Parse.h"
#import "JSON.h"

@implementation PatientAddress (Parse)

+(PatientAddress*) PatientAddressFromDictionary:(NSDictionary*)PatientAddresssd{
	if (!PatientAddresssd) {
		return Nil;
	}
	
	PatientAddress *app = [[[PatientAddress alloc] init] autorelease];
    
    app.Address1 = [PatientAddresssd objectForKey:@"Address1"];
    app.Address2 = [PatientAddresssd objectForKey:@"Address2"];
    app.AddressId = [PatientAddresssd objectForKey:@"AddressId"];
    app.AreaId = [PatientAddresssd objectForKey:@"AreaId"];
    app.Zipcode = [PatientAddresssd objectForKey:@"Zipcode"];
    
	return app;
    
}

+(NSArray*) PatientAddressFromArray:(NSDictionary*) PatientAddressA{
	if (!PatientAddressA || [PatientAddressA isKindOfClass:[NSNull class]]) {
		return Nil;
	}
	
	NSMutableArray *appointments = [[[NSMutableArray alloc] init] autorelease];
    PatientAddress *app = [PatientAddress PatientAddressFromDictionary:PatientAddressA];
    if (app) {
        [appointments addObject:app];
    }
    
	
	return appointments;	
}


@end

