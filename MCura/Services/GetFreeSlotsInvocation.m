//
//  GetFreeSlotsInvocation.m
//  mCura
//
//  Created by Aakash Chaudhary on 11/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GetFreeSlotsInvocation.h"
#import "JSON.h"
#import "Appointment.h"
#import "Appointment+Parse.h"

@implementation GetFreeSlotsInvocation
@synthesize userRoleId,timeTableId;

-(void)dealloc {	
	[super dealloc];
}

-(void)invoke {
    NSString *a= [NSString stringWithFormat:@"%@GetFreeAppointments?time_table_id=%@&UserRoleID=%@",[DataExchange getbaseUrl],self.timeTableId,self.userRoleId];
	[self get:a];
}

-(BOOL)handleHttpOK:(NSMutableData *)data {
    
	NSArray* resultsd = [[[[NSString alloc] initWithData:data 
                                                encoding:NSUTF8StringEncoding] autorelease] JSONValue];
    
    
    NSArray *response = [Appointment AppointmentsFromArray:resultsd];
    
	[self.delegate getFreeSlotsInvocationDidFinish:self withAppointments:response withError:nil];
	return YES;
}

-(BOOL)handleHttpError:(NSInteger)code {
	[self.delegate getFreeSlotsInvocationDidFinish:self
                                  withAppointments:nil
                                         withError:[NSError errorWithDomain:@"Current Visit"
                                                                       code:[[self response] statusCode]
                                                                   userInfo:[NSDictionary dictionaryWithObject:@"Failed to get Current Visit. Please try again later" forKey:@"message"]]];
	return YES;
}

@end
