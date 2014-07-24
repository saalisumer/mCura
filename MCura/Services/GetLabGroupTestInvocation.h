//
//  GetLabGroupTestInvocation.h
//  3GMDoc
//
//  Created by Aakash Chaudhary on 15/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SAServiceAsyncInvocation.h"
#import "_GMDocAsyncInvocation.h"

@class GetLabGroupTestInvocation;

@protocol GetLabGroupTestInvocationDelegate 

-(void) GetLabGroupTestInvocationDidFinish:(GetLabGroupTestInvocation*)invocation
                         withLabGroupTests:(NSArray*)LabGroupTests
                             withPackageId:(NSString*)packageId
                                 withError:(NSError*)error;

@end

@interface GetLabGroupTestInvocation : _GMDocAsyncInvocation

@property (nonatomic, retain) NSString *userRoleId;
@property (nonatomic, retain) NSString *packageId;

@end
