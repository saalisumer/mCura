//
//  GetSubtenIdInvocation.m
//  3GMDoc
//
//  Created by Aakash Chaudhary on 09/02/12.
//  Copyright (c) 2012 aakash272@gmail.com. All rights reserved.
//

#import "GetSubtenIdInvocation.h"
#import "JSON.h"
#import "SubTenant.h"
#import "SubTenant+Parse.h"

@implementation GetSubtenIdInvocation
@synthesize userRoleId,subTenantId,isSecondService;

-(void)dealloc {	
	[super dealloc];
}

-(void)invoke {
    if(!isSecondService){
        NSString *a= [NSString stringWithFormat:@"%@getSubTenant?userroleid=%@",[DataExchange getbaseUrl],self.userRoleId];
        [self get:a];
    }else{
        NSString *a= [NSString stringWithFormat:@"%@GetSubTenantOne?SubTenantID=%@&userroleid=%@",[DataExchange getbaseUrl],self.subTenantId,self.userRoleId];
        [self get:a];
    }
}

-(BOOL)handleHttpOK:(NSMutableData *)data {
    
	NSArray* resultsd = [[[[NSString alloc] initWithData:data 
                                                encoding:NSUTF8StringEncoding] autorelease] JSONValue];
    
    if(!isSecondService){
        NSArray *response = [SubTenant subTenantsFromArray:resultsd];
        [self.delegate GetSubtenIdInvocationDidFinish:self withSubTenantIds:response withError:Nil];
    }else{
        NSArray *response = [[NSArray alloc] initWithObjects:[SubTenant subTenantsFromDictionary:(NSDictionary*)resultsd], nil];
        [self.delegate GetSubtenIdInvocationDidFinish:self withSubTenantIds:response withError:Nil];
    }
	return YES;
}

-(BOOL)handleHttpError:(NSInteger)code {
	[self.delegate GetSubtenIdInvocationDidFinish:self
                                   withSubTenantIds:nil
                                        withError:[NSError errorWithDomain:@"Severity"
                                                                      code:[[self response] statusCode]
                                                                  userInfo:[NSDictionary dictionaryWithObject:@"Failed to get Severity details. Please try again later" forKey:@"message"]]];
	return YES;
}

@end
