//
//  GetLabReportInvocation.m
//  mCura
//
//  Created by Aakash Chaudhary on 05/03/12.
//  Copyright (c) 2012 aakash272@gmail.com. All rights reserved.
//

#import "GetLabReportInvocation.h"
#import "JSON.h"
#import "LabReport.h"
#import "LabReport+Parse.h"

@implementation GetLabReportInvocation
@synthesize userRoleId,recordId;

-(void)dealloc {	
	[super dealloc];
}

-(void)invoke {
    NSString *a= [NSString stringWithFormat:@"%@GetLabReport?UserRoleID=%@&RecordId=%@",[DataExchange getbaseUrl],self.userRoleId,self.recordId];
    
	[self get:a];
}

-(BOOL)handleHttpOK:(NSMutableData *)data {
    NSString* str = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    
    if([str rangeOfString:@".pdf"].location!=NSNotFound || [str rangeOfString:@".doc"].location!=NSNotFound || [str rangeOfString:@".docx"].location!=NSNotFound){
        NSArray* resultsd = [[[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease] componentsSeparatedByString:@","];
        str = [resultsd objectAtIndex:0];
        str = [str stringByReplacingOccurrencesOfString:@"\\/" withString:@"/"];
        str = [str stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        str = [str stringByReplacingOccurrencesOfString:@"[" withString:@""];
        str = [str stringByReplacingOccurrencesOfString:@"]" withString:@""];
        [self.delegate GetLabReportInvocationDidFinish:self withDocument:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@/%@",[DataExchange getDomainUrl],str]] withError:nil];
        return YES;
    }
    else{
        NSArray* resultsd = [[[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease] componentsSeparatedByString:@","];
        str = [resultsd objectAtIndex:0];
        str = [str stringByReplacingOccurrencesOfString:@"\\/" withString:@"/"];
        str = [str stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        str = [str stringByReplacingOccurrencesOfString:@"[" withString:@""];
        str = [str stringByReplacingOccurrencesOfString:@"]" withString:@""];
        NSMutableArray*temp = [[NSMutableArray alloc] init];
        [temp addObject:str];
        [self.delegate GetLabReportInvocationDidFinish:self withLabReports:temp withError:nil];
        return YES;
    }
}

-(BOOL)handleHttpError:(NSInteger)code {
	[self.delegate GetLabReportInvocationDidFinish:self 
                                        withLabReports:nil
                                           withError:[NSError errorWithDomain:@"LabReports"
                                                                         code:[[self response] statusCode]
                                                                     userInfo:[NSDictionary dictionaryWithObject:@"Failed to get Lab Reports List. Please try again later" forKey:@"message"]]];
	return YES;
}
@end
