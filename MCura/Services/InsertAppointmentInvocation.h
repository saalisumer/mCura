//
//  InsertAppointmentInvocation.h
//  3GMDoc

#import "SAServiceAsyncInvocation.h"
#import "_GMDocAsyncInvocation.h"

@class Patient;
@class InsertAppointmentInvocation;

@protocol InsertAppointmentDelegate

-(void)insertAppointmentDidFinish:(InsertAppointmentInvocation*)invocation withError:(NSError*)error;

@end

@interface InsertAppointmentInvocation : _GMDocAsyncInvocation {
    
}

@property (nonatomic, retain) NSNumber *AppId;
@property (nonatomic, retain) NSNumber *AvlStatusId;
@property (nonatomic, retain) NSString *userRollId;
@property (nonatomic, retain) NSString *currentStatusId;
@property (nonatomic, retain) NSString *AppNatureId;
@property (nonatomic, retain) NSString* othDetails;
@property (nonatomic, retain) NSNumber* mrno;


@end
