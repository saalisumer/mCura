//
//  GetLabInvocation.m
//  3GMDoc
//
//  Created by Aakash Chaudhary on 07/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GetLabInvocation.h"
#import "JSON.h"
#import "Lab.h"
#import "Lab+Parse.h"
#import "SubTenant.h"
#import "SubTenant+Parse.h"

@implementation GetLabInvocation

@synthesize userRollId,schedulesId,type;

-(void)dealloc {	
	[super dealloc];
}

-(void)invoke {
    if(type==1){
        NSString *a= [NSString stringWithFormat:@"%@GetLab?UserRoleID=%@&SchedulesID=%@",[DataExchange getbaseUrl],self.userRollId,self.schedulesId];
        
        [self get:a];
    }
    else{
        NSString *a= [NSString stringWithFormat:@"%@Schedule_GetFacility?UserRoleId=%@",[DataExchange getbaseUrl],self.userRollId];
        
        [self get:a];
    }
}

-(BOOL)handleHttpOK:(NSMutableData *)data {
    if(type==1){
        NSArray* resultsd = [[[[NSString alloc] initWithData:data
                                                    encoding:NSUTF8StringEncoding] autorelease] JSONValue];
        
        NSArray *response = [Lab LabsFromArray:resultsd];
        
        [self.delegate getLabInvocationDidFinish:self withLabs:response withError:Nil];
    }else{
        NSArray* resultsd = [[[[NSString alloc] initWithData:data
                                                    encoding:NSUTF8StringEncoding] autorelease] JSONValue];
        NSArray *response = [SubTenant subTenantsFromArray:resultsd];
        [self.delegate getLabInvocationDidFinish:self withLabs:[response retain] withError:Nil];
    }
	return YES;
}

-(BOOL)handleHttpError:(NSInteger)code {
	[self.delegate getLabInvocationDidFinish:self 
                                    withLabs:nil
                                        withError:[NSError errorWithDomain:@"Lab"
                                                                      code:[[self response] statusCode]
                                                                  userInfo:[NSDictionary dictionaryWithObject:@"Failed to get Lab details. Please try again later" forKey:@"message"]]];
	return YES;
}

@end
