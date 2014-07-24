//
//  GetLabGroupTestInvocation.m
//  3GMDoc
//
//  Created by Aakash Chaudhary on 15/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GetLabGroupTestInvocation.h"
#import "JSON.h"
#import "LabGroupTest.h"
#import "LabGroupTest+Parse.h"

@implementation GetLabGroupTestInvocation
@synthesize userRoleId,packageId;

-(void)dealloc {	
	[super dealloc];
}

-(void)invoke {
    NSString *a= [NSString stringWithFormat:@"%@GetLabGrpTest?PackageId=%@&UserRoleID=%@",[DataExchange getbaseUrl],self.packageId,self.userRoleId];
    
	[self get:a];
}

-(BOOL)handleHttpOK:(NSMutableData *)data {
    
	NSArray* resultsd = [[[[NSString alloc] initWithData:data 
                                                encoding:NSUTF8StringEncoding] autorelease] JSONValue];
    
    
    NSArray *response = [LabGroupTest LabGroupTestFromArray:resultsd];
    
	[self.delegate GetLabGroupTestInvocationDidFinish:self withLabGroupTests:response withPackageId:self.packageId withError:nil];
	return YES;
}

-(BOOL)handleHttpError:(NSInteger)code {
	[self.delegate GetLabGroupTestInvocationDidFinish:self 
                                    withLabGroupTests:nil
                                        withPackageId:self.packageId
                                            withError:[NSError errorWithDomain:@"LabGroups"
                                                                                  code:[[self response] statusCode]
                                                                              userInfo:[NSDictionary dictionaryWithObject:@"Failed to get Lab Groups. Please try again later" forKey:@"message"]]];
	return YES;
}

@end
