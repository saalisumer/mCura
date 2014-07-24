//
//  GetPharmacyInvocation.h
//  3GMDoc
//
//  Created by sandeep agrawal on 18/01/12.
//  Copyright (c) 2012 student.san1986@gmail.com. All rights reserved.
//

#import "SAServiceAsyncInvocation.h"
#import "_GMDocAsyncInvocation.h"

@class GetPharmacyInvocation;

@protocol GetPharmacyInvocationDelegate 

-(void) getPharmacyInvocationDidFinish:(GetPharmacyInvocation*)invocation
                      withPharmacys:(NSArray*)pharmacys
                            withError:(NSError*)error;

@end

@interface GetPharmacyInvocation : _GMDocAsyncInvocation 
{
    
}

@property (nonatomic, assign) NSInteger type;
@property (nonatomic, retain) NSString *userRollId;
@property (nonatomic, retain) NSString *schedulesID;

@end
