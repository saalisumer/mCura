//
//  GetDocAddrOrContInvocation.h
//  mCura
//
//  Created by Aakash Chaudhary on 03/05/12.
//  Copyright (c) 2012 aakash272@gmail.com. All rights reserved.
//

#import "SAServiceAsyncInvocation.h"
#import "_GMDocAsyncInvocation.h"

@class GetDocAddrOrContInvocation;
@protocol GetDocAddrOrContInvocationDelegate 

-(void) GetDocAddrInvocationDidFinish:(GetDocAddrOrContInvocation*)invocation
                  withDocAddressArray:(NSArray*)doctReferArray
                            withError:(NSError*)error;

-(void) GetDocContInvocationDidFinish:(GetDocAddrOrContInvocation*)invocation 
                  withDocContactArray:(NSArray*)doctReferArray 
                            withError:(NSError*)error;
@end

@interface GetDocAddrOrContInvocation : _GMDocAsyncInvocation

@property (nonatomic, retain) NSString *userRoleId;
@property (nonatomic, retain) NSString *addressOrContactId;;
@property (assign) bool addressOrContact;

@end
