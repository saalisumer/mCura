//
//  Response+Parse.m
//  3GMDoc

#import "Response+Parse.h"
#import "Response.h"
#import "JSON.h"
#import "DataExchange.h"
#import "proAlertView.h"

@implementation Response (Parse)

+(Response*) responsesFromDictionary:(NSDictionary*)responsesd{
	if (!responsesd) {
		return Nil;
	}
	
	Response *r       = [[[Response alloc] init] autorelease];
    r.loginID         = [responsesd objectForKey:@"LoginId"];
	r.userRoleID      = [responsesd objectForKey:@"UserRoleId"];
	r.loginName       = [responsesd objectForKey:@"LoginName"];
	r.pwd			  = [responsesd objectForKey:@"Pwd"];
	r.pin             = [responsesd objectForKey:@"Pin"];
	r.currentStatusID = [responsesd objectForKey:@"CurrentStatusId"];
	NSString* str = [responsesd objectForKey:@"Domain"];
    if([str isKindOfClass:[NSNull class]]){
        return r;
    }
    NSURL *candidateURL = [NSURL URLWithString:str];
    if (candidateURL && candidateURL.scheme && candidateURL.host) {
        // candidate is a well-formed url with:
        str = [str stringByReplacingOccurrencesOfString:@"http://" withString:@""];
        if([[str substringFromIndex:str.length-1] isEqualToString:@"/"])
            str = [str substringToIndex:str.length-1];
        [DataExchange setDomainUrl:str];
        [DataExchange setbaseUrl:[NSString stringWithFormat:@"%@/health_dev.svc/json/",[DataExchange getDomainUrl]]];
    }
    else{
        proAlertView * alert = [[proAlertView alloc]initWithTitle:@"Error" message:@"Domain not found" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
        [alert show];
        [alert release];
    }
	return r;
}

+(NSArray*) responsesFromArray:(NSDictionary*) responsesA{
	if (!responsesA) {
		return Nil;
	}
	
	NSMutableArray *res = [[[NSMutableArray alloc] init] autorelease];

    Response *r = [Response responsesFromDictionary:responsesA];
    if (r) {
        [res addObject:r];
    }
	
	return res;	
}


@end


