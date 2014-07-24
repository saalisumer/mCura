//
//  Appointment+Parse.m
//  3GMDoc

#import "Appointment+Parse.h"
#import "Appointment.h"
#import "JSON.h"
#import "Booking.h"
#import "Booking+Parse.h"
#import "Patdemographics.h"
#import "Patdemographics+Parse.h"

@implementation Appointment (Parse)

+(Appointment*) AppointmentsFromDictionary:(NSDictionary*)Appointmentsd{
	if (!Appointmentsd) {
		return Nil;
	}
	
	Appointment *app = [[[Appointment alloc] init] autorelease];
    
    app.AvlStatusId = [Appointmentsd objectForKey:@"AvlStatusId"];
    app.ToTime = [Appointmentsd objectForKey:@"ToTime"];
    app.FromTime = [Appointmentsd objectForKey:@"FromTime"];
    app.TimeTableId = [Appointmentsd objectForKey:@"TimeTableId"];
    app.AppId = [Appointmentsd objectForKey:@"AppId"];
    app.patdemographics = [Patdemographics PatdemographicsFromArray:[Appointmentsd objectForKey:@"patdemographics"]];
    app.bookings = [Booking BookingsFromArray:[Appointmentsd objectForKey:@"appbookings"]];

	return app;
    
}

+(NSArray*) AppointmentsFromArray:(NSArray*) AppointmentsA{
	if (!AppointmentsA) {
		return Nil;
	}
	
	NSMutableArray *appointments = [[[NSMutableArray alloc] init] autorelease];
	for (int i = 0; i < AppointmentsA.count; i++) {
        Appointment *app = [Appointment AppointmentsFromDictionary:[AppointmentsA objectAtIndex:i]];
        if (app) {
            [appointments addObject:app];
        }
    }
	
	return appointments;	
}


@end
