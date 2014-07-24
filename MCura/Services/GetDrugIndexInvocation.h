//
//  GetDrugIndexInvocation.h
//  mCura
//
//  Created by Aakash Chaudhary on 21/07/12.
//  Copyright (c) 2012 aakash272@gmail.com. All rights reserved.
//

#import "_GMDocAsyncInvocation.h"
#import "SAServiceAsyncInvocation.h"

@class GetDrugIndexInvocation;
@protocol GetDrugIndexInvocationDelegate 

-(void) GetDrugIndexInvocationDidFinish:(GetDrugIndexInvocation*)invocation 
                        withDrugIndices:(NSArray*)drugs 
                              withError:(NSError*)error;

-(void) GetDrugIndexInvocationDidFinish:(GetDrugIndexInvocation*)invocation 
                             withString:(NSString*)responseStr 
                               withType:(NSInteger)type
                              withError:(NSError*)error;

@end

@interface GetDrugIndexInvocation : _GMDocAsyncInvocation

@property (nonatomic, assign) NSInteger genericId;
@property (nonatomic, assign) NSInteger brandId;
@property (nonatomic, assign) NSInteger type;

@end
