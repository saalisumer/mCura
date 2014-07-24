//
//  GetUserInvocation.h
//  3GMDoc

#import "SAServiceAsyncInvocation.h"
#import "_GMDocAsyncInvocation.h"
#import "UserDetail.h"
#import "UserDetail+Parse.h"

@class GetUserInvocation;

@protocol GetUserInvocationDelegate 

-(void)getUserInvocationDidFinish:(GetUserInvocation*)invocation
                      withResponse:(NSArray*)responses
                         withError:(NSError*)error;

-(void)getAsyncUserInvocationDidFinish:(GetUserInvocation*)invocation
                          withResponse:(NSArray*)responses
                             withError:(NSError*)error;

@end
@interface GetUserInvocation : _GMDocAsyncInvocation 
{
    
}

@property (nonatomic, retain) NSString *userRollId;
@property (assign) BOOL async;


@end
