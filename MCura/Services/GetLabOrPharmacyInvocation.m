//
//  GetLabOrPharmacyInvocation.m
//  3GMDoc
//
//  Created by Aakash Chaudhary on 15/02/12.
//  Copyright (c) 2012 aakash272@gmail.com. All rights reserved.
//

#import "GetLabOrPharmacyInvocation.h"
#import "JSON.h"
#import "LabOrder.h"
#import "PharmacyOrder.h"
#import "LabOrder+Parse.h"
#import "PharmacyOrder+Parse.h"

@implementation GetLabOrPharmacyInvocation
@synthesize userRoleId,labOrPharmacy,recordId;

-(void)dealloc {	
	[super dealloc];
}

-(void)invoke {
    NSString *a;
    if(labOrPharmacy)
        a = [NSString stringWithFormat:@"%@GetLabOrderOne?UserRoleID=%@&RecordId=%@",[DataExchange getbaseUrl],self.userRoleId,self.recordId];
    else
        a = [NSString stringWithFormat:@"%@GetPharmacyOrder?UserRoleID=%@&RecordId=%@",[DataExchange getbaseUrl],self.userRoleId,self.recordId];
	[self get:a];
}

-(BOOL)handleHttpOK:(NSMutableData *)data {
    
	NSArray* resultsd = [[[[NSString alloc] initWithData:data 
                                                encoding:NSUTF8StringEncoding] autorelease] JSONValue];
    if(labOrPharmacy){
        if(resultsd.count!=0){
            LabOrder* response = [LabOrder LabOrderFromDictionary:(NSDictionary*)resultsd ];
            [self.delegate GetLabOrPharmacyInvocationDidFinish:self withLabOrder:response withError:Nil];
            return YES;
        }
        else{
            [self.delegate GetLabOrPharmacyInvocationDidFinish:self withLabOrder:nil withError:[NSError errorWithDomain:@"LabOrder" code:[[self response] statusCode] userInfo:[NSDictionary dictionaryWithObject:@"Failed to get LabOrder details. Please try again later" forKey:@"message"]]];
            return YES;
        }
    }
    else{
        if([resultsd isKindOfClass:[NSDictionary class]]){
            PharmacyOrder* response = [PharmacyOrder PharmacyOrderFromDictionary:(NSDictionary*)resultsd];
            [self.delegate GetLabOrPharmacyInvocationDidFinish:self withPharmacyOrder:[[[NSArray alloc] initWithObjects:response, nil] autorelease]withError:Nil];
            return YES;
        }
        else if(resultsd.count!=0){
            NSArray* response = [PharmacyOrder PharmacyOrderFromArray:resultsd];
            [self.delegate GetLabOrPharmacyInvocationDidFinish:self withPharmacyOrder:response withError:Nil];
            return YES;
        }
        else{
            [self.delegate GetLabOrPharmacyInvocationDidFinish:self withPharmacyOrder:nil withError:[NSError errorWithDomain:@"LabOrder" code:[[self response] statusCode] userInfo:[NSDictionary dictionaryWithObject:@"Failed to get PharmacyOrder details. Please try again later" forKey:@"message"]]];
            return YES;
        }
    }
	
}

-(BOOL)handleHttpError:(NSInteger)code {
    if(labOrPharmacy)
        [self.delegate GetLabOrPharmacyInvocationDidFinish:self 
                                          withLabOrder:nil
                                                 withError:[NSError errorWithDomain:@"LabOrder"
                                                                               code:[[self response] statusCode]
                                                                           userInfo:[NSDictionary dictionaryWithObject:@"Failed to get LabOrder details. Please try again later" forKey:@"message"]]];
    else
        [self.delegate GetLabOrPharmacyInvocationDidFinish:self 
                                          withPharmacyOrder:nil
                                                 withError:[NSError errorWithDomain:@"PharmacyOrder"
                                                                               code:[[self response] statusCode]
                                                                           userInfo:[NSDictionary dictionaryWithObject:@"Failed to get PharmacyOrder details. Please try again later" forKey:@"message"]]];
	return YES;
}

@end
