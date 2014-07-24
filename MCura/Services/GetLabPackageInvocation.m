//
//  GetLabPackageInvocation.m
//  3GMDoc
//
//  Created by Aakash Chaudhary on 15/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GetLabPackageInvocation.h"
#import "JSON.h"
#import "LabPackage.h"
#import "LabPackage+Parse.h"

@implementation GetLabPackageInvocation
@synthesize userRoleId,subTenId;

-(void)dealloc {	
	[super dealloc];
}

-(void)invoke {
    NSString *a= [NSString stringWithFormat:@"%@GetLabPackageTest?UserRoleID=%@&SubTenant=%@",[DataExchange getbaseUrl],self.userRoleId,self.subTenId];
    
	[self get:a];
}

-(BOOL)handleHttpOK:(NSMutableData *)data {
    
	NSArray* resultsd = [[[[NSString alloc] initWithData:data 
                                                encoding:NSUTF8StringEncoding] autorelease] JSONValue];
    
    
    NSArray *response = [LabPackage LabPackagesFromArray:resultsd];
    
	[self.delegate GetLabPackageInvocationDidFinish:self withPackages:response withError:nil];
	return YES;
}

-(BOOL)handleHttpError:(NSInteger)code {
	[self.delegate GetLabPackageInvocationDidFinish:self 
                                    withPackages:nil
                                   withError:[NSError errorWithDomain:@"LabPackage"
                                                                 code:[[self response] statusCode]
                                                             userInfo:[NSDictionary dictionaryWithObject:@"Failed to get Lab Packages. Please try again later" forKey:@"message"]]];
	return YES;
}

@end
