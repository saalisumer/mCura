//
//  GetTabletInvocation.h
//  3GMDoc

#import "SAServiceAsyncInvocation.h"
#import "_GMDocAsyncInvocation.h"

@class GetTabletInvocation;

@protocol GetTabletInvocationDelegate 

-(void)getTabletInvocationDidFinish:(GetTabletInvocation*)invocation
							  withTablets:(NSArray*)tablets
								withError:(NSError*)error;

@end
@interface GetTabletInvocation : _GMDocAsyncInvocation 
{
    
}

@property (nonatomic,retain)NSString *serialNo;


@end
