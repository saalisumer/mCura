//
//  GetPatMedRecords.h
//  3GMDoc
//
//  Created by Aakash Chaudhary on 05/02/12.
//  Copyright (c) 2012 aakash272@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SAServiceAsyncInvocation.h"
#import "_GMDocAsyncInvocation.h"
#import "Patdemographics.h"

@class GetPatMedRecords;

@protocol GetPatMedRecordsInvocationDelegate 

-(void) getPatMedRecordsInvocationDidFinish:(GetPatMedRecords*)invocations
                          withPatAddressCity:(NSString*)cityStr
                                  withError:(NSError*)error;

-(void) getPatMedRecordsInvocationDidFinish:(GetPatMedRecords*)invocations
                          withPatMedRecords:(NSArray*)patMedRecords
                                  withError:(NSError*)error;

-(void) getPatAllergyInvocationDidFinish:(GetPatMedRecords*)invocations
                          withPatAllergies:(NSArray*)patAllergies
                                  withError:(NSError*)error;

-(void) getPatHealthInvocationDidFinish:(GetPatMedRecords*)invocations
                          withPatHealthRecords:(NSArray*)patHealthRecords
                                  withError:(NSError*)error;
@end

@interface GetPatMedRecords : _GMDocAsyncInvocation

@property (nonatomic, retain) NSString* UserRoleID;
@property (nonatomic, retain) NSString* MRNO;
@property (nonatomic, retain) NSString* subTenantId;

@end
