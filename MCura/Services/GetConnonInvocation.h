//
//  GetConnonInvocation.h
//  3GMDoc

#import "SAServiceAsyncInvocation.h"
#import "_GMDocAsyncInvocation.h"

@class GetConnonInvocation;

@protocol GetConnonInvocationDelegate 

-(void)getConnonInvocationDidFinish:(GetConnonInvocation*)invocation
                        withResults:(NSArray*)results
                           withError:(NSError*)error;

@end
@interface GetConnonInvocation : _GMDocAsyncInvocation 
{
    
}

@property (nonatomic, retain) NSString *type;

@end
