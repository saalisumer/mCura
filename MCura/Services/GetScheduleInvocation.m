//
//  GetScheduleInvocation.m
//  3GMDoc

#import "GetScheduleInvocation.h"
#import "JSON.h"
#import "Schedule.h"
#import "Schedule+Parse.h"
#import "Appointment.h"
#import "Appointment+Parse.h"

@implementation GetScheduleInvocation

@synthesize userRollId, currentDate,type,time_table_id,subTenId,fromDate;

-(void)dealloc {
	[super dealloc];
}

-(void)invoke {
    NSString *a = nil;
    
    if([self.type isEqualToString:@"2"]){
        a= [NSString stringWithFormat:@"%@getSchedule_img?userRoleId=%@&CurDate=%@",[DataExchange getbaseUrl],self.userRollId, self.currentDate];
    }
    else if([self.type isEqualToString:@"99"]){
        a= [NSString stringWithFormat:@"%@GetScheduleList?userRoleId=%@&CurDate=%@",[DataExchange getbaseUrl],self.userRollId, self.currentDate];
    }
    else if([self.type isEqualToString:@"4"]){
        a= [NSString stringWithFormat:@"%@Get_Schedule?UserRoleId=%@&fromDate=%@&toDate=%@",[DataExchange getbaseUrl],self.userRollId,self.fromDate ,self.currentDate];
    }
    else if([self.type isEqualToString:@"3"]){
        a= [NSString stringWithFormat:@"%@getSchedule2?userRoleId=%@&subtenantid=%@&CurDate=%@",[DataExchange getbaseUrl],self.userRollId, self.subTenId,self.currentDate];
    }
    else{
        a= [NSString stringWithFormat:@"%@getSchedule?userRoleId=%@&CurDate=%@",[DataExchange getbaseUrl],self.userRollId, self.currentDate];
    }
	[self get:a];
}

-(BOOL)handleHttpOK:(NSMutableData *)data {
    
	NSArray* resultsd = [[[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease] JSONValue];
    
    NSArray* response = nil;
    if([self.type isEqualToString:@"2"]){
        response = [NSArray arrayWithObject:[[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease]];
    }
    else{
        response = [Schedule SchedulesFromArray:resultsd];
    }
    
	[self.delegate getScheduleInvocationDidFinish:self withSchedule:response withError:Nil];
	return YES;
}

-(BOOL)handleHttpError:(NSInteger)code {
	[self.delegate getScheduleInvocationDidFinish:self 
                                 withSchedule:nil
                                    withError:[NSError errorWithDomain:@"Schedule"
                                                                  code:[[self response] statusCode]
                                                              userInfo:[NSDictionary dictionaryWithObject:@"Failed to get schedule details. Please try again later" forKey:@"message"]]];
	return YES;
}

@end

