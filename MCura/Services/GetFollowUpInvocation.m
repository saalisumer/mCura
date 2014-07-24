//
//  GetFollowUpInvocation.m
//  3GMDoc
//
//  Created by sandeep agrawal on 18/01/12.
//  Copyright (c) 2012 student.san1986@gmail.com. All rights reserved.
//

#import "GetFollowUpInvocation.h"
#import "JSON.h"
#import "FollowUp.h"
#import "FollowUp+Parse.h"

@implementation GetFollowUpInvocation

@synthesize userRollId;

-(void)dealloc {	
	[super dealloc];
}

-(void)invoke {
    NSString *a= [NSString stringWithFormat:@"%@getPresFollowUp?UserRoleID=%@",[DataExchange getbaseUrl],self.userRollId];
    
	[self get:a];
}

-(BOOL)handleHttpOK:(NSMutableData *)data {
    
	NSArray* resultsd = [[[[NSString alloc] initWithData:data 
                                                encoding:NSUTF8StringEncoding] autorelease] JSONValue];
    
    
    NSArray *response = [FollowUp FollowUpsFromArray:resultsd];
    
	[self.delegate getFollowUpInvocationDidFinish:self withFollows:response withError:Nil];
	return YES;
}

-(BOOL)handleHttpError:(NSInteger)code {
	[self.delegate getFollowUpInvocationDidFinish:self 
                                    withFollows:nil
                                      withError:[NSError errorWithDomain:@"Follow up"
                                                                    code:[[self response] statusCode]
                                                                userInfo:[NSDictionary dictionaryWithObject:@"Failed to get follow up details. Please try again later" forKey:@"message"]]];
	return YES;
}

@end
