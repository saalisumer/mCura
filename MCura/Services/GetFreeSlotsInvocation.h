//
//  GetFreeSlotsInvocation.h
//  mCura
//
//  Created by Aakash Chaudhary on 11/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SAServiceAsyncInvocation.h"
#import "_GMDocAsyncInvocation.h"
@class GetFreeSlotsInvocation;

@protocol GetFreeSlotsInvocationDelegate 

-(void)getFreeSlotsInvocationDidFinish:(GetFreeSlotsInvocation*)invocation
                        withAppointments:(NSArray*)results
                          withError:(NSError*)error;

@end

@interface GetFreeSlotsInvocation : _GMDocAsyncInvocation

@property (nonatomic, retain) NSString *userRoleId;
@property (nonatomic, retain) NSString *timeTableId;

@end
