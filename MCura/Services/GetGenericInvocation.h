//
//  GetGenericInvocation.h
//  3GMDoc
//
//  Created by sandeep agrawal on 18/01/12.
//  Copyright (c) 2012 student.san1986@gmail.com. All rights reserved.
//

#import "SAServiceAsyncInvocation.h"
#import "_GMDocAsyncInvocation.h"

@class GetGenericInvocation;

@protocol GetGenericInvocationDelegate 

-(void) getGenericInvocationDidFinish:(GetGenericInvocation*)invocation
                         withInvocations:(NSArray*)invocations
                           withError:(NSError*)error;

@end
@interface GetGenericInvocation : _GMDocAsyncInvocation 
{
    
}

@property (nonatomic, retain) NSString *userRollId;

@end
