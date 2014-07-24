//
//  PostVitalCommentsVC.m
//  mCura
//
//  Created by Aakash Chaudhary on 30/10/12.
//  Copyright (c) 2012 aakash272@gmail.com. All rights reserved.
//

#import "PostVitalCommentsVC.h"
#import "DataExchange.h"
#import "proAlertView.h"
#import <QuartzCore/QuartzCore.h>

@implementation PostVitalCommentsVC

@synthesize delegate,vitalsId;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];    
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    commentsTxtView.autocorrectionType = UITextAutocorrectionTypeNo;

}

-(IBAction)submitBtnPressed{
    [commentsTxtView resignFirstResponder];
    NSString* dataToPost = [NSString stringWithFormat:@"{\"UserRoleId\":\"%@\",\"Comments\":\"%@\",\"ReadingsId\":\"%d\"}",[DataExchange getUserRoleId],commentsTxtView.text,self.vitalsId];
    NSLog(@"%@",dataToPost);
    
    NSURL* myUrl = [[[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://%@PostVitalComments",[DataExchange getbaseUrl]]] autorelease];
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
    [request setURL:myUrl];
    [request setHTTPMethod:@"POST"];
    [request setAllHTTPHeaderFields:[[[NSDictionary alloc] initWithObjects:[[[NSArray alloc] initWithObjects:@"application/json",@"utf-8",[DataExchange getDomainUrl],[NSString stringWithFormat:@"%d",dataToPost.length], nil] autorelease] forKeys:[[[NSArray alloc] initWithObjects:@"Content-Type",@"charset",@"Host",@"Content-Length", nil]autorelease]]autorelease]];
    [request setHTTPBody:[NSData dataWithBytes:[dataToPost UTF8String] length:[dataToPost lengthOfBytesUsingEncoding:NSUTF8StringEncoding]]]; 
    NSURLConnection *theConnection=[[[NSURLConnection alloc] initWithRequest:request delegate:self] autorelease];
    if (!theConnection) {
        proAlertView *alert = [[proAlertView alloc] initWithTitle:@"No Internet Connection" message:@"Please Try Again Later" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
        [alert show];
        [alert release];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSString *newStr = [[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    NSLog(@"---%@",newStr);
    if ([newStr componentsSeparatedByString:@"True"].count>0) {
        proAlertView *alert = [[proAlertView alloc] initWithTitle:nil message:@"Successfully submitted" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
        [alert show];
        [alert release];
        [delegate closePostVitalsPopup];
    }
    else{
        proAlertView *alert = [[proAlertView alloc] initWithTitle:@"Error" message:@"Unable to submit. Please Try Again Later" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
        [alert show];
        [alert release];
    }
}

-(IBAction)cancelBtnPressed
{
    [commentsTxtView resignFirstResponder];
    [delegate closePostVitalsPopup];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

@end
