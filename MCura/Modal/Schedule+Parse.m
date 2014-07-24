//
//  Schedule+Parse.m
//  3GMDoc

#import "Schedule+Parse.h"
#import "Schedule.h"
#import "JSON.h"
#import "SubTenant.h"
#import "Appointment.h"
#import "Appointment+Parse.h"

@implementation Schedule (Parse)

+(Schedule*) SchedulesFromDictionary:(NSDictionary*)Schedulesd{
	if (!Schedulesd) {
		return Nil;
	}
	
	Schedule *sch = [[[Schedule alloc] init] autorelease];
    
    sch.current_status_id = [Schedulesd objectForKey:@"current_status_id"];
    sch.current_status = [Schedulesd objectForKey:@"current_status"];
    sch.time_slot_id = [Schedulesd objectForKey:@"time_slot_id"];
    sch.from_time = [Schedulesd objectForKey:@"from_time"];
    sch.to_time = [Schedulesd objectForKey:@"to_time"];
    sch.user_role_id = [Schedulesd objectForKey:@"user_role_id"];
    sch.user_id = [Schedulesd objectForKey:@"user_id"];
    sch.role_id = [Schedulesd objectForKey:@"role_id"];
    sch.sub_tenant_id = [Schedulesd objectForKey:@"sub_tenant_id"];
    sch.day = [Schedulesd objectForKey:@"day"];
    sch.day_id = [Schedulesd objectForKey:@"day_id"];
    sch.app_duration = [Schedulesd objectForKey:@"app_duration"];
    sch.app_slot_id = [Schedulesd objectForKey:@"app_slot_id"];
    sch.priority = [Schedulesd objectForKey:@"priority"];
    sch.date = [Schedulesd objectForKey:@"date"];
    sch.time_table_id = [Schedulesd objectForKey:@"time_table_id"];
    sch.schedule_name = [Schedulesd objectForKey:@"schedule_name"];
    sch.Priority_id = [Schedulesd objectForKey:@"Priority_id"];
    sch.schedule_id = [NSString stringWithFormat:@"%d",[(NSNumber*)[Schedulesd objectForKey:@"schedule_id"] integerValue]];
    sch.ScheduleId = [Schedulesd objectForKey:@"ScheduleId"];
    sch.facilityName = [Schedulesd objectForKey:@"FacilityName"];
    sch.hospital = [Schedulesd objectForKey:@"Hospital"];
    sch.appointments = [Appointment AppointmentsFromArray:[Schedulesd objectForKey:@"appointments"]];
    sch.HospitalId = [Schedulesd objectForKey:@"HospitalID"];
    
    //these are used in Settings>Schedule>more actions
    if([Schedulesd objectForKey:@"ScheduleID"])
        sch.schedule_id = [NSString stringWithFormat:@"%d",[[Schedulesd objectForKey:@"ScheduleID"] integerValue]];
    if([Schedulesd objectForKey:@"FromTime"])
        sch.from_time = [Schedulesd objectForKey:@"FromTime"];
    if([Schedulesd objectForKey:@"Totime"])
        sch.to_time = [Schedulesd objectForKey:@"Totime"];
    if([Schedulesd objectForKey:@"Name"])
        sch.schedule_name = [Schedulesd objectForKey:@"Name"];
    if([Schedulesd objectForKey:@"Date"])
        sch.date = [Schedulesd objectForKey:@"Date"];
    if([Schedulesd objectForKey:@"SlotID"])
        sch.app_slot_id = [Schedulesd objectForKey:@"SlotID"];
    if([Schedulesd objectForKey:@"PriorityID"])
        sch.Priority_id = [Schedulesd objectForKey:@"PriorityID"];
    if([Schedulesd objectForKey:@"ScheduleID"])
        sch.schedule_id = [NSString stringWithFormat:@"%d",[(NSNumber*)[Schedulesd objectForKey:@"ScheduleID"] integerValue]];
    if([Schedulesd objectForKey:@"SpecificToDate"])
        sch.specificToDate = [Schedulesd objectForKey:@"SpecificToDate"];
    if([Schedulesd objectForKey:@"SpecificFromDate"])
        sch.specificFromDate = [Schedulesd objectForKey:@"SpecificFromDate"];
    if([Schedulesd objectForKey:@"SpecificDays"]){
        NSMutableArray* tempArray = [[NSMutableArray alloc] init];
        NSMutableArray* tempArray2 = [Schedulesd objectForKey:@"SpecificDays"];
        for (int i=0; i<tempArray2.count; i++) {
            [tempArray addObject:[(NSDictionary*)[tempArray2 objectAtIndex:i] objectForKey:@"Day"]];
        }
        sch.specificDays = tempArray;
    }
    if([Schedulesd objectForKey:@"Facility"]){
        NSMutableArray* tempArray = [[NSMutableArray alloc] init];
        NSMutableArray* tempArray2 = [Schedulesd objectForKey:@"Facility"];
        for (int i=0; i<tempArray2.count; i++) {
            SubTenant* tempSubTen = [[SubTenant alloc] init];
            tempSubTen.SubTenantIdInteger = [[(NSDictionary*)[tempArray2 objectAtIndex:i] objectForKey:@"FacilityID"] integerValue];
            tempSubTen.SubTenantId = [NSNumber numberWithInt:[[(NSDictionary*)[tempArray2 objectAtIndex:i] objectForKey:@"FacilityID"] integerValue]];
            tempSubTen.PriorityIndex = [[(NSDictionary*)[tempArray2 objectAtIndex:i] objectForKey:@"PriorityID"] integerValue];
            [tempArray addObject:tempSubTen];
        }
        sch.facilities = [[NSMutableArray alloc] initWithArray:tempArray];
    }
    if([Schedulesd objectForKey:@"IsSpecific"])
        sch.IsSpecific = [[Schedulesd objectForKey:@"IsSpecific"] boolValue];
    
	return sch;
    
}

+(NSArray*) SchedulesFromArray:(NSArray*) SchedulesA{
	if (!SchedulesA) {
		return Nil;
	}
	
	NSMutableArray *schedules = [[[NSMutableArray alloc] init] autorelease];
	for (int i = 0; i < SchedulesA.count; i++) {
        Schedule *sch = [Schedule SchedulesFromDictionary:[SchedulesA objectAtIndex:i]];
        if (sch) {
            [schedules addObject:sch];
        }
    }
	
	return schedules;	
}


@end

