//
//  GetNotesInvocation.h
//  mCura
//
//  Created by Aakash Chaudhary on 17/03/12.
//  Copyright (c) 2012 aakash272@gmail.com. All rights reserved.
//

#import "SAServiceAsyncInvocation.h"
#import "_GMDocAsyncInvocation.h"

@class GetNotesInvocation;
@protocol GetNotesInvocationDelegate 

-(void) GetNotesInvocationDidFinish:(GetNotesInvocation*)invocation
                 withNotesDataArray:(NSArray*)notesArray
                          withError:(NSError*)error;
@end

@interface GetNotesInvocation : _GMDocAsyncInvocation

@property (nonatomic, retain) NSString *userRoleId;
@property (nonatomic, retain) NSString *recordId;

@end
