//
//  GetDosageFrmInvocation.m
//  3GMDoc
//
//  Created by sandeep agrawal on 18/01/12.
//  Copyright (c) 2012 student.san1986@gmail.com. All rights reserved.
//

#import "GetDosageFrmInvocation.h"
#import "JSON.h"
#import "DosageFrm.h"
#import "DosageFrm+Parse.h"

@implementation GetDosageFrmInvocation

@synthesize userRollId;

-(void)dealloc {	
	[super dealloc];
}

-(void)invoke {
    NSString *a= [NSString stringWithFormat:@"%@GetDosageForm?UserRoleID=%@",[DataExchange getbaseUrl],self.userRollId];
    
	[self get:a];
}

-(BOOL)handleHttpOK:(NSMutableData *)data {
    
	NSArray* resultsd = [[[[NSString alloc] initWithData:data 
                                                encoding:NSUTF8StringEncoding] autorelease] JSONValue];
    
    
    NSArray *response = [DosageFrm DosageFrmsFromArray:resultsd];
    
	[self.delegate getDosageFrmInvocationDidFinish:self withDosages:response withError:Nil];
	return YES;
}

-(BOOL)handleHttpError:(NSInteger)code {
	[self.delegate getDosageFrmInvocationDidFinish:self 
                                    withDosages:nil
                                      withError:[NSError errorWithDomain:@"Dosage"
                                                                    code:[[self response] statusCode]
                                                                userInfo:[NSDictionary dictionaryWithObject:@"Failed to get dosage details. Please try again later" forKey:@"message"]]];
	return YES;
}

@end
