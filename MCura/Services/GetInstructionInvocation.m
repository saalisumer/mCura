//
//  GetInstructionInvocation.m
//  3GMDoc
//
//  Created by sandeep agrawal on 18/01/12.
//  Copyright (c) 2012 student.san1986@gmail.com. All rights reserved.
//

#import "GetInstructionInvocation.h"
#import "JSON.h"
#import "Instruction.h"
#import "Instruction+Parse.h"

@implementation GetInstructionInvocation

@synthesize userRollId;

-(void)dealloc {	
	[super dealloc];
}

-(void)invoke {
    NSString *a= [NSString stringWithFormat:@"%@GetDosageInstructions?UserRoleID=%@",[DataExchange getbaseUrl],self.userRollId];
    
	[self get:a];
}

-(BOOL)handleHttpOK:(NSMutableData *)data {
    
	NSArray* resultsd = [[[[NSString alloc] initWithData:data 
                                                encoding:NSUTF8StringEncoding] autorelease] JSONValue];
    
    
    NSArray *response = [Instruction InstructionsFromArray:resultsd];
    
	[self.delegate getInstructionInvocationDidFinish:self withInvocations:response withError:Nil];
	return YES;
}

-(BOOL)handleHttpError:(NSInteger)code {
	[self.delegate getInstructionInvocationDidFinish:self 
                                    withInvocations:nil
                                      withError:[NSError errorWithDomain:@"Instruction"
                                                                    code:[[self response] statusCode]
                                                                userInfo:[NSDictionary dictionaryWithObject:@"Failed to get instruction details. Please try again later" forKey:@"message"]]];
	return YES;
}

@end
