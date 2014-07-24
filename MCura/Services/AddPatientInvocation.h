//
//  AddPatientInvocation.h
//  3GMDoc

#import "SAServiceAsyncInvocation.h"
#import "_GMDocAsyncInvocation.h"

@class Patient;
@class AddPatientInvocation;

@protocol AddPatientInvocationDelegate

-(void)addPatientInvocationDidFinish:(AddPatientInvocation*)invocation withPatDemoId:(NSString*)demoId withError:(NSError*)error;

@end

@interface AddPatientInvocation : _GMDocAsyncInvocation {
    
}

@property (nonatomic, retain) Patient *pat;
@property (nonatomic, retain) NSString *userRollId;
@property (nonatomic, retain) NSString *subTenantId;
@property (nonatomic, retain) NSString *addressId;
@property (nonatomic, retain) NSString *contactId;
@property (nonatomic, retain) NSString *imagePathId;

- (void) postContactDetail;
- (void) postPatientDetail;

@end
