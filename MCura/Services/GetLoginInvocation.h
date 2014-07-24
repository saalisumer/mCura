//
//  GetLoginInvocation.h
//  3GMDoc

#import "SAServiceAsyncInvocation.h"
#import "_GMDocAsyncInvocation.h"

@class GetLoginInvocation;

@protocol GetLoginInvocationDelegate 

-(void)getLoginInvocationDidFinish:(GetLoginInvocation*)invocation
                      withResponse:(NSArray*)responses
                          withError:(NSError*)error;

@end
@interface GetLoginInvocation : _GMDocAsyncInvocation 
{
    
}

@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) NSString *password;
@property (nonatomic, retain) NSString *type;


@end
