//
//  GetLabTestListInvocation.m
//  3GMDoc
//
//  Created by Aakash Chaudhary on 15/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GetLabTestListInvocation.h"
#import "JSON.h"
#import "LabTestList.h"
#import "LabTestList+Parse.h"

@implementation GetLabTestListInvocation
@synthesize userRoleId,labGrpId,packageId;

-(void)dealloc {	
	[super dealloc];
}

-(void)invoke {
    NSString *a= [NSString stringWithFormat:@"%@GetLabTestListByGroup?LabGrpId=%@&UserRoleID=%@",[DataExchange getbaseUrl],self.labGrpId,self.userRoleId];
    
	[self get:a];
}

-(BOOL)handleHttpOK:(NSMutableData *)data {
    
	NSArray* resultsd = [[[[NSString alloc] initWithData:data 
                                                encoding:NSUTF8StringEncoding] autorelease] JSONValue];
    
    
    NSArray *response = [LabTestList LabTestListFromArray:resultsd];
    
	[self.delegate GetLabTestListInvocationDidFinish:self withLabTests:response withPackageId:self.packageId withGroupId:self.labGrpId withError:nil];
	return YES;
}

-(BOOL)handleHttpError:(NSInteger)code {
	[self.delegate GetLabTestListInvocationDidFinish:self withLabTests:nil withPackageId:self.packageId withGroupId:self.labGrpId withError:[NSError errorWithDomain:@"LabTestList" code:[[self response] statusCode] userInfo:[NSDictionary dictionaryWithObject:@"Failed to get Lab Test List. Please try again later" forKey:@"message"]]];
	return YES;
}

@end
