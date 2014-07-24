//
//  PostUploadOrderTextInvocation.h
//  3GMDoc
//
//  Created by Kanav Gupta on 2/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SAServiceAsyncInvocation.h"
#import "_GMDocAsyncInvocation.h"

@class PostUploadOrderTextInvocation;
@protocol PostUploadOrderTextDelegate

-(void)postUploadOrderTextDidFinish:(PostUploadOrderTextInvocation*)invocation withError:(NSError*)error;

@end

@interface PostUploadOrderTextInvocation : _GMDocAsyncInvocation{
    
}
@property(nonatomic, retain) NSString *AppId;
@property(nonatomic, retain) NSString *AvlStatusId;

@end

