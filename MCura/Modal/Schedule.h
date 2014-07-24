//
//  Schedule.h
//  3GMDoc

#import <Foundation/Foundation.h>
#import <Foundation/NSDictionary.h>
#import <Foundation/NSArray.h>

@class Appointment;
@interface Schedule : NSObject {
	
    NSArray *appointments_;
}

@property(nonatomic, retain) NSArray* appointments;
@property(nonatomic, retain) NSNumber *current_status_id;
@property(nonatomic, retain) NSString *current_status;
@property(nonatomic, retain) NSString *time_slot_id;
@property(nonatomic, retain) NSString *from_time;
@property(nonatomic, retain) NSString *to_time;
@property(nonatomic, retain) NSNumber *user_role_id;
@property(nonatomic, retain) NSString *user_id;
@property(nonatomic, retain) NSNumber *role_id;
@property(nonatomic, retain) NSString *sub_tenant_id;
@property(nonatomic, retain) NSString *day;
@property(nonatomic, retain) NSNumber *day_id;
@property(nonatomic, retain) NSString *app_duration;
@property(nonatomic, retain) NSNumber *app_slot_id;
@property(nonatomic, retain) NSString *priority;
@property(nonatomic, retain) NSString *date;
@property(nonatomic, retain) NSNumber *time_table_id;
@property(nonatomic, retain) NSString *schedule_name;
@property(nonatomic, retain) NSNumber *Priority_id;
@property(nonatomic, retain) NSString *scheduleImg;
@property(nonatomic, retain) NSString *schedule_id;
@property(nonatomic, retain) NSNumber *ScheduleId;
@property(nonatomic, retain) NSNumber *HospitalId;
@property(nonatomic, retain) NSString *facilityName;
@property(nonatomic, retain) NSString *hospital;
@property(nonatomic, assign) BOOL IsSpecific;
@property(nonatomic, retain) NSString *specificFromDate;
@property(nonatomic, retain) NSString *specificToDate;
@property(nonatomic, retain) NSArray* specificDays;
@property(nonatomic, retain) NSArray* facilities;

@end
