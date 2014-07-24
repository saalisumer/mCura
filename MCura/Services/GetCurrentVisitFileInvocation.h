//
//  GetCurrentVisitFileInvocation.h
//  mCura
//
//  Created by Aakash Chaudhary on 09/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SAServiceAsyncInvocation.h"
#import "_GMDocAsyncInvocation.h"

@class GetCurrentVisitFileInvocation;
@protocol GetCurrentVisitFileInvocationDelegate 

-(void) GetCurrentVisitFileInvocationDidFinish:(GetCurrentVisitFileInvocation*)invocation
                 withCurrentVisitFile:(id)file
                          withError:(NSError*)error;
@end

@interface GetCurrentVisitFileInvocation : _GMDocAsyncInvocation

@property (nonatomic, retain) NSString *userRoleId;
@property (nonatomic, retain) NSString *mrNo;

@end
