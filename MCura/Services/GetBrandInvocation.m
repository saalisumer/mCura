//
//  GetBrandInvocation.m
//  3GMDoc
//
//  Created by Aakash Chaudhary on 02/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import "JSON.h"
#import "GetBrandInvocation.h"
#import "Brand.h"
#import "Brand+Parse.h"

@implementation GetBrandInvocation
@synthesize userRollId,genericId;

-(void)dealloc {	
	[super dealloc];
}

-(void)invoke {
    NSString *a= [NSString stringWithFormat:@"%@DrugIndex_Drug?genericid=%@",[DataExchange getbaseUrl],self.genericId];
    [self setUrl:a];

	[self get:a];
}

-(BOOL)handleHttpOK:(NSMutableData *)data {
    
	NSDictionary* dict = [[[[NSString alloc] initWithData:data 
                                                encoding:NSUTF8StringEncoding] autorelease] JSONValue];
    NSArray* resultsd = [dict objectForKey:@"DrugsBrand"];
    
    // refactor this
    [[NSUserDefaults standardUserDefaults] setValue:[dict objectForKey:@"Crossreaction"] forKey:@"Crossreaction"];
    [[NSUserDefaults standardUserDefaults] setValue:[dict objectForKey:@"Modeofaction"] forKey:@"Modeofaction"];
    [[NSUserDefaults standardUserDefaults] setValue:[dict objectForKey:@"Safety"] forKey:@"Safety"];
    [[NSUserDefaults standardUserDefaults] setValue:[dict objectForKey:@"Sideeffect"] forKey:@"Sideeffect"];
    
    NSArray *response = [Brand BrandsFromArray:resultsd];
	[self.delegate getBrandInvocationDidFinish:self withBrands:response withError:Nil];
	return YES;
}

-(BOOL)handleHttpError:(NSInteger)code {
	[self.delegate getBrandInvocationDidFinish:self withBrands:nil withError:[NSError errorWithDomain:@"Brand" code:[[self response] statusCode] userInfo:[NSDictionary dictionaryWithObject:@"Failed to get brand details. Please try again later" forKey:@"message"]]];
	return YES;
}

@end
