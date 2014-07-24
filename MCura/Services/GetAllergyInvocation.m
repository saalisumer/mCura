//
//  GetAllergyInvocation.m
//  3GMDoc
//
//  Created by sandeep agrawal on 17/01/12.
//  Copyright (c) 2012 student.san1986@gmail.com. All rights reserved.
//

#import "GetAllergyInvocation.h"
#import "JSON.h"
#import "Allergy.h"
#import "Allergy+Parse.h"

@implementation GetAllergyInvocation

@synthesize userRollId;

-(void)dealloc {	
	[super dealloc];
}

-(void)invoke {
    NSString *a= [NSString stringWithFormat:@"%@GetAllergyType?UserRoleID=%@",[DataExchange getbaseUrl],self.userRollId];
    
	[self get:a];
}

-(BOOL)handleHttpOK:(NSMutableData *)data {
    
	NSArray* resultsd = [[[[NSString alloc] initWithData:data 
                                                     encoding:NSUTF8StringEncoding] autorelease] JSONValue];
    
    NSArray *response = [Allergy AllergysFromArray:resultsd];
	[self.delegate getAllergyInvocationDidFinish:self withAllergys:response withError:Nil];
    
	return YES;
}

-(BOOL)handleHttpError:(NSInteger)code {
	[self.delegate getAllergyInvocationDidFinish:self 
                                       withAllergys:nil
                                          withError:[NSError errorWithDomain:@"Allergy"
                                                                        code:[[self response] statusCode]
                                                                    userInfo:[NSDictionary dictionaryWithObject:@"Failed to get allergy details. Please try again later" forKey:@"message"]]];
	return YES;
}

@end

