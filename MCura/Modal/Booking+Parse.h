//
//  Booking+Parse.h
//  3GMDoc

#import "Booking.h"

@interface Booking (Parse)

+(Booking*) BookingsFromDictionary:(NSDictionary*)Bookingsd;
+(NSArray*) BookingsFromArray:(NSDictionary*) BookingsA;

@end
