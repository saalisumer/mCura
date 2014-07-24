//
//  GetGenericInvocation.m
//  3GMDoc
//
//  Created by sandeep agrawal on 18/01/12.
//  Copyright (c) 2012 student.san1986@gmail.com. All rights reserved.
//

#import "GetGenericInvocation.h"
#import "JSON.h"
#import "Generic.h"
#import "Generic+Parse.h"

@implementation GetGenericInvocation

@synthesize userRollId;

-(void)dealloc {	
	[super dealloc];
}

-(void)invoke {
//    NSString *a= [NSString stringWithFormat:@"%@GetGenerics?UserRoleID=%@",[DataExchange getbaseUrl],self.userRollId];
    NSString *a= [NSString stringWithFormat:@"%@DrugIndex_Drugs",[DataExchange getbaseUrl]];
	[self get:a];
}

-(BOOL)handleHttpOK:(NSMutableData *)data {
    
	NSArray* resultsd = [[[[NSString alloc] initWithData:data 
                                                encoding:NSUTF8StringEncoding] autorelease] JSONValue];
    
    
    NSArray *response = [Generic PGenericsFromArray:resultsd];
    
	[self.delegate getGenericInvocationDidFinish:self withInvocations:response withError:Nil];
	return YES;
}

-(BOOL)handleHttpError:(NSInteger)code {
	[self.delegate getGenericInvocationDidFinish:self 
                                    withInvocations:nil
                                      withError:[NSError errorWithDomain:@"Generic"
                                                                    code:[[self response] statusCode]
                                                                userInfo:[NSDictionary dictionaryWithObject:@"Failed to get dosage details. Please try again later" forKey:@"message"]]];
	return YES;
}

@end
