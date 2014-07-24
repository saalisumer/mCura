//
//  Booking.m
//  3GMDoc

#import "Booking.h"

@implementation Booking

@synthesize AppId, bookingId, appNatureId, currentStatusId, mrno;


-(void)dealloc 
{
    self.AppId = nil;
    self.bookingId = nil;
    self.appNatureId = nil;
    self.currentStatusId = nil;
    self.mrno = nil;
    
	[super dealloc];
}

@end
