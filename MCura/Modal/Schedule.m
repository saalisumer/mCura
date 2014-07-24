//
//  Schedule.m
//  3GMDoc

#import "Schedule.h"
#import "Appointment.h"

@implementation Schedule

@synthesize current_status_id, current_status, time_slot_id, from_time, to_time, user_role_id, user_id, role_id, sub_tenant_id, day,day_id, app_duration, app_slot_id,priority, date, time_table_id, schedule_name, Priority_id,scheduleImg,schedule_id,facilityName,hospital,ScheduleId,HospitalId,IsSpecific,specificDays,specificToDate,specificFromDate,facilities;

@synthesize appointments = appointments_;


-(void)dealloc 
{
    self.current_status_id = nil;
    self.current_status = nil;
    self.time_slot_id = nil;
    self.from_time = nil;
    self.to_time = nil;
    self.user_role_id = nil;
    self.user_id = nil;
    self.role_id = nil;
    self.sub_tenant_id = nil;
    self.day = nil;
    self.day_id = nil;
    self.app_duration = nil;
    self.app_slot_id = nil;
    self.priority = nil;
    self.date = nil;
    self.time_table_id = nil;
    self.schedule_name = nil;
    self.Priority_id = nil;
    self.scheduleImg = nil;
    self.appointments = nil;
    self.schedule_id = nil;
    self.ScheduleId = nil;
    self.facilityName = nil;
    self.hospital = nil;
    self.HospitalId = nil;
    self.specificDays = nil;
    self.specificFromDate = nil;
    self.specificToDate = nil;
    self.facilities = nil;
	[super dealloc];
}

@end
