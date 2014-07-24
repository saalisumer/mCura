//
//  GetPatientAllergyInvocation.h
//  3GMDoc
//
//  Created by sandeep agrawal on 20/01/12.
//  Copyright (c) 2012 student.san1986@gmail.com. All rights reserved.
//
#import "SAServiceAsyncInvocation.h"
#import "_GMDocAsyncInvocation.h"

@class GetPatientAllergyInvocation;

@protocol GetPatientAllergyInvocationDelegate 

-(void) getPatientAllergyInvocationDidFinish:(GetPatientAllergyInvocation*)invocation
                            withAllergys:(NSArray*)allergys
                                withError:(NSError*)error;
@end

@interface GetPatientAllergyInvocation : _GMDocAsyncInvocation 
{
    
}

@property (nonatomic, retain) NSString *userRollId;
@property (nonatomic, retain) NSString *allergyId;

@end
