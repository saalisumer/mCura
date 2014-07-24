//
//  InsertAppointmentInvocation.m
//  3GMDoc

#import "InsertAppointmentInvocation.h"
#import "JSON.h"
#import "Patient.h"
#import "proAlertView.h"

@interface InsertAppointmentInvocation (private)
-(NSString*)body;
@end

@implementation InsertAppointmentInvocation

@synthesize AppId, AvlStatusId, mrno, userRollId, othDetails,currentStatusId,AppNatureId;

-(void)dealloc {
	[super dealloc];
}

-(void)invoke {
    NSString *a= [NSString stringWithFormat:@"%@InsertAppointments",[DataExchange getbaseUrl]];
	[self post:a body:[self body]];
}

-(NSString*)body {
    NSString *bodyData =[NSString stringWithFormat:@"{\"_Appointments\":{\"AppId\":%@,\"AvlStatusId\":%@,\"appbookings\":{\"AppNatureId\":%@,\"CurrentStatusId\":%@,\"Mrno\":%@,\"Others\":\"%@\"}},\"UserRoleID\":%@}",self.AppId,self.AvlStatusId,self.AppNatureId,self.currentStatusId,self.mrno,self.othDetails,self.userRollId];
    return bodyData;
}

-(BOOL)handleHttpOK:(NSMutableData *)data {
    if([[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] rangeOfString:@"false" options:NSCaseInsensitiveSearch].location!=NSNotFound){
        proAlertView *alert = [[proAlertView alloc] initWithTitle:@"Error!" message:@"Unable to fix this appointment!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
        [alert show];
        [alert release];
    }
	[self.delegate insertAppointmentDidFinish:self withError:nil];
	return YES;
}

-(BOOL)handleHttpError:(NSInteger)code {
	[self.delegate insertAppointmentDidFinish:self withError:[NSError errorWithDomain:@"Appointment" 
                                                                                code:[[self response] statusCode]
                                                                            userInfo:[NSDictionary dictionaryWithObject:@"Post comment failed. Please try again later" forKey:@"message"]]];
	return YES;
}

@end
