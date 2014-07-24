//
//  PostMoveAppointmentInvocation.h
//  3GMDoc

#import "SAServiceAsyncInvocation.h"
#import "_GMDocAsyncInvocation.h"

@class PostMoveAppointmentInvocation;

@protocol PostMoveAppointmentDelegate

-(void)postMoveAppointmentDidFinish:(PostMoveAppointmentInvocation*)invocation withError:(NSError*)error;

@end

@interface PostMoveAppointmentInvocation : _GMDocAsyncInvocation {
    
}

@property(nonatomic, retain) NSString *NewAppId;
@property(nonatomic, retain) NSString *oldAppId;
@property(nonatomic, retain) NSString *userRollId;
@property(nonatomic, retain) NSString *TimeTableId;
@end
