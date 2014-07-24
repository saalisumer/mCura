//
//  GetDocAddrOrContInvocation.m
//  mCura
//
//  Created by Aakash Chaudhary on 03/05/12.
//  Copyright (c) 2012 aakash272@gmail.com. All rights reserved.
//

#import "GetDocAddrOrContInvocation.h"
#import "JSON.h"
#import "PatientAddress.h"
#import "PatientAddress+Parse.h"
#import "PatientContactDetails.h"
#import "PatientContactDetails+Parse.h"

@implementation GetDocAddrOrContInvocation
@synthesize userRoleId,addressOrContactId,addressOrContact;

-(void)dealloc {	
	[super dealloc];
}

-(void)invoke {
    if(addressOrContact){
        NSString *a= [NSString stringWithFormat:@"%@GetAddress?AddressID=%@&UserRoleID=%@",[DataExchange getbaseUrl],self.addressOrContactId,self.userRoleId];
        [self get:a];
    }
    else{
        NSString *a= [NSString stringWithFormat:@"%@GetContactDetails?ContactID=%@&UserRoleID=%@",[DataExchange getbaseUrl],self.addressOrContactId,self.userRoleId];
        [self get:a];
    }
}

-(BOOL)handleHttpOK:(NSMutableData *)data {
    NSArray* resultsd = [[[[NSString alloc] initWithData:data
                                                encoding:NSUTF8StringEncoding] autorelease] JSONValue];
    if(addressOrContact){
        NSArray *response = [PatientAddress PatientAddressFromArray:(NSDictionary*)resultsd];
        [self.delegate GetDocAddrInvocationDidFinish:self withDocAddressArray:response withError:nil];
    }
    else{
        NSArray *response = [PatientContactDetails PatientContactDetailsFromArray:(NSDictionary*)resultsd];
        [self.delegate GetDocContInvocationDidFinish:self withDocContactArray:response withError:nil];
    }
	return YES;
}

-(BOOL)handleHttpError:(NSInteger)code {
    if(addressOrContact)
        [self.delegate GetDocAddrInvocationDidFinish:self withDocAddressArray:nil withError:[NSError errorWithDomain:@"Doc address" code:[[self response] statusCode] userInfo:[NSDictionary dictionaryWithObject:@"Failed to get Doc address. Please try again later" forKey:@"message"]]];
    else
        [self.delegate GetDocContInvocationDidFinish:self withDocContactArray:nil withError:[NSError errorWithDomain:@"Doc contact" code:[[self response] statusCode] userInfo:[NSDictionary dictionaryWithObject:@"Failed to get Doc contact. Please try again later" forKey:@"message"]]];
	return YES;
}
@end
