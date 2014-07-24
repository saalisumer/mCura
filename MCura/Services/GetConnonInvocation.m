//
//  GetConnonInvocation.m
//  3GMDoc

#import "GetConnonInvocation.h"
#import "JSON.h"
#import "Nature.h"
#import "Nature+Parse.h"

@implementation GetConnonInvocation

@synthesize type;

-(void)dealloc {	
	[super dealloc];
}

-(void)invoke {
    NSString *a = nil;
    
    if([self.type isEqualToString:@"1"]){
        a= [NSString stringWithFormat:@"%@getAppNature",[DataExchange getbaseUrl]];
    }
    else{
        a= [NSString stringWithFormat:@"%@GetGender",[DataExchange getbaseUrl]];
    }
	[self get:a];
}

-(BOOL)handleHttpOK:(NSMutableData *)data {
    
	NSArray* resultsd = [[[[NSString alloc] initWithData:data 
                                                encoding:NSUTF8StringEncoding] autorelease] JSONValue];
    
    
    NSArray *response = nil;
    
    if([self.type isEqualToString:@"1"]){
    
         response = [Nature NaturesFromArray:resultsd];
    }
    else{
    
    }
        
    
	[self.delegate getConnonInvocationDidFinish:self withResults:response withError:Nil];
	return YES;
}

-(BOOL)handleHttpError:(NSInteger)code {
	[self.delegate getConnonInvocationDidFinish:self 
                                    withResults:nil
                                       withError:[NSError errorWithDomain:@"Nature"
                                                                     code:[[self response] statusCode]
                                                                 userInfo:[NSDictionary dictionaryWithObject:@"Failed to get nature details. Please try again later" forKey:@"message"]]];
	return YES;
}

@end

