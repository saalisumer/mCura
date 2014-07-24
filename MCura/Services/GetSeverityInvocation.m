//
//  GetSeverityInvocation.m
//  3GMDoc
//
//  Created by Aakash Chaudhary on 07/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GetSeverityInvocation.h"
#import "JSON.h"
#import "Severity.h"
#import "Severity+Parse.h"

@implementation GetSeverityInvocation

-(void)dealloc {	
	[super dealloc];
}

-(void)invoke {
    NSString *a= [NSString stringWithFormat:@"%@GetSeverity",[DataExchange getbaseUrl]];
	[self get:a];
}

-(BOOL)handleHttpOK:(NSMutableData *)data {
	NSArray* resultsd = [[[[NSString alloc] initWithData:data 
                                                encoding:NSUTF8StringEncoding] autorelease] JSONValue];
    
    
    NSArray *response = [Severity SeverityFromArray:resultsd];
    
	[self.delegate GetSeverityInvocationDidFinish:self withSeverities:response withError:Nil];
	return YES;
}

-(BOOL)handleHttpError:(NSInteger)code {
	[self.delegate GetSeverityInvocationDidFinish:self 
                                    withSeverities:nil
                                   withError:[NSError errorWithDomain:@"Severity"
                                                                 code:[[self response] statusCode]
                                                             userInfo:[NSDictionary dictionaryWithObject:@"Failed to get Severity details. Please try again later" forKey:@"message"]]];
	return YES;
}

@end
