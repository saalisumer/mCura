//
//  Appointment.h
//  3GMDoc

#import <Foundation/Foundation.h>
#import <Foundation/NSDictionary.h>
#import <Foundation/NSArray.h>

@class Booking;
@class Patdemographics;
@interface Appointment : NSObject {
	NSArray *bookings_;
    NSArray *patdemographics_;
}

@property(nonatomic, retain) NSNumber *AppId;
@property(nonatomic, retain) NSNumber *AvlStatusId;
@property(nonatomic, retain) NSString *ToTime;
@property(nonatomic, retain) NSString *FromTime;
@property(nonatomic, retain) NSNumber *TimeTableId;
@property(nonatomic, retain) NSArray *bookings;
@property(nonatomic, retain) NSArray *patdemographics;

@end
