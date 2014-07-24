//
//  PostMoveAppointmentInvocation.m
//  3GMDoc

#import "PostMoveAppointmentInvocation.h"
#import "JSON.h"
#import "proAlertView.h"

@interface PostMoveAppointmentInvocation (private)
-(NSString*)body;
@end

@implementation PostMoveAppointmentInvocation

@synthesize NewAppId, oldAppId, userRollId,TimeTableId;

-(void)dealloc {
	[super dealloc];
}
-(void)invoke {
    
    NSString *a= [NSString stringWithFormat:@"%@UpdateAppointments_Move",[DataExchange getbaseUrl]];
	[self post:a body:[self body]];
}

-(NSString*)body {
    
    NSString *bodyData = [NSString stringWithFormat:@"{\"appointmentid\":%@,\"UserRoleID\":%@,\"old_AppID\":%@,\"TimeTableId\":%@}",self.NewAppId,self.userRollId,self.oldAppId,self.TimeTableId];
	return bodyData;
    
}
-(BOOL)handleHttpOK:(NSMutableData *)data {
	
	if([[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] rangeOfString:@"false" options:NSCaseInsensitiveSearch].location!=NSNotFound){
        proAlertView *alert = [[proAlertView alloc] initWithTitle:@"Error!" message:@"Unable to move this appointment!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
        [alert show];
        [alert release];
    }
	[self.delegate postMoveAppointmentDidFinish:self withError:nil];
	
	return YES;
}

-(BOOL)handleHttpError:(NSInteger)code {
	
	[self.delegate postMoveAppointmentDidFinish:self withError:[NSError errorWithDomain:@"Appointment" code:[[self response] statusCode]
        userInfo:[NSDictionary dictionaryWithObject:@"Post comment failed. Please try again later" forKey:@"message"]]];
	return YES;
}

@end

