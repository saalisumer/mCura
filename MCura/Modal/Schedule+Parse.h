//
//  Schedule+Parse.h
//  3GMDoc

#import "Schedule.h"

@interface Schedule (Parse)

+(Schedule*) SchedulesFromDictionary:(NSDictionary*)Schedulesd;
+(NSArray*) SchedulesFromArray:(NSArray*) SchedulesA;

@end