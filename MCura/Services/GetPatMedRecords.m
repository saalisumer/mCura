//
//  GetPatMedRecords.m
//  3GMDoc
//  Created by Aakash Chaudhary on 05/02/12.
//  Copyright (c) 2012 aakash272@gmail.com. All rights reserved.
//

#import "GetPatMedRecords.h"
#import "JSON.h"
#import "PatMedRecords.h"
#import "PatMedRecords+Parse.h"
#import "PatAllergy.h"
#import "PatAllergy+Parse.h"
#import "PatHealth.h"
#import "PatHealth+Parse.h"

@implementation GetPatMedRecords
@synthesize UserRoleID,MRNO,subTenantId;

-(void)dealloc {
	[super dealloc];
}

-(void)invoke {
    NSString *a= [NSString stringWithFormat:@"%@GetPatient?UserRoleID=%@&MRNO=%@&sub_tenant_id=%@",[DataExchange getbaseUrl],self.UserRoleID, self.MRNO, self.subTenantId];
	[self get:a];
}

-(BOOL)handleHttpOK:(NSMutableData *)data {
	NSArray* resultsd = [[[[NSString alloc] initWithData:data 
                                                encoding:NSUTF8StringEncoding] autorelease] JSONValue];
    NSDictionary* dict = [(NSDictionary*)resultsd objectForKey:@"PatientAddress"];
    NSNumber* areaId = [dict objectForKey:@"AreaId"];
    if ([areaId isKindOfClass:[NSNull class]]) {
        areaId = [NSNumber numberWithInt:0];
    }
    NSString *urlString = [NSString stringWithFormat:@"http://%@GetCity_Area?AreaId=%d",[DataExchange getbaseUrl],[areaId integerValue]];
    // setting up the request object now
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"GET"];
    [request setAllHTTPHeaderFields:[[NSDictionary alloc] initWithObjects:[[NSArray alloc] initWithObjects:@"application/json",@"utf-8",[DataExchange getDomainUrl],@"0", nil] forKeys:[[NSArray alloc] initWithObjects:@"Content-Type",@"charset",@"Host",@"Content-Length", nil]]];
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	NSString *response= [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding];
    if([[response JSONValue] count]>0){
        NSString* city = [[[response JSONValue] objectAtIndex:0] objectForKey:@"City"];
        [self.delegate getPatMedRecordsInvocationDidFinish:self withPatAddressCity:city withError:nil];
    }
    
    NSArray *responseMedRec = [PatMedRecords PatMedRecordsFromArray:resultsd];
    NSArray* responseAllergies = [PatAllergy PatAllergysFromArray:resultsd];
    NSArray* responseHealth = [PatHealth PatHealthsFromArray:resultsd];
    
	[self.delegate getPatMedRecordsInvocationDidFinish:self withPatMedRecords:responseMedRec withError:Nil];
    [self.delegate getPatAllergyInvocationDidFinish:self withPatAllergies:responseAllergies withError:nil];
    [self.delegate getPatHealthInvocationDidFinish:self withPatHealthRecords:responseHealth withError:nil];
	return YES;
}

-(BOOL)handleHttpError:(NSInteger)code {
	[self.delegate getPatMedRecordsInvocationDidFinish:self withPatMedRecords:nil withError:[NSError errorWithDomain:@"Medical Records" code:[[self response] statusCode] userInfo:[NSDictionary dictionaryWithObject:@"Failed to get Patient Medical Records. Please try again later" forKey:@"message"]]];
    [self.delegate getPatAllergyInvocationDidFinish:self withPatAllergies:nil withError:[NSError errorWithDomain:@"Medical Records" code:[[self response] statusCode] userInfo:[NSDictionary dictionaryWithObject:@"Failed to get Patient Medical Records. Please try again later" forKey:@"message"]]];
    [self.delegate getPatHealthInvocationDidFinish:self withPatHealthRecords:nil withError:[NSError errorWithDomain:@"Medical Records" code:[[self response] statusCode] userInfo:[NSDictionary dictionaryWithObject:@"Failed to get Patient Medical Records. Please try again later" forKey:@"message"]]];
	return YES;
}

@end
