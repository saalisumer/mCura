//
//  GetVitalsInvocation.h
//  mCura
//
//  Created by Aakash Chaudhary on 15/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SAServiceAsyncInvocation.h"
#import "_GMDocAsyncInvocation.h"
@class GetVitalsInvocation;
@protocol GetVitalsInvocationDelegate 

-(void) GetVitalsInvocationDidFinish:(GetVitalsInvocation*)invocation
                          withVitals:(NSArray*)vitalsArray
                           withError:(NSError*)error;
@end

@interface GetVitalsInvocation : _GMDocAsyncInvocation

@property (nonatomic, retain) NSString *userRoleId;

@end
