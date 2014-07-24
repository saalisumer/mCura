//
//  GetPatientInvocation.h
//  3GMDoc

#import "SAServiceAsyncInvocation.h"
#import "_GMDocAsyncInvocation.h"

@class GetPatientInvocation;

@protocol GetPatientInvocationnDelegate 

-(void)getPatientInvocationDidFinish:(GetPatientInvocation*)invocation
                         withPatients:(NSArray*)patients
                            withError:(NSError*)error;

@end
@interface GetPatientInvocation : _GMDocAsyncInvocation 
{
    
}

@property (nonatomic, retain) NSString *userRollId;
@property (nonatomic, retain) NSString *searchkey;
@property (nonatomic, retain) NSString *sub_tenant_id;

@end

 
