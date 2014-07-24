//
//  GetInstructionInvocation.h
//  3GMDoc
//
//  Created by sandeep agrawal on 18/01/12.
//  Copyright (c) 2012 student.san1986@gmail.com. All rights reserved.
//

#import "SAServiceAsyncInvocation.h"
#import "_GMDocAsyncInvocation.h"

@class GetInstructionInvocation;

@protocol GetInstructionInvocationDelegate 

-(void) getInstructionInvocationDidFinish:(GetInstructionInvocation*)invocation
                      withInvocations:(NSArray*)invocations
                            withError:(NSError*)error;

@end
@interface GetInstructionInvocation : _GMDocAsyncInvocation 

@property (nonatomic, retain) NSString *userRollId;

@end
