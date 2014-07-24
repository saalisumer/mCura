//
//  GetTabletInvocation.m
//  3GMDoc

#import "GetTabletInvocation.h"
#import "JSON.h"
#import "DeviceDeatils.h"
#import "DeviceDeatils+Parse.h"

@interface GetTabletInvocation (private)
@end

@implementation GetTabletInvocation

@synthesize serialNo;

-(void)dealloc {	
	[super dealloc];
}

-(void)invoke {
    NSString *a= [NSString stringWithFormat:@"%@GetTablet?SerialNo=%@",[DataExchange getbaseUrl],self.serialNo];
	[self get:a];
}

-(BOOL)handleHttpOK:(NSMutableData *)data {
    
	NSArray* resultsd = [[[[NSString alloc] initWithData:data 
													 encoding:NSUTF8StringEncoding] autorelease] JSONValue];
	
	NSArray* deviceDtls = [DeviceDeatils DeviceDeatilsFromArray:resultsd];
        
	[self.delegate getTabletInvocationDidFinish:self withTablets:deviceDtls withError:Nil];
	return YES;
}

-(BOOL)handleHttpError:(NSInteger)code {
	[self.delegate getTabletInvocationDidFinish:self 
									    withTablets:nil
											withError:[NSError errorWithDomain:@"DeviceDetails"
																		  code:[[self response] statusCode]
																	  userInfo:[NSDictionary dictionaryWithObject:@"Failed to get device details. Please try again later" forKey:@"message"]]];
    NSLog(@"code:- %d",code);
    
	return YES;
}

@end
