//
//  Patdemographics+Parse.m
//  3GMDoc

#import "Patdemographics+Parse.h"
#import "JSON.h"
#import "Patdemographics.h"

@implementation Patdemographics (Parse)

+(Patdemographics*) PatdemographicsFromDictionary:(NSDictionary*)Patdemographicsd{
	if (!Patdemographicsd) {
		return Nil;
	}
	
	Patdemographics *app = [[[Patdemographics alloc] init] autorelease];
    
    app.genderID = [Patdemographicsd objectForKey:@"GenderId"];
    app.patDOB = [Patdemographicsd objectForKey:@"Dob"];
    app.patName = [Patdemographicsd objectForKey:@"Patname"];
    app.addressID = [Patdemographicsd objectForKey:@"AddressId"];
    app.contactID = [Patdemographicsd objectForKey:@"ContactId"];
    app.patDemoID = [Patdemographicsd objectForKey:@"PatDemoid"];
    
	return app;
    
}

+(NSArray*) PatdemographicsFromArray:(NSDictionary*) PatdemographicsA{
	if (!PatdemographicsA || [PatdemographicsA isKindOfClass:[NSNull class]]) {
		return Nil;
	}
	
	NSMutableArray *appointments = [[[NSMutableArray alloc] init] autorelease];
    Patdemographics *app = [Patdemographics PatdemographicsFromDictionary:PatdemographicsA];
    if (app) {
        [appointments addObject:app];
    }

	return appointments;	
}


@end
