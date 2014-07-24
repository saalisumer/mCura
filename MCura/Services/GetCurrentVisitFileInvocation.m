//
//  GetCurrentVisitFileInvocation.m
//  mCura
//
//  Created by Aakash Chaudhary on 09/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GetCurrentVisitFileInvocation.h"
#import "JSON.h"
#import "DataExchange.h"

@implementation GetCurrentVisitFileInvocation
@synthesize userRoleId,mrNo;

-(void)dealloc {	
	[super dealloc];
}

-(void)invoke {
    NSString *a= [NSString stringWithFormat:@"%@GetCurrentVisit?UserRoleID=%@&Mrno=%@",[DataExchange getbaseUrl],self.userRoleId,self.mrNo];
	[self get:a];
}

-(BOOL)handleHttpOK:(NSMutableData *)data {
    NSString* temp;
    NSMutableArray *response = [[NSMutableArray alloc] init];
	NSArray* resultsd = [[[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease] componentsSeparatedByString:@","];
    for (int i=0; i<resultsd.count; i++) {
        temp = [resultsd objectAtIndex:i];
        temp = [temp stringByReplacingOccurrencesOfString:@"\\/" withString:@"/"];
        temp = [temp stringByReplacingOccurrencesOfString:@"[" withString:@""];
        temp = [temp stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        if([temp rangeOfString:@".png"].location!=NSNotFound || [temp rangeOfString:@".jpg"].location!=NSNotFound){
            UIImage* img = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@/%@",[DataExchange getDomainUrl],temp]]]];
            [response addObject:img];
            [img release];
        }
        else if([temp rangeOfString:@".txt"].location!=NSNotFound){
            NSString* text = [[[NSString alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@/%@",[DataExchange getDomainUrl],temp]]] encoding:NSUTF8StringEncoding] autorelease];
            [response addObject:text];
            [text release];
        }
    }
	[self.delegate GetCurrentVisitFileInvocationDidFinish:self withCurrentVisitFile:[response objectAtIndex:0] withError:nil];
	return YES;
}

-(BOOL)handleHttpError:(NSInteger)code {
	[self.delegate GetCurrentVisitFileInvocationDidFinish:self
                            withCurrentVisitFile:nil
                                     withError:[NSError errorWithDomain:@"Current Visit"
                                                                   code:[[self response] statusCode]
                                                               userInfo:[NSDictionary dictionaryWithObject:@"Failed to get Current Visit. Please try again later" forKey:@"message"]]];
	return YES;
}

@end
