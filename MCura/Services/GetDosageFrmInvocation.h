//
//  GetDosageFrmInvocation.h
//  3GMDoc
//
//  Created by sandeep agrawal on 18/01/12.
//  Copyright (c) 2012 student.san1986@gmail.com. All rights reserved.
//

#import "SAServiceAsyncInvocation.h"
#import "_GMDocAsyncInvocation.h"

@class GetDosageFrmInvocation;

@protocol GetDosageFrmInvocationDelegate 

-(void) getDosageFrmInvocationDidFinish:(GetDosageFrmInvocation*)invocation
                        withDosages:(NSArray*)dosages
                            withError:(NSError*)error;

@end
@interface GetDosageFrmInvocation : _GMDocAsyncInvocation 
{
    
}

@property (nonatomic, retain) NSString *userRollId;

@end
