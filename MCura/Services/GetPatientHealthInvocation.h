//
//  GetPatientHealthInvocation.h
//  mCura
//
//  Created by Aakash Chaudhary on 02/04/12.
//  Copyright (c) 2012 aakash272@gmail.com. All rights reserved.
//

#import "SAServiceAsyncInvocation.h"
#import "_GMDocAsyncInvocation.h"

@class GetPatientHealthInvocation;

@protocol GetPatientHealthInvocationDelegate 

-(void) getPatientHealthConditionInvocationDidFinish:(GetPatientHealthInvocation*)invocation
                                 withHealthConditions:(NSArray*)healths
                                   withError:(NSError*)error;
-(void) getPatientHealthConditionTypeInvocationDidFinish:(GetPatientHealthInvocation*)invocation
                                withHealthConditionTypes:(NSArray*)healths
                                           withError:(NSError*)error;
@end
@interface GetPatientHealthInvocation : _GMDocAsyncInvocation 
{
    
}

@property (nonatomic, retain) NSString *userRollId;
@property (assign) bool conditionOrType;

@end