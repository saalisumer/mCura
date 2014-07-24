//
//  GetDosageInvocation.h
//  3GMDoc
//
//  Created by sandeep agrawal on 17/01/12.
//  Copyright (c) 2012 student.san1986@gmail.com. All rights reserved.
//

#import "SAServiceAsyncInvocation.h"
#import "_GMDocAsyncInvocation.h"

@class GetDosageInvocation;

@protocol GetDosageInvocationDelegate 

-(void) getDosageInvocationDidFinish:(GetDosageInvocation*)invocation
                         withDosages:(NSArray*)dosages
                            withError:(NSError*)error;

@end
@interface GetDosageInvocation : _GMDocAsyncInvocation 
{
    
}

@property (nonatomic, retain) NSString *userRollId;

@end
