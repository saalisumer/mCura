//
//  GetPatComplaints.m
//  3GMDoc
//
//  Created by Aakash Chaudhary on 05/02/12.
//  Copyright (c) 2012 aakash272@gmail.com. All rights reserved.
//

#import "JSON.h"
#import "GetPatComplaints.h"
#import "PatientComplaint.h"
#import "PatientComplaint+Parse.h"

@implementation GetPatComplaints
@synthesize userRoleId,RecordId;

-(void)dealloc {	
	[super dealloc];
}

-(void)invoke {
    NSString *a= [NSString stringWithFormat:@"%@GetPatCompliant?UserRoleID=%@&RecordId=%@",[DataExchange getbaseUrl],self.userRoleId, self.RecordId];
	[self get:a];
}

-(BOOL)handleHttpOK:(NSMutableData *)data {
    
	NSArray* resultsd = [[[[NSString alloc] initWithData:data
                                                encoding:NSUTF8StringEncoding] autorelease] JSONValue];
    
    NSArray *response = [PatientComplaint PatientComplaintsFromArray:resultsd];
    
	[self.delegate getPatComplaintsInvocationDidFinish:self withPatComplaints:response withError:Nil];
	return YES;
}

-(BOOL)handleHttpError:(NSInteger)code {
	[self.delegate getPatComplaintsInvocationDidFinish:self
                                    withPatComplaints:nil
                                     withError:[NSError errorWithDomain:@"Brand"
                                                                   code:[[self response] statusCode]
                                                               userInfo:[NSDictionary dictionaryWithObject:@"Failed to get Patient Complaints details. Please try again later" forKey:@"message"]]];
	return YES;
}

@end
