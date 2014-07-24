//
//  GetNotesInvocation.m
//  mCura
//
//  Created by Aakash Chaudhary on 17/03/12.
//  Copyright (c) 2012 aakash272@gmail.com. All rights reserved.
//

#import "JSON.h"
#import "GetNotesInvocation.h"
#import "proAlertView.h"

@implementation GetNotesInvocation
@synthesize userRoleId,recordId;

-(void)dealloc {	
	[super dealloc];
}

-(void)invoke {
    NSString *a= [NSString stringWithFormat:@"%@GetRecord?UserRoleID=%@&RecordId=%@",[DataExchange getbaseUrl],self.userRoleId,self.recordId];
	[self get:a];
}

-(BOOL)handleHttpOK:(NSMutableData *)data {
    NSString* temp;
    NSMutableArray *response = [[NSMutableArray alloc] init];
	NSArray* resultsd = [[[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease] componentsSeparatedByString:@","];
    for (int i=0; i<resultsd.count; i++) {
        temp = [resultsd objectAtIndex:i];
        temp = [temp stringByReplacingOccurrencesOfString:@"\\/" withString:@"/"];
        temp = [temp stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        if([temp rangeOfString:@".png"].location!=NSNotFound || [temp rangeOfString:@".jpg"].location!=NSNotFound){
            UIImage* img = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@/%@",[DataExchange getDomainUrl],temp]]]];
            if(img!=nil){
                [response addObject:img];
            }
            [img release];
        }
        else if([temp rangeOfString:@".txt"].location!=NSNotFound){
            NSString* text = [[NSString alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@/%@",[DataExchange getDomainUrl],temp]]] encoding:NSUTF8StringEncoding];
            [response addObject:text];
            [text release];
        }
        else if([temp rangeOfString:@".mov"].location!=NSNotFound){
            NSURL* img = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/%@",[DataExchange getDomainUrl],temp]];
            [response addObject:img];
            [img release];
        }else if([temp rangeOfString:@".pdf"].location!=NSNotFound || [temp rangeOfString:@".doc"].location!=NSNotFound  || [temp rangeOfString:@".docx"].location!=NSNotFound){
            NSMutableArray* tempArr = [[NSMutableArray alloc] init];
            [tempArr addObject:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@/%@",[DataExchange getDomainUrl],temp]]];
            [response addObject:tempArr];
        }
    }
	[self.delegate GetNotesInvocationDidFinish:self withNotesDataArray:response withError:nil];
	return YES;
}

-(BOOL)handleHttpError:(NSInteger)code {
	[self.delegate GetNotesInvocationDidFinish:self
                            withNotesDataArray:nil
                                     withError:[NSError errorWithDomain:@"Notes"
                                                                    code:[[self response] statusCode]
                                                                userInfo:[NSDictionary dictionaryWithObject:@"Failed to get Notes. Please try again later" forKey:@"message"]]];
	return YES;
}

@end

