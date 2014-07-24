//
//  GetLabReportInvocation.h
//  mCura
//
//  Created by Aakash Chaudhary on 05/03/12.
//  Copyright (c) 2012 aakash272@gmail.com. All rights reserved.
//

#import "SAServiceAsyncInvocation.h"
#import "_GMDocAsyncInvocation.h"

@class GetLabReportInvocation;

@protocol GetLabReportInvocationDelegate 

-(void) GetLabReportInvocationDidFinish:(GetLabReportInvocation*)invocation
                             withLabReports:(NSArray*)LabReports
                                withError:(NSError*)error;

-(void) GetLabReportInvocationDidFinish:(GetLabReportInvocation*)invocation
                           withDocument:(NSURL*)labDocUrl
                              withError:(NSError*)error;

@end

@interface GetLabReportInvocation : _GMDocAsyncInvocation

@property(nonatomic,retain) NSString* userRoleId;
@property(nonatomic,retain) NSString* recordId;

@end
