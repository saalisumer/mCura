//
//  GetMedRecNatureInvocation.m
//  mCura
//
//  Created by Aakash Chaudhary on 27/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "JSON.h"
#import "GetMedRecNatureInvocation.h"
#import "MedRecNature.h"
#import "MedRecNature+Parse.h"

@implementation GetMedRecNatureInvocation

-(void)dealloc {	
	[super dealloc];
}

-(void)invoke {
    NSString *a= [NSString stringWithFormat:@"%@GetMedicalRecordNature",[DataExchange getbaseUrl]];
	[self get:a];
}

-(BOOL)handleHttpOK:(NSMutableData *)data {
    NSArray* resultsd = [[[[NSString alloc] initWithData:data 
                                                encoding:NSUTF8StringEncoding] autorelease] JSONValue];
    
    NSArray *response = [MedRecNature MedRecNatureFromArray:resultsd];
    
	[self.delegate GetMedRecNatureInvocationDidFinish:self withMedRecNatureArray:response withError:nil];
	return YES;
}

-(BOOL)handleHttpError:(NSInteger)code {
	[self.delegate GetMedRecNatureInvocationDidFinish:self
                            withMedRecNatureArray:nil
                                     withError:[NSError errorWithDomain:@"MedRecord nature"
                                                                   code:[[self response] statusCode]
                                                               userInfo:[NSDictionary dictionaryWithObject:@"Failed to get MedRecord nature. Please try again later" forKey:@"message"]]];
	return YES;
}

@end
