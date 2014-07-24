//
//  GetLabTestListInvocation.h
//  3GMDoc
//
//  Created by Aakash Chaudhary on 15/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SAServiceAsyncInvocation.h"
#import "_GMDocAsyncInvocation.h"

@class GetLabTestListInvocation;

@protocol GetLabTestListInvocationDelegate 

-(void)GetLabTestListInvocationDidFinish:(GetLabTestListInvocation*)invocation withLabTests:(NSArray*)LabTests withPackageId:(NSString*)packageId withGroupId:(NSString*)grpId withError:(NSError*)error;

@end

@interface GetLabTestListInvocation : _GMDocAsyncInvocation

@property (nonatomic, retain) NSString *userRoleId;
@property (nonatomic, retain) NSString *labGrpId;
@property (nonatomic, retain) NSString *packageId;

@end
