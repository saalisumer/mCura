//
//  GetSeverityInvocation.h
//  3GMDoc
//
//  Created by Aakash Chaudhary on 07/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SAServiceAsyncInvocation.h"
#import "_GMDocAsyncInvocation.h"

@class GetSeverityInvocation;

@protocol GetSeverityInvocationDelegate 

-(void) GetSeverityInvocationDidFinish:(GetSeverityInvocation*)invocation
                         withSeverities:(NSArray*)Severities
                        withError:(NSError*)error;

@end

@interface GetSeverityInvocation : _GMDocAsyncInvocation

@end
