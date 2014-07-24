//
//  PostUploadOrderTextInvocation.m
//  3GMDoc
//
//  Created by Kanav Gupta on 2/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PostUploadOrderTextInvocation.h"
#import "JSON.h"
@interface PostUploadOrderTextInvocation (private)
-(NSString*)body;
@end

@implementation PostUploadOrderTextInvocation
@synthesize AppId, AvlStatusId;

-(void)dealloc {
	[super dealloc];
}
-(void)invoke {
    
    NSString *a= [NSString stringWithFormat:[NSString stringWithFormat:@"http://%@UploadOrderText",[DataExchange getbaseUrl]]];
    
	[self post:a body:[self body]];
}

-(NSString*)body {
    
    NSString *bodyData = [NSString stringWithFormat:@"{\"_Appointments\":{\"AppId\":%@,\"AvlStatusId\":%@,\"FromTime\":\"\",\"TimeTableId\":,\"ToTime\":\"\"},\"UserRoleID\":,\"isMove\":\"true\"}",AppId,AvlStatusId];
    
	return bodyData;
    
}

-(BOOL)handleHttpOK:(NSMutableData *)data {
	
	NSArray* resultsd = [[[[NSString alloc] initWithData:data 
                                                encoding:NSUTF8StringEncoding] autorelease] JSONValue];
	
    if(resultsd){
        // 
    }
	[self.delegate postUploadOrderTextDidFinish:self withError:nil];
	
	return YES;
}

-(BOOL)handleHttpError:(NSInteger)code {
	
	[self.delegate postUploadOrderTextDidFinish:self withError:[NSError errorWithDomain:@"Appointment" code:[[self response] statusCode]
    userInfo:[NSDictionary dictionaryWithObject:@"Post comment failed. Please try again later" forKey:@"message"]]];
	return YES;
}

@end

