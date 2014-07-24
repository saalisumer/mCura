//
//  PostAppointmentInvocation.m
//  3GMDoc

#import "PostAppointmentInvocation.h"
#import "JSON.h"
#import "proAlertView.h"

@interface PostAppointmentInvocation (private)
-(NSString*)body;
@end

@implementation PostAppointmentInvocation

@synthesize type, AppId, userRollId ;

-(void)dealloc {
	[super dealloc];
}

-(void)invoke {
    NSString *a= [NSString stringWithFormat:@"%@UpdateAppointment_Block",[DataExchange getbaseUrl]];
    [self post:a body:[self body]];
}

-(NSString*)body {
    if([type isEqualToString:@"B"]){// block case
        NSString *bodyData = [NSString stringWithFormat:@"{\"appointmentid\":%d,\"UserRoleID\":%d,\"isDelete_Unblock\":\"false\"}",[self.AppId intValue],[self.userRollId intValue]];
        return bodyData;
    }
    else{ // delete and unblock case
        NSString *bodyData = [NSString stringWithFormat:@"{\"appointmentid\":%d,\"UserRoleID\":%d,\"isDelete_Unblock\":\"true\"}",[self.AppId intValue],[self.userRollId intValue]];
        return bodyData;
    }
}

-(BOOL)handleHttpOK:(NSMutableData *)data {
	if([[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] rangeOfString:@"false" options:NSCaseInsensitiveSearch].location!=NSNotFound){
        proAlertView *alert;
        if([type isEqualToString:@"B"])// block case
            alert = [[proAlertView alloc] initWithTitle:@"Error!" message:@"Unable to block this appointment!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        else
            alert = [[proAlertView alloc] initWithTitle:@"Error!" message:@"Unable to delete this appointment!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
        [alert show];
        [alert release];
    }
	[self.delegate postAppointmentDidFinish:self withError:nil];
	return YES;
}

-(BOOL)handleHttpError:(NSInteger)code {
	[self.delegate postAppointmentDidFinish:self 
                                  withError:[NSError errorWithDomain:@"Appointment"
                                                                code:[[self response] statusCode]
                                                            userInfo:[NSDictionary dictionaryWithObject:@"Post comment failed. Please try again later" forKey:@"message"]]];
	return YES;
}

@end


