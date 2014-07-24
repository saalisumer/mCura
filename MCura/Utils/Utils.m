//
//  Utils.m
//  3GMDoc

#import "Utils.h"
#import <SystemConfiguration/SCNetworkReachability.h>
#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>
#import <netdb.h>
#import "proAlertView.h"

@implementation Utils

+(void)showAlert:(NSString*)msg Title:(NSString *)title{
    
    proAlertView *alert = [[proAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alert setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
    [alert show];
    [alert  release];

}

+(BOOL)textFieldValidation:(UITextField *)textField label:(NSString *)name
{
	//Connector.url = @"prem";
	
	BOOL Value=FALSE;
	if([textField.text length]!=0)
	{
		Value=FALSE;
	}
	else
	{
		NSString *message=[NSString stringWithFormat:@"Please Enter %@",name];
		proAlertView *alert=[[proAlertView alloc] initWithTitle:@"INFO" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
		[alert show];
		[alert release];
		Value=TRUE;
		[textField becomeFirstResponder];
	}
	return Value;
}

+(BOOL)isConnectedToNetwork
{
    // Create zero addy
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
	
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
	
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
	
    if (!didRetrieveFlags)
    {
        printf("Error. Could not recover network reachability flags\n");
        return 0;
    }
	
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
    return (isReachable && !needsConnection) ? YES : NO;
}

+(NSDate *)convertStringToDate:(NSString *)dateStr{
    NSString *dateString = [[dateStr copy] autorelease];//@"09-12-1976"; //[dateStr copy];/1976-12-09
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    // this is imporant - we set our input date format to match our input string
    // if format doesn't match you'll get nil from your string, so be careful
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    NSDate *dateFromString;
    // voila!
    dateFromString = [dateFormatter dateFromString:dateString];
    return dateFromString;
}

+(NSInteger)age:(NSDate *)dateOfBirth {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    NSDateComponents *dateComponentsNow = [calendar components:unitFlags fromDate:[NSDate date]];
    NSDateComponents *dateComponentsBirth = [calendar components:unitFlags fromDate:dateOfBirth];
    
    if (([dateComponentsNow month] < [dateComponentsBirth month]) ||
        (([dateComponentsNow month] == [dateComponentsBirth month]) && ([dateComponentsNow day] < [dateComponentsBirth day]))) {
        return [dateComponentsNow year] - [dateComponentsBirth year] - 1;
    } else {
        return [dateComponentsNow year] - [dateComponentsBirth year];
    }
}

@end
