//
//  GetPatientAllergyInvocation.m
//  3GMDoc
//
//  Created by sandeep agrawal on 20/01/12.
//  Copyright (c) 2012 student.san1986@gmail.com. All rights reserved.
//

#import "GetPatientAllergyInvocation.h"
#import "JSON.h"
#import "Allergy.h"
#import "Allergy+Parse.h"

@implementation GetPatientAllergyInvocation

@synthesize userRollId,allergyId;

-(void)dealloc {	
	[super dealloc];
}

-(void)invoke {
    NSString *a= [NSString stringWithFormat:@"%@GetAllergy?UserRoleID=%@&AllergyType=%@",[DataExchange getbaseUrl],self.userRollId,self.allergyId];
    [self get:a];
}

-(BOOL)handleHttpOK:(NSMutableData *)data {
    
	NSArray* resultsd = [[[[NSString alloc] initWithData:data 
                                                encoding:NSUTF8StringEncoding] autorelease] JSONValue];
    NSArray *response = [Allergy AllergyTypesFromArray:resultsd];
    [self.delegate getPatientAllergyInvocationDidFinish:self withAllergys:response withError:Nil];

	return YES;
}

-(BOOL)handleHttpError:(NSInteger)code {
	[self.delegate getPatientAllergyInvocationDidFinish:self
                                     withAllergys:nil
                                           withError:[NSError errorWithDomain:@"Allergy"
                                                                         code:[[self response] statusCode]
                                                                     userInfo:[NSDictionary dictionaryWithObject:@"Failed to get instruction details. Please try again later" forKey:@"message"]]];
	return YES;
}

@end