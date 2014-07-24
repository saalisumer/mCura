//
//  Utilities.m
//  3GMDoc
//
//  Created by Saffron Tech on 14/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Utilities.h"
#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>
#import <netdb.h>
#import <SystemConfiguration/SCNetworkReachability.h>
#import <sqlite3.h>
#import "proAlertView.h"
sqlite3 *database=nil ;


@implementation Utilities
+(void)setHeader:(UIView *)view andTitle:(NSString *)titleStr{
	CGRect myImageRect = CGRectMake(0.0f, -5.0f, 1024.00, 33.0f); 
	UIImageView *myImage = [[UIImageView alloc] initWithFrame:myImageRect]; 
	[myImage setImage:[UIImage imageNamed:@"back_stick.png"]]; 
	myImage.opaque = YES; // explicitly opaque for performance 
	[view addSubview:myImage];
	[myImage release]; 
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(300.00, 00.00, 424.00, 30.00)];
    [title setText:titleStr];
    title.backgroundColor = [UIColor clearColor];
    title.textAlignment = UITextAlignmentCenter;
    title.shadowColor = [UIColor grayColor];
	title.shadowOffset = CGSizeMake(1,1);
	title.textColor = [UIColor darkGrayColor];
    [view addSubview:title];
    [title release];
}
+(void)setFooter:(UIView *)view andImage:(UIImage *)footerImg{
	CGRect myImageRect = CGRectMake(0.0f, 430.0f, 320.00, 30.0f); 
	UIImageView *myImage = [[UIImageView alloc] initWithFrame:myImageRect]; 
	[myImage setImage:footerImg]; 
	myImage.opaque = YES; // explicitly opaque for performance 
	[view addSubview:myImage];
	[myImage release]; 
}
+(NSString *)baseURL{
	return [[[NSString alloc]initWithString:@"http://localsearch.itchimes.net/health.svc/basic"] autorelease];
}

+(NSMutableString *)getSoapMessage:(NSString *)body{
     NSString *str = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns=\"http://tempuri.org/\">"];
    
	NSMutableString *sRequest = [[NSMutableString alloc]init];
    [sRequest appendString:str];
	[sRequest appendString:@"<soap:Body>"];
	[sRequest appendString:body];
	
	[sRequest appendString:@"</soap:Body>"];
	[sRequest appendString:@"</soap:Envelope>"];
    //[str release];
	
	return [sRequest autorelease];
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


+(BOOL)textViewValidation:(UITextView *)textView label:(NSString *)name
{
	//Connector.url = @"prem";
	
	BOOL Value=FALSE;
	if([textView.text length]!=0)
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
		[textView becomeFirstResponder];
	}
	return Value;
}

+(BOOL)emailValidation:(UITextField *)textField label:(NSString *)email
{
	
	BOOL Value=FALSE;
	NSString *emailRegEx =
    @"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
    @"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
    @"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
    @"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
    @"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
    @"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
    @"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
    
    NSPredicate *regExPredicate =
    [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
    BOOL myStringMatchesRegEx = [regExPredicate evaluateWithObject:email];
	
	if(myStringMatchesRegEx)
	{
		Value=FALSE;
	}
	else
	{
		//NSString *message=[NSString stringWithFormat:@"%@ must  be in formate",email];
		proAlertView *alert=[[proAlertView alloc] initWithTitle:@"INFO" message:@"From email Address must be in format !" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
		[alert show];
		[alert release];
		Value=TRUE;
		[textField becomeFirstResponder];
	}
	return Value;
}

+(BOOL)isConnectedToNetwork;
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

//simple API that encodes reserved characters according to:
//RFC 3986
//http://tools.ietf.org/html/rfc3986
+(NSString *)urlEncode: (NSString *) url
{
    NSArray *escapeChars = [NSArray arrayWithObjects:@";" , @"/" , @"?" , @":" ,
							@"@" , @"&" , @"=" , @"+" ,
							@"$" , @"," , @"[" , @"]",
							@"#", @"!", @"'", @"(", 
							@")", @"*",@" " ,nil];
	
    NSArray *replaceChars = [NSArray arrayWithObjects:@"%3B" , @"%2F" , @"%3F" ,
							 @"%3A" , @"%40" , @"%26" ,
							 @"%3D" , @"%2B" , @"%24" ,
							 @"%2C" , @"%5B" , @"%5D", 
							 @"%23", @"%21", @"%27",
							 @"%28", @"%29", @"%2A",@"_", nil];
	
    int len = [escapeChars count];
	
    NSMutableString *temp = [[url mutableCopy] autorelease];
	
    int i;
    for(i = 0; i < len; i++)
    {
		
        [temp replaceOccurrencesOfString: [escapeChars objectAtIndex:i]
							  withString:[replaceChars objectAtIndex:i]
								 options:NSLiteralSearch
								   range:NSMakeRange(0, [temp length])];
    }
	
    NSString *outStr = [NSString stringWithString: temp];
	
    return outStr ;
}


+(NSString *)urlRemoveWhiteSpace: (NSString *) url
{
    NSArray *escapeChars = [NSArray arrayWithObjects:@" ",nil];
	
    NSArray *replaceChars = [NSArray arrayWithObjects:@"", nil];
	
    int len = [escapeChars count];
	
    NSMutableString *temp = [[url mutableCopy] autorelease];
	
    int i;
    for(i = 0; i < len; i++)
    {
		
        [temp replaceOccurrencesOfString: [escapeChars objectAtIndex:i]
							  withString:[replaceChars objectAtIndex:i]
								 options:NSLiteralSearch
								   range:NSMakeRange(0, [temp length])];
    }
	
    NSString *outStr = [NSString stringWithString: temp];
	
    return outStr;
}

+(NSString *)getDeviceID{
    return [[UIDevice currentDevice] uniqueIdentifier];
}

 +(NSString *)financialYear
{
 NSMutableString *datestr = [[[NSMutableString alloc]init] autorelease];
 NSCalendar *calendar= [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
 NSCalendarUnit unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
 NSDate *date = [NSDate date];
 NSDateComponents *dateComponents = [calendar components:unitFlags fromDate:date];
 NSInteger year = [dateComponents year];
 NSInteger month = [dateComponents month];
 
 if (YES) {
 [datestr appendString:@"Jan 1, "];
 [datestr appendString:[NSString stringWithFormat:@"%d  To", year]];
 [datestr appendString:[NSString stringWithFormat:@"  Dec 31, %d", year]];
 }
 else {
 [datestr appendString:@"April 1, "];
 if( month <= 3 ){
 [datestr appendString:[NSString stringWithFormat:@"%d  To", --year]];
 [datestr appendString:[NSString stringWithFormat:@"  March 31, %d", ++year]];
 }
 else {
 [datestr appendString:[NSString stringWithFormat:@"%d  To", year]];
 [datestr appendString:[NSString stringWithFormat:@"  March 31, %d", ++year]];
 }
 }
 [calendar release];
 return datestr;
 
 }
 
 //	==============================================================
 //	resizedImage
 //	==============================================================
 // Return a scaled down copy of the image.  
 
 +(UIImage* ) resizedImage:(UIImage *)inImage andRect:(CGRect)thumbRect
 {
 CGImageRef			imageRef = [inImage CGImage];
 CGImageAlphaInfo	alphaInfo = CGImageGetAlphaInfo(imageRef);
 
 // There's a wierdness with kCGImageAlphaNone and CGBitmapContextCreate
 // see Supported Pixel Formats in the Quartz 2D Programming Guide
 // Creating a Bitmap Graphics Context section
 // only RGB 8 bit images with alpha of kCGImageAlphaNoneSkipFirst, kCGImageAlphaNoneSkipLast, kCGImageAlphaPremultipliedFirst,
 // and kCGImageAlphaPremultipliedLast, with a few other oddball image kinds are supported
 // The images on input here are likely to be png or jpeg files
 if (alphaInfo == kCGImageAlphaNone)
 alphaInfo = kCGImageAlphaNoneSkipLast;
 
 // Build a bitmap context that's the size of the thumbRect
 CGContextRef bitmap = CGBitmapContextCreate(
 NULL,
 thumbRect.size.width,		// width
 thumbRect.size.height,		// height
 CGImageGetBitsPerComponent(imageRef),	// really needs to always be 8
 4 * thumbRect.size.width,	// rowbytes
 CGImageGetColorSpace(imageRef),
 alphaInfo
 );
 
 // Draw into the context, this scales the image
 CGContextDrawImage(bitmap, thumbRect, imageRef);
 
 // Get an image from the context and a UIImage
 CGImageRef	ref = CGBitmapContextCreateImage(bitmap);
 UIImage*	result = [UIImage imageWithCGImage:ref];
 
 CGContextRelease(bitmap);	// ok if NULL
 CGImageRelease(ref);
 return result;
 }
 
 
+(void)loginAlert{
     proAlertView *passwordAlert = [[proAlertView alloc] initWithTitle:@"Server Password" message:@"\n\n\n" delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel",nil) otherButtonTitles:NSLocalizedString(@"OK",nil), nil];
     [passwordAlert setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];

     UILabel *passwordLabel = [[UILabel alloc] initWithFrame:CGRectMake(12,40,260,25)];
     passwordLabel.font = [UIFont systemFontOfSize:16];
     passwordLabel.textColor = [UIColor whiteColor];
     passwordLabel.backgroundColor = [UIColor clearColor];
     passwordLabel.shadowColor = [UIColor blackColor];
     passwordLabel.shadowOffset = CGSizeMake(0,-1);
     passwordLabel.textAlignment = UITextAlignmentCenter;
     passwordLabel.text = @"Account Name";
     [passwordAlert addSubview:passwordLabel];
     
     UIImageView *passwordImage = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"passwordfield" ofType:@"png"]]];
     passwordImage.frame = CGRectMake(11,79,262,31);
     [passwordAlert addSubview:passwordImage];
     
     UITextField *passwordField = [[UITextField alloc] initWithFrame:CGRectMake(16,83,252,25)];
     passwordField.font = [UIFont systemFontOfSize:18];
     passwordField.backgroundColor = [UIColor whiteColor];
     passwordField.secureTextEntry = YES;
     passwordField.keyboardAppearance = UIKeyboardAppearanceAlert;
    // passwordField.delegate = self;
     [passwordField becomeFirstResponder];
     [passwordAlert addSubview:passwordField];
     
     [passwordAlert setTransform:CGAffineTransformMakeTranslation(50,109)];
     [passwordAlert show];
     [passwordAlert release];
     [passwordField release];
     [passwordImage release];
     [passwordLabel release];

 
 }
 
 - (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex { 
 NSLog(@"%@",@"Login Again" );
 
 }
 
 
+(void)sessionAlert{
     NSMutableString *str = [[[NSMutableString alloc]initWithString:@""] autorelease];
 
     [str appendString:@"!\nPlease Login Again"];
     //sessionAlertBOOL_cal = YES;
 
     proAlertView *sessionAlert_cal = [[[proAlertView alloc] initWithTitle:str message:@"this gets covered" delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) otherButtonTitles:NSLocalizedString(@"OK", nil),nil] autorelease];
     [sessionAlert_cal setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];

     UITextField *passwordAgain = [[[UITextField alloc] initWithFrame:CGRectMake(12, 85, 260, 25)] autorelease];
     passwordAgain.keyboardAppearance = UIKeyboardAppearanceAlert;
     passwordAgain.borderStyle = UITextBorderStyleRoundedRect;
     passwordAgain.autocorrectionType = UITextAutocorrectionTypeNo;
     passwordAgain.clearButtonMode = UITextFieldViewModeWhileEditing;
     passwordAgain.returnKeyType = UIReturnKeyDone;
     passwordAgain.secureTextEntry = YES;
     passwordAgain.placeholder = @"<Enter Password>";
    // passwordAgain.delegate = self;    
     [sessionAlert_cal addSubview:passwordAgain];
     [sessionAlert_cal show];    
 
 }
 
 +(BOOL)isCalender{
 return YES;
 }

 
 
 
 +(NSString *)GetConnectToDatabase
 {
 NSFileManager *fileManager = [NSFileManager defaultManager];
 NSError *error;
 NSString *dbPath;
 NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
 NSString *documentsDir = [paths objectAtIndex:0];
 dbPath= [documentsDir stringByAppendingPathComponent:@"iParcel.db"];
 BOOL success = [fileManager fileExistsAtPath:dbPath]; 
 
 if(!success) 
 {
 NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"iParcel.db"];
 success = [fileManager copyItemAtPath:defaultDBPath toPath:dbPath error:&error];
 }
 return dbPath;
 }
 
 +(NSMutableArray *)GetCountryFromDatabase
 {
 NSMutableArray *temp = [[[NSMutableArray alloc] init] autorelease];
 NSString *dbPath1=[self GetConnectToDatabase];
 if (sqlite3_open([dbPath1 UTF8String], &database) == SQLITE_OK)
 {
 NSString *qs=@"select * from CountryTable";
 const char *sql=[qs UTF8String];
 sqlite3_stmt *selectstmt;
 if(sqlite3_prepare_v2(database, sql, -1, &selectstmt, NULL) == SQLITE_OK)
 {
 while(sqlite3_step(selectstmt) == SQLITE_ROW)
 {
 [temp addObject:[NSString stringWithUTF8String: (char *)sqlite3_column_text(selectstmt, 1) ]];
 }
 sqlite3_finalize(selectstmt);
 }
 }
 sqlite3_close(database); 
 return  temp;
 }
 
