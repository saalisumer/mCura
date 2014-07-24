//
//  GetStringInvocation.m
//  mCura
//
//  Created by Aakash Chaudhary on 28/06/12.
//  Copyright (c) 2012 aakash272@gmail.com. All rights reserved.
//

#import "GetStringInvocation.h"

@implementation GetStringInvocation
@synthesize identifier,urlString;

-(void)dealloc {	
	[super dealloc];
}

-(void)invoke {
	[self get:self.urlString];
}

-(BOOL)handleHttpOK:(NSMutableData *)data {
	[self.delegate GetStringInvocationDidFinish:self withResponseString:[[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease] withIdentifier:self.identifier withError:nil];
	return YES;
}

-(BOOL)handleHttpError:(NSInteger)code {
	[self.delegate GetStringInvocationDidFinish:nil withResponseString:nil withIdentifier:nil withError:[NSError errorWithDomain:@"withResponseString" code:1 userInfo:[NSDictionary dictionaryWithObject:@"Failed to get MedRecord nature. Please try again later" forKey:@"message"]]];
	return YES;
}

@end
