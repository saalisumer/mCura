//
//  GetLabPackageInvocation.h
//  3GMDoc
//
//  Created by Aakash Chaudhary on 15/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SAServiceAsyncInvocation.h"
#import "_GMDocAsyncInvocation.h"

@class GetLabPackageInvocation;

@protocol GetLabPackageInvocationDelegate 

-(void) GetLabPackageInvocationDidFinish:(GetLabPackageInvocation*)invocation
                         withPackages:(NSArray*)LabPackages
                        withError:(NSError*)error;

@end

@interface GetLabPackageInvocation : _GMDocAsyncInvocation

@property (nonatomic, retain) NSString *userRoleId;
@property (nonatomic, retain) NSString *subTenId;

@end