+(NSString *)currentDate{
    
    NSString *currentDate;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MM-dd-yyyy"];
    //df.dateStyle = NSDateFormatterMediumStyle;
    currentDate = [NSString stringWithFormat:@"%@",
                   [df stringFromDate:[NSDate date]]];
    [df release];
    return currentDate;
    
}

+(NSString*)current_Date{
    NSLocale *usLocale = [[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"] autorelease];
    
    NSLocale *gbLocale = [[[NSLocale alloc] initWithLocaleIdentifier:@"en_GB"] autorelease];
    NSString *dateFormat;
    
    NSString *dateComponents = @"yMMMMd";
    
    
    
    dateFormat = [NSDateFormatter dateFormatFromTemplate:dateComponents options:0 locale:usLocale];
    
    NSLog(@"Date format for %@: %@",
          
          [usLocale displayNameForKey:NSLocaleIdentifier value:[usLocale localeIdentifier]], dateFormat);
    
    
    
    dateFormat = [NSDateFormatter dateFormatFromTemplate:dateComponents options:0 locale:gbLocale];
    
    NSLog(@"Date format for %@: %@",
          
          [gbLocale displayNameForKey:NSLocaleIdentifier value:[gbLocale localeIdentifier]], dateFormat);
    
    
    
    // Output:
    
    // Date format for English (United States): MMMM d, y
    
    // Date format for English (United Kingdom): d MMMM y
    
    NSString *currentDate;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"dd-mm-yyyy"];
    //[df setDateFormat:@"yyyy-MM-dd"];
    //df.dateStyle = NSDateFormatterMediumStyle;
    currentDate = [NSString stringWithFormat:@"%@",
                   [df stringFromDate:[NSDate date]]];
    [df release];
    return currentDate; 
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
