//
//  GetPharmacyInvocation.m
//  3GMDoc
//
//  Created by sandeep agrawal on 18/01/12.
//  Copyright (c) 2012 student.san1986@gmail.com. All rights reserved.
//

#import "GetPharmacyInvocation.h"
#import "JSON.h"
#import "Pharmacy.h"
#import "Pharmacy+Parse.h"
#import "SubTenant.h"
#import "SubTenant+Parse.h"

@implementation GetPharmacyInvocation

@synthesize userRollId,schedulesID,type;

-(void)dealloc {	
	[super dealloc];
}

-(void)invoke {
    if(type==1){
        NSString *a= [NSString stringWithFormat:@"%@GetPharmacy?UserRoleID=%@&SchedulesID=%@",[DataExchange getbaseUrl],self.userRollId,self.schedulesID];
        [self get:a];
    }
    else{
        NSString *a= [NSString stringWithFormat:@"%@Schedule_GetHospital?UserRoleId=%@",[DataExchange getbaseUrl],self.userRollId];
        [self get:a];
    }
}

-(BOOL)handleHttpOK:(NSMutableData *)data {
    if(type==1){
        NSArray* resultsd = [[[[NSString alloc] initWithData:data
                                                    encoding:NSUTF8StringEncoding] autorelease] JSONValue];
        
        NSArray *response = [Pharmacy PharmacysFromArray:resultsd];
        [self.delegate getPharmacyInvocationDidFinish:self withPharmacys:response withError:Nil];
    }else{
        NSArray* resultsd = [[[[NSString alloc] initWithData:data
                                                    encoding:NSUTF8StringEncoding] autorelease] JSONValue];
        
        NSArray *response = [SubTenant subTenantsFromArray:resultsd];
        [self.delegate getPharmacyInvocationDidFinish:self withPharmacys:response withError:Nil];
    }
	return YES;
}

-(BOOL)handleHttpError:(NSInteger)code {
	[self.delegate getPharmacyInvocationDidFinish:self 
                                    withPharmacys:nil
                                      withError:[NSError errorWithDomain:@"Pharmacy"
                                                                    code:[[self response] statusCode]
                                                                userInfo:[NSDictionary dictionaryWithObject:@"Failed to get pharmacy details. Please try again later" forKey:@"message"]]];
	return YES;
}

@end
