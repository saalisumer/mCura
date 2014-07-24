//
//  GetScheduleInvocation.h
//  3GMDoc

#import "SAServiceAsyncInvocation.h"
#import "_GMDocAsyncInvocation.h"

@class GetScheduleInvocation;

@protocol GetScheduleInvocationDelegate 

-(void)getScheduleInvocationDidFinish:(GetScheduleInvocation*)invocation
                     withSchedule:(NSArray*)schedules
                        withError:(NSError*)error;

@end
@interface GetScheduleInvocation : _GMDocAsyncInvocation 
{
    
}

@property (nonatomic, retain) NSString *userRollId;
@property (nonatomic, retain) NSString *currentDate;
@property (nonatomic, retain) NSString *fromDate;
@property (nonatomic, retain) NSString *subTenId;
@property (nonatomic, retain) NSString *type;
@property (nonatomic, retain) NSString *time_table_id;

@end
