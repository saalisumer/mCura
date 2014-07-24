//
//  GetDoctorReferralInvocation.m
//  mCura
//
//  Created by Aakash Chaudhary on 16/04/12.
//  Copyright (c) 2012 aakash272@gmail.com. All rights reserved.
//

#import "GetDoctorReferralInvocation.h"
#import "JSON.h"
#import "DoctorDetails.h"
#import "DoctorDetails+Parse.h"

@implementation GetDoctorReferralInvocation
@synthesize userRoleId,subTenId;

-(void)dealloc {	
	[super dealloc];
}

-(void)invoke {
    NSString *a= [NSString stringWithFormat:@"%@GetRefrealDoctors?sub_tenant_id=%@&UserRoleID=%@",[DataExchange getbaseUrl],self.subTenId,self.userRoleId];
	[self get:a];
}

-(BOOL)handleHttpOK:(NSMutableData *)data {
    NSArray* resultsd = [[[[NSString alloc] initWithData:data
                                                encoding:NSUTF8StringEncoding] autorelease] JSONValue];
    
    NSArray *response = [DoctorDetails DoctorDetailsFromArray:resultsd];
    
	[self.delegate GetDoctorReferralInvocationDidFinish:self withDoctorReferralArray:response withError:nil];
	return YES;
}

-(BOOL)handleHttpError:(NSInteger)code {
	[self.delegate GetDoctorReferralInvocationDidFinish:self
                                withDoctorReferralArray:nil
                                              withError:[NSError errorWithDomain:@"Current Visit"
                                                                            code:[[self response] statusCode]
                                                                        userInfo:[NSDictionary dictionaryWithObject:@"Failed to get Current Visit. Please try again later" forKey:@"message"]]];
	return YES;
}

@end
