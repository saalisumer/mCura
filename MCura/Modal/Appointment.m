//
//  Appointment.m
//  3GMDoc

#import "Appointment.h"

@implementation Appointment

@synthesize AvlStatusId, ToTime, FromTime, TimeTableId, AppId;
@synthesize bookings = bookings_;
@synthesize patdemographics = patdemographics_;


-(void)dealloc 
{
    self.AvlStatusId = nil;
    self.ToTime = nil;
    self.FromTime = nil;
    self.TimeTableId = nil;
    self.AppId = nil;
    self.bookings = nil;
    self.patdemographics = nil;
    
	[super dealloc];
}

@end
