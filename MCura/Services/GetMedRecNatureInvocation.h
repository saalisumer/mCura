//
//  GetMedRecNatureInvocation.h
//  mCura
//
//  Created by Aakash Chaudhary on 27/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SAServiceAsyncInvocation.h"
#import "_GMDocAsyncInvocation.h"

@class GetMedRecNatureInvocation;
@protocol GetMedRecNatureInvocationDelegate 

-(void) GetMedRecNatureInvocationDidFinish:(GetMedRecNatureInvocation*)invocation
                 withMedRecNatureArray:(NSArray*)medRecArray
                          withError:(NSError*)error;
@end

@interface GetMedRecNatureInvocation : _GMDocAsyncInvocation

@end
