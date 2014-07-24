//
//  Booking+Parse.m
//  3GMDoc

#import "Booking+Parse.h"
#import "JSON.h"
#import "Booking.h"

@implementation Booking (Parse)

+(Booking*) BookingsFromDictionary:(NSDictionary*)Bookingsd{
	if (!Bookingsd) {
		return Nil;
	}
	
	Booking *app = [[[Booking alloc] init] autorelease];
    
    app.AppId = [Bookingsd objectForKey:@"AppId"];
    app.appNatureId = [Bookingsd objectForKey:@"AppNatureId"];
    app.bookingId = [Bookingsd objectForKey:@"BookingId"];
    app.currentStatusId = [Bookingsd objectForKey:@"CurrentStatusId"];
    app.mrno = [Bookingsd objectForKey:@"Mrno"];
    
	return app;
    
}

+(NSArray*) BookingsFromArray:(NSDictionary*) BookingsA{
	if (!BookingsA || [BookingsA isKindOfClass:[NSNull class]]) {
		return Nil;
	}
	
	NSMutableArray *appointments = [[[NSMutableArray alloc] init] autorelease];
    Booking *app = [Booking BookingsFromDictionary:BookingsA];
    if (app) {
        [appointments addObject:app];
    }
   
	
	return appointments;	
}


@end
