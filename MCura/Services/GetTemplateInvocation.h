//
//  GetTemplateInvocation.h
//  mCura
//
//  Created by Aakash Chaudhary on 25/03/12.
//  Copyright (c) 2012 aakash272@gmail.com. All rights reserved.
//

#import "SAServiceAsyncInvocation.h"
#import "_GMDocAsyncInvocation.h"

@class PharmacyOrder;

@class GetTemplateInvocation;

@protocol GetTemplateInvocationDelegate 

-(void) GetTemplateInvocationDidFinish:(GetTemplateInvocation*)invocation
                         withTemplates:(NSArray*)templates
                          withError:(NSError*)error;

-(void) GetTemplateMedicineInvocationDidFinish:(GetTemplateInvocation*)invocation
                         withMedicine:(NSArray*)medicineArray
                             withError:(NSError*)error;

@end
@interface GetTemplateInvocation : _GMDocAsyncInvocation

@property (nonatomic, retain) NSString *userRoleId;
@property (nonatomic, retain) NSString *templateId;
@property (nonatomic, assign) bool templateOrMedicine; // true for template

@end
