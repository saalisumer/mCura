//
//  GetStringInvocation.h
//  mCura
//
//  Created by Aakash Chaudhary on 28/06/12.
//  Copyright (c) 2012 aakash272@gmail.com. All rights reserved.
//

#import "_GMDocAsyncInvocation.h"
#import "SAServiceAsyncInvocation.h"

@class GetStringInvocation;
@protocol GetStringInvocationDelegate 

-(void) GetStringInvocationDidFinish:(GetStringInvocation*)invocation 
                  withResponseString:(NSString*)responseString 
                      withIdentifier:(NSString*)identifier 
                           withError:(NSError*)error;

@end

@interface GetStringInvocation : _GMDocAsyncInvocation

@property (nonatomic,retain) NSString* identifier;
@property (nonatomic,retain) NSString* urlString;

@end
