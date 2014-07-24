//
//  GetTemplateInvocation.m
//  mCura
//
//  Created by Aakash Chaudhary on 25/03/12.
//  Copyright (c) 2012 aakash272@gmail.com. All rights reserved.
//

#import "JSON.h"
#import "Template.h"
#import "Template+Parse.h"
#import "PharmacyOrder.h"
#import "PharmacyOrder+Parse.h"
#import "GetTemplateInvocation.h"

@implementation GetTemplateInvocation
@synthesize userRoleId,templateId,templateOrMedicine;

-(void)dealloc {	
	[super dealloc];
}

-(void)invoke {
    NSString *a;
    if(templateOrMedicine)
        a = [NSString stringWithFormat:@"%@GetTemplates?UserRoleID=%@",[DataExchange getbaseUrl],self.userRoleId];
    else
        a = [NSString stringWithFormat:@"%@GetTemplatesMedicine?UserRoleID=%@&templateID=%@",[DataExchange getbaseUrl],self.userRoleId,self.templateId];
	[self get:a];
}

-(BOOL)handleHttpOK:(NSMutableData *)data {
    
	NSArray* resultsd = [[[[NSString alloc] initWithData:data 
                                                encoding:NSUTF8StringEncoding] autorelease] JSONValue];
    if(templateOrMedicine){
        if(resultsd.count!=0){
            NSArray* response = [Template TemplatesFromArray:resultsd];
            [self.delegate GetTemplateInvocationDidFinish:self withTemplates:response withError:Nil];
            return YES;
        }
        else{
            [self.delegate GetTemplateInvocationDidFinish:self withTemplates:nil withError:[NSError errorWithDomain:@"Templates" code:[[self response] statusCode] userInfo:[NSDictionary dictionaryWithObject:@"Failed to get template details. Please try again later" forKey:@"message"]]];
            return YES;
        }
    }
    else{
        if(resultsd.count!=0){
            NSArray* response = [PharmacyOrder PharmacyOrderTemplateFromArray:resultsd];
            [self.delegate GetTemplateMedicineInvocationDidFinish:self withMedicine:response withError:nil];
            return YES;
        }
        else{
            [self.delegate GetTemplateMedicineInvocationDidFinish:self withMedicine:nil withError:[NSError errorWithDomain:@"Templates" code:[[self response] statusCode] userInfo:[NSDictionary dictionaryWithObject:@"Failed to get template details. Please try again later" forKey:@"message"]]];
            return YES;
        }
    }
	
}

-(BOOL)handleHttpError:(NSInteger)code {
    if(templateOrMedicine)
        [self.delegate GetTemplateInvocationDidFinish:self 
                                        withTemplates:nil
                                            withError:[NSError errorWithDomain:@"Template"
                                                                          code:[[self response] statusCode]
                                                                      userInfo:[NSDictionary dictionaryWithObject:@"Failed to get template details. Please try again later" forKey:@"message"]]];
    else
        [self.delegate GetTemplateMedicineInvocationDidFinish:self 
                                         withMedicine:nil
                                                 withError:[NSError errorWithDomain:@"template"
                                                                               code:[[self response] statusCode]
                                                                           userInfo:[NSDictionary dictionaryWithObject:@"Failed to get template details. Please try again later" forKey:@"message"]]];
	return YES;
}

@end
