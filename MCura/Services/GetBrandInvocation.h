//
//  GetBrandInvocation.h
//  3GMDoc
//
//  Created by Aakash Chaudhary on 02/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import "SAServiceAsyncInvocation.h"
#import "_GMDocAsyncInvocation.h"

@class GetBrandInvocation;

@protocol GetBrandInvocationDelegate 

-(void) getBrandInvocationDidFinish:(GetBrandInvocation*)invocation
                         withBrands:(NSArray*)brands
                           withError:(NSError*)error;

@end

@interface GetBrandInvocation : _GMDocAsyncInvocation {
}

@property (nonatomic, retain) NSString *userRollId;
@property (nonatomic, retain) NSString *genericId;


@end

