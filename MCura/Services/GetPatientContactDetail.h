//
//  GetPatientContactDetail.h
//  mCura
//
//  Created by Aakash Chaudhary on 02/04/12.
//  Copyright (c) 2012 aakash272@gmail.com. All rights reserved.
//

#import "SAServiceAsyncInvocation.h"
#import "_GMDocAsyncInvocation.h"

@class GetPatientContactDetail;

@protocol GetPatientContactDetailDelegate 

-(void) getPatientContactDetailDidFinish:(GetPatientContactDetail*)invocation
                        withPatients:(NSArray*)patients
                           withError:(NSError*)error;

@end
@interface GetPatientContactDetail : _GMDocAsyncInvocation 
{
    
}

@property (nonatomic, retain) NSString *userRollId;
@property (nonatomic, retain) NSString *contactId;

@end
