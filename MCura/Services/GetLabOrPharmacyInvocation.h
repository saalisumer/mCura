//
//  GetLabOrPharmacyInvocation.h
//  3GMDoc
//
//  Created by Aakash Chaudhary on 15/02/12.
//  Copyright (c) 2012 aakash272@gmail.com. All rights reserved.
//

#import "SAServiceAsyncInvocation.h"
#import "_GMDocAsyncInvocation.h"
#import "LabOrder.h"
#import "PharmacyOrder.h"

@class GetLabOrPharmacyInvocation;

@protocol GetLabOrPharmacyInvocationDelegate 

-(void) GetLabOrPharmacyInvocationDidFinish:(GetLabOrPharmacyInvocation*)invocation
                      withLabOrder:(LabOrder*)labOrder
                             withError:(NSError*)error;

-(void) GetLabOrPharmacyInvocationDidFinish:(GetLabOrPharmacyInvocation*)invocation
                               withPharmacyOrder:(NSArray*)pharmacyOrder
                                  withError:(NSError*)error;

@end


@interface GetLabOrPharmacyInvocation : _GMDocAsyncInvocation

@property (nonatomic, retain) NSString *userRoleId;
@property (nonatomic, retain) NSString *recordId;
@property (nonatomic, assign) bool labOrPharmacy; // true for lab

@end
