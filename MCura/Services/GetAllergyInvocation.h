//
//  GetAllergyInvocation.h
//  3GMDoc
//
//  Created by sandeep agrawal on 17/01/12.
//  Copyright (c) 2012 student.san1986@gmail.com. All rights reserved.
//

#import "SAServiceAsyncInvocation.h"
#import "_GMDocAsyncInvocation.h"

@class GetAllergyInvocation;

@protocol GetAllergyInvocationDelegate 

-(void) getAllergyInvocationDidFinish:(GetAllergyInvocation*)invocation
                            withAllergys:(NSArray*)allergys
                               withError:(NSError*)error;

@end
@interface GetAllergyInvocation : _GMDocAsyncInvocation 
{
    
}

@property (nonatomic, retain) NSString *userRollId;

@end
