//
//  GetPaientVitalsInvocation.m
//  mCura
//
//  Created by Aakash Chaudhary on 02/04/12.
//  Copyright (c) 2012 aakash272@gmail.com. All rights reserved.
//

#import "GetPaientVitalsInvocation.h"
#import "JSON.h"
#import "PatVital.h"
#import "PatVital+Parse.h"

@implementation GetPaientVitalsInvocation

@synthesize userRollId, mrno;

-(void)dealloc {	
	[super dealloc];
}

-(void)invoke {
    NSString *a= [NSString stringWithFormat:@"%@GetPatVitalRecords?MRNO=%@&UserRoleID=%@",[DataExchange getbaseUrl],self.mrno,self.userRollId];
  //  NSLog(@"%@",a);
	[self get:a];
}

-(BOOL)handleHttpOK:(NSMutableData *)data {
    
	NSArray* resultsd = [[[[NSString alloc] initWithData:data 
                                                encoding:NSUTF8StringEncoding] autorelease] JSONValue];
    
    
    NSArray *response = [PatVital PatVitalsFromArray:resultsd];
    
	[self.delegate getPaientVitalsInvocationDidFinish:self withVitals:response withError:Nil];
	return YES;
}

-(BOOL)handleHttpError:(NSInteger)code {
	[self.delegate getPaientVitalsInvocationDidFinish:self 
                                           withVitals:nil
                                             withError:[NSError errorWithDomain:@"Vital"
                                                                           code:[[self response] statusCode]
                                                                       userInfo:[NSDictionary dictionaryWithObject:@"Failed to get instruction details. Please try again later" forKey:@"message"]]];
	return YES;
}

@end
