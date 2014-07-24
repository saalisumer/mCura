//
//  GetSubtenIdInvocation.h
//  3GMDoc
//
//  Created by Aakash Chaudhary on 09/02/12.
//  Copyright (c) 2012 aakash272@gmail.com. All rights reserved.
//

#import "SAServiceAsyncInvocation.h"
#import "_GMDocAsyncInvocation.h"

@class GetSubtenIdInvocation;

@protocol GetSubtenIdInvocationDelegate 

-(void) GetSubtenIdInvocationDidFinish:(GetSubtenIdInvocation*)invocation
                        withSubTenantIds:(NSArray*)subTenantId
                             withError:(NSError*)error;

@end

@interface GetSubtenIdInvocation : _GMDocAsyncInvocation

@property (nonatomic, retain) NSString *userRoleId;
@property (nonatomic, retain) NSString *subTenantId;
@property (nonatomic,assign) bool isSecondService;

@end
