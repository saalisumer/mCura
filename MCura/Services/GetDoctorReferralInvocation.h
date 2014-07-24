//
//  GetDoctorReferralInvocation.h
//  mCura
//
//  Created by Aakash Chaudhary on 16/04/12.
//  Copyright (c) 2012 aakash272@gmail.com. All rights reserved.
//

#import "SAServiceAsyncInvocation.h"
#import "_GMDocAsyncInvocation.h"

@class GetDoctorReferralInvocation;
@protocol GetDoctorReferralInvocationDelegate 

-(void) GetDoctorReferralInvocationDidFinish:(GetDoctorReferralInvocation*)invocation
                     withDoctorReferralArray:(NSArray*)doctReferArray
                                 withError:(NSError*)error;
@end

@interface GetDoctorReferralInvocation : _GMDocAsyncInvocation

@property (nonatomic, retain) NSString *userRoleId;
@property (nonatomic, retain) NSString *subTenId;

@end
