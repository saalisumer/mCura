//
//  GetFollowUpInvocation.h
//  3GMDoc
//
//  Created by sandeep agrawal on 18/01/12.
//  Copyright (c) 2012 student.san1986@gmail.com. All rights reserved.
//


#import "SAServiceAsyncInvocation.h"
#import "_GMDocAsyncInvocation.h"

@class GetFollowUpInvocation;

@protocol GetFollowUpInvocationDelegate 

-(void) getFollowUpInvocationDidFinish:(GetFollowUpInvocation*)invocation
                           withFollows:(NSArray*)follows
                            withError:(NSError*)error;

@end
@interface GetFollowUpInvocation : _GMDocAsyncInvocation 
{
    
}

@property (nonatomic, retain) NSString *userRollId;

@end
