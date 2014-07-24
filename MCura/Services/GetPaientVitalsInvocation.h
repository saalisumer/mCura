//
//  GetPaientVitalsInvocation.h
//  mCura
//
//  Created by Aakash Chaudhary on 02/04/12.
//  Copyright (c) 2012 aakash272@gmail.com. All rights reserved.
//

#import "SAServiceAsyncInvocation.h"
#import "_GMDocAsyncInvocation.h"

@class GetPaientVitalsInvocation;

@protocol GetPaientVitalsInvocationDelegate 

-(void) getPaientVitalsInvocationDidFinish:(GetPaientVitalsInvocation*)invocation
                                 withVitals:(NSArray*)vitals
                                  withError:(NSError*)error;

@end
@interface GetPaientVitalsInvocation : _GMDocAsyncInvocation 
{
    
}

@property (nonatomic, retain) NSString *userRollId;
@property (nonatomic, retain) NSString *mrno;

@end