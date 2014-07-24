//
//  PostAppointmentInvocation.h
//  3GMDoc

#import "SAServiceAsyncInvocation.h"
#import "_GMDocAsyncInvocation.h"

@class PostAppointmentInvocation;

@protocol PostAppointmentDelegate

-(void)postAppointmentDidFinish:(PostAppointmentInvocation*)invocation withError:(NSError*)error;

@end

@interface PostAppointmentInvocation : _GMDocAsyncInvocation {
    
}

@property (nonatomic, retain) NSString* type;
@property(nonatomic, retain) NSNumber *AppId;
@property (nonatomic, retain) NSString *userRollId;

@end
