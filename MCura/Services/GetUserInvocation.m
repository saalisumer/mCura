//
//  GetUserInvocation.m
//  3GMDoc

#import "GetUserInvocation.h"
#import "JSON.h"

@implementation GetUserInvocation

@synthesize userRollId,async;

-(void)dealloc {	
	[super dealloc];
}

-(void)invoke {
    NSString *a= [NSString stringWithFormat:@"%@GetUser?UserRoleID=%@",[DataExchange getbaseUrl],self.userRollId];
	[self get:a];
}

-(BOOL)handleHttpOK:(NSMutableData *)data {
    NSArray* resultsd = [[[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease] JSONValue];
    NSArray* response = [UserDetail userDetailsFromArray:resultsd];
    if(!async){
        [self.delegate getUserInvocationDidFinish:self withResponse:response withError:Nil];
    }
    else{
        [self.delegate getAsyncUserInvocationDidFinish:self withResponse:response withError:nil];
    }
    return YES;
}

-(BOOL)handleHttpError:(NSInteger)code {
	[self.delegate getUserInvocationDidFinish:self 
                                  withResponse:nil
                                     withError:[NSError errorWithDomain:@"User"
                                                                   code:[[self response] statusCode]
                                                               userInfo:[NSDictionary dictionaryWithObject:@"Failed to get user details. Please try again later" forKey:@"message"]]];
	return YES;
}



@end
