//
//  GetVitalsInvocation.m
//  mCura
//
//  Created by Aakash Chaudhary on 15/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "JSON.h"
#import "GetVitalsInvocation.h"
#import "PatVital.h"
#import "PatVital+Parse.h"

@implementation GetVitalsInvocation
@synthesize userRoleId;

-(void)dealloc {	
	[super dealloc];
}

-(void)invoke {
    NSString *a= [NSString stringWithFormat:@"%@GetVital?UserRoleID=%@",[DataExchange getbaseUrl],self.userRoleId];
	[self get:a];
}

-(BOOL)handleHttpOK:(NSMutableData *)data {
    
	NSArray* resultsd = [[[[NSString alloc] initWithData:data 
                                                encoding:NSUTF8StringEncoding] autorelease] JSONValue];
    NSArray *response = [PatVital PatVitalsFromArray:resultsd];
	[self.delegate GetVitalsInvocationDidFinish:self withVitals:response withError:nil];
	return YES;
}

-(BOOL)handleHttpError:(NSInteger)code {
	[self.delegate GetVitalsInvocationDidFinish:self
                                 withVitals:nil
                                        withError:[NSError errorWithDomain:@"vitals"
                                                                      code:[[self response] statusCode]
                                                                  userInfo:[NSDictionary dictionaryWithObject:@"Failed to get Severity details. Please try again later" forKey:@"message"]]];
	return YES;
}

@end
