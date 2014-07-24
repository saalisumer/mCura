//
//  GetPatComplaints.h
//  3GMDoc
//
//  Created by Aakash Chaudhary on 05/02/12.
//  Copyright (c) 2012 aakash272@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SAServiceAsyncInvocation.h"
#import "_GMDocAsyncInvocation.h"

@class GetPatComplaints;

@protocol GetPatComplaintsInvocationDelegate 

-(void) getPatComplaintsInvocationDidFinish:(GetPatComplaints*)invocations
                         withPatComplaints:(NSArray*)patComplaints
                          withError:(NSError*)error;

@end

@interface GetPatComplaints : _GMDocAsyncInvocation

@property (nonatomic, retain) NSString *userRoleId;
@property (nonatomic, retain) NSString *RecordId;

@end
