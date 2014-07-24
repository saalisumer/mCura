//
//  GetPatientContactDetail.m
//  mCura
//
//  Created by Aakash Chaudhary on 02/04/12.
//  Copyright (c) 2012 aakash272@gmail.com. All rights reserved.
//

#import "GetPatientContactDetail.h"
#import "JSON.h"
#import "PatientContactDetails.h"
#import "PatientContactDetails+Parse.h"

@implementation GetPatientContactDetail

@synthesize userRollId, contactId;

-(void)dealloc {	
	[super dealloc];
}

-(void)invoke {
    NSString *a= [NSString stringWithFormat:@"%@GetContactDetails?ContactID=%@&UserRoleID=%@",[DataExchange getbaseUrl],self.contactId, self.userRollId];
    
	[self get:a];
}

-(BOOL)handleHttpOK:(NSMutableData *)data {
    
	NSDictionary* resultsd = [[[[NSString alloc] initWithData:data 
                                                encoding:NSUTF8StringEncoding] autorelease] JSONValue];
    
    NSArray *response = [PatientContactDetails PatientContactDetailsFromArray:resultsd];
    
	[self.delegate getPatientContactDetailDidFinish:self withPatients:response withError:Nil];
	return YES;
}

-(BOOL)handleHttpError:(NSInteger)code {
	[self.delegate getPatientContactDetailDidFinish:self 
                                    withPatients:nil
                                       withError:[NSError errorWithDomain:@"Patient"
                                                                     code:[[self response] statusCode]
                                                                 userInfo:[NSDictionary dictionaryWithObject:@"Failed to get patient details. Please try again later" forKey:@"message"]]];
	return YES;
}

@end
