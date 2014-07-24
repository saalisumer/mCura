//
//  GetPatientHealthInvocation.m
//  mCura
//
//  Created by Aakash Chaudhary on 02/04/12.
//  Copyright (c) 2012 aakash272@gmail.com. All rights reserved.
//

#import "GetPatientHealthInvocation.h"
#import "JSON.h"
#import "PatHealthConType.h"
#import "PatHealthCondition.h"
#import "PatHealthCondition+Parse.h"
#import "PatHealthConType+Parse.h"

@implementation GetPatientHealthInvocation

@synthesize userRollId, conditionOrType;

-(void)dealloc {	
	[super dealloc];
}

-(void)invoke {
    if(conditionOrType){
        NSString *a= [NSString stringWithFormat:@"%@GetHealthHConditions?UserRoleID=%@",[DataExchange getbaseUrl],self.userRollId];
    
        [self get:a];
    }
    else{
        NSString *a= [NSString stringWithFormat:@"%@GetHealthConditionType?UserRoleID=%@",[DataExchange getbaseUrl],self.userRollId];
        
        [self get:a];
    }
}

-(BOOL)handleHttpOK:(NSMutableData *)data {
    
	NSArray* resultsd = [[[[NSString alloc] initWithData:data 
                                                encoding:NSUTF8StringEncoding] autorelease] JSONValue];
    if(conditionOrType){
        NSArray *response = [PatHealthCondition PatHealthsFromArray:resultsd];
        [self.delegate getPatientHealthConditionInvocationDidFinish:self withHealthConditions:response withError:Nil];
        return YES;
    }
    else{
        NSArray *response = [PatHealthConType PatHealthsFromArray:resultsd];
        [self.delegate getPatientHealthConditionTypeInvocationDidFinish:self withHealthConditionTypes:response withError:Nil];
        return YES;
    }
}

-(BOOL)handleHttpError:(NSInteger)code {
    if(conditionOrType)
        [self.delegate getPatientHealthConditionInvocationDidFinish:self withHealthConditions:nil withError:[NSError errorWithDomain:@"Health"code:[[self response] statusCode] userInfo:[NSDictionary dictionaryWithObject:@"Failed to get instruction details. Please try again later" forKey:@"message"]]];
    else
        [self.delegate getPatientHealthConditionTypeInvocationDidFinish:self withHealthConditionTypes:nil withError:[NSError errorWithDomain:@"Health"code:[[self response] statusCode] userInfo:[NSDictionary dictionaryWithObject:@"Failed to get instruction details. Please try again later" forKey:@"message"]]];
	return YES;
}

@end
