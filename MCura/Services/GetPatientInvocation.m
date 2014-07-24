//
//  GetPatientInvocation.m
//  3GMDoc

#import "GetPatientInvocation.h"
#import "JSON.h"
#import "Patient.h"
#import "Patient+Parse.h"

@implementation GetPatientInvocation

@synthesize userRollId, searchkey,sub_tenant_id;

-(void)dealloc {	
	[super dealloc];
}

-(void)invoke {
    NSString *a= [NSString stringWithFormat:@"%@SearchPatient?UserRoleID=%@&Searchkey=%@&sub_tenant_id=%@",[DataExchange getbaseUrl],self.userRollId, self.searchkey, self.sub_tenant_id];
    
	[self get:a];
}

-(BOOL)handleHttpOK:(NSMutableData *)data {
    
	NSArray* resultsd = [[[[NSString alloc] initWithData:data
                                                encoding:NSUTF8StringEncoding] autorelease] JSONValue];
        
    
    NSArray *response = [Patient PatientsFromArray:resultsd];
    
	[self.delegate getPatientInvocationDidFinish:self withPatients:response withError:Nil];
	return YES;
}

-(BOOL)handleHttpError:(NSInteger)code {
	[self.delegate getPatientInvocationDidFinish:self 
                                     withPatients:nil
                                        withError:[NSError errorWithDomain:@"Patient"
                                                                      code:[[self response] statusCode]
                                                                  userInfo:[NSDictionary dictionaryWithObject:@"Failed to get patient details. Please try again later" forKey:@"message"]]];
	return YES;
}

@end
