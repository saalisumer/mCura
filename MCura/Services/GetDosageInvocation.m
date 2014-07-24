//
//  GetDosageInvocation.m
//  3GMDoc
//
//  Created by sandeep agrawal on 17/01/12.
//  Copyright (c) 2012 student.san1986@gmail.com. All rights reserved.
//

#import "GetDosageInvocation.h"
#import "JSON.h"
#import "Dosage.h"
#import "Dosage+Parse.h"

@implementation GetDosageInvocation

@synthesize userRollId;

-(void)dealloc {	
	[super dealloc];
}

-(void)invoke {
    NSString *a= [NSString stringWithFormat:@"%@GetDosage?UserRoleID=%@",[DataExchange getbaseUrl],self.userRollId];
    
	[self get:a];
}

-(BOOL)handleHttpOK:(NSMutableData *)data {
    
	NSArray* resultsd = [[[[NSString alloc] initWithData:data 
                                                encoding:NSUTF8StringEncoding] autorelease] JSONValue];
    
    
    NSArray *response = [Dosage DosagesFromArray:resultsd];
    
	[self.delegate getDosageInvocationDidFinish:self withDosages:response withError:Nil];
	return YES;
}

-(BOOL)handleHttpError:(NSInteger)code {
	[self.delegate getDosageInvocationDidFinish:self 
                                    withDosages:nil
                                       withError:[NSError errorWithDomain:@"Dosage"
                                                                     code:[[self response] statusCode]
                                                                 userInfo:[NSDictionary dictionaryWithObject:@"Failed to get dosage details. Please try again later" forKey:@"message"]]];
	return YES;
}

@end
