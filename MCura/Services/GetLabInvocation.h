//
//  GetLabInvocation.h
//  3GMDoc
//
//  Created by Aakash Chaudhary on 07/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SAServiceAsyncInvocation.h"
#import "_GMDocAsyncInvocation.h"

@class GetLabInvocation;

@protocol GetLabInvocationDelegate 

-(void) getLabInvocationDidFinish:(GetLabInvocation*)invocation
                         withLabs:(NSArray*)Labs
                             withError:(NSError*)error;

@end

@interface GetLabInvocation : _GMDocAsyncInvocation 

@property (nonatomic, retain) NSString *userRollId;
@property (nonatomic, retain) NSString *schedulesId;
@property (nonatomic, assign) NSInteger type;

@end
