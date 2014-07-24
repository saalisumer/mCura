//
//  GetLoginInvocation.m
//  3GMDoc

#import "GetLoginInvocation.h"
#import "JSON.h"
#import "Response.h"
#import "Response+Parse.h"

@interface GetLoginInvocation (private)
@end

@implementation GetLoginInvocation

@synthesize username, password, type;

-(void)dealloc {	
	[super dealloc];
}

-(void)invoke {
    NSString *a = nil;
    if([self.type integerValue]!=pinCase){
        a= [NSString stringWithFormat:@"%@/health_dev.svc/Json/GetLogin?UseraName=%@&PWD=%@",mCuraBaseUrl,self.username, self.password];
        
    }
    else{
        a= [NSString stringWithFormat:@"%@/health_dev.svc/Json/GetLoginpin?PIN=%@&TabID=%@",mCuraBaseUrl,self.username, self.password];
        NSLog(@"%@",a);
    }
	[self get:a];
}

-(BOOL)handleHttpOK:(NSMutableData *)data {
    
	NSArray* resultsd = [[[[NSString alloc] initWithData:data 
                                                encoding:NSUTF8StringEncoding] autorelease] JSONValue];
	
	NSArray* response = [Response responsesFromArray:resultsd];
    
	[self.delegate getLoginInvocationDidFinish:self withResponse:response withError:Nil];
	return YES;
}

-(BOOL)handleHttpError:(NSInteger)code {
	[self.delegate getLoginInvocationDidFinish:self 
                                    withResponse:nil
                                      withError:[NSError errorWithDomain:@"Response"
                                                                    code:[[self response] statusCode]
                                                                userInfo:[NSDictionary dictionaryWithObject:@"Failed to get response. Please try again later" forKey:@"message"]]];
	return YES;
}

@end
