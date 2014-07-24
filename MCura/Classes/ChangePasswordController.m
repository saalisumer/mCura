//
//  ChangePasswordController.m
//  mCura
//
//  Created by Aakash Chaudhary on 02/06/12.
//  Copyright (c) 2012 aakash272@gmail.com. All rights reserved.
//

#import "ChangePasswordController.h"
#import "proAlertView.h"
#import "DataExchange.h"
#import "Response.h"

@implementation ChangePasswordController
@synthesize delegate,activityController,isChangePswd,btnToBeUsed;

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

-(IBAction)clickBtnDone:(id)sender{
    if(oldPswdTxtField.text.length==0){
        proAlertView *alert = [[proAlertView alloc] initWithTitle:@"Error!" message:[NSString stringWithFormat:@"Please fill old %@",(isChangePswd?@"password":@"PIN")] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
        [alert show];
        [alert release];
        return;
    }else if(newPswdTxtField.text.length==0){
        proAlertView *alert = [[proAlertView alloc] initWithTitle:@"Error!" message:[NSString stringWithFormat:@"Please fill new %@",(isChangePswd?@"password":@"PIN")] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
        [alert show];
        [alert release];
        return;
    }else if(newConfirmPswdTxtField.text.length==0){
        proAlertView *alert = [[proAlertView alloc] initWithTitle:@"Error!" message:[NSString stringWithFormat:@"Please confirm new %@",(isChangePswd?@"password":@"PIN")] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
        [alert show];
        [alert release];
        return;
    }else if(![newPswdTxtField.text isEqualToString:newConfirmPswdTxtField.text]){
        proAlertView *alert = [[proAlertView alloc] initWithTitle:@"Error!" message:[NSString stringWithFormat:@"%@ do not match!",(isChangePswd?@"Passwords":@"PINs")] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
        [alert show];
        [alert release];
        return;
    }
    self.activityController = [ISActivityOverlayController presentActivityOverViewController:self withLabel:@"Posting ..."];
    
    NSString* dataToPost;
    NSURL* myUrl;
    if(isChangePswd){
        myUrl= [[[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://%@changepassword",[DataExchange getbaseUrl]]] autorelease];
        dataToPost = [NSString stringWithFormat:@"{\"UserRoleId\":%@,\"Password\":\"%@\",\"OldPassword\":\"%@\"}",[DataExchange getUserRoleId],newPswdTxtField.text,oldPswdTxtField.text];
    }
    else{
        myUrl= [[[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://%@changepin",[DataExchange getbaseUrl]]] autorelease];
        dataToPost = [NSString stringWithFormat:@"{\"UserRoleId\":%@,\"NewPin\":\"%@\",\"OldPin\":\"%@\"}",[DataExchange getUserRoleId],newPswdTxtField.text,oldPswdTxtField.text];
    }
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

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    NSString *newStr = [[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    if([newStr rangeOfString:@"true"].location!=NSNotFound){
        proAlertView *alert = [[proAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"%@ changed successfully!",(isChangePswd?@"Password":@"PIN")] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
        [alert show];
        [alert release];
        if(isChangePswd){
            ((Response*)[[DataExchange getLoginResponse] objectAtIndex:0]).pwd = newPswdTxtField.text;            
        }else
            ((Response*)[[DataExchange getLoginResponse] objectAtIndex:0]).pin = [NSNumber numberWithInt:[newPswdTxtField.text integerValue]];
        [self.btnToBeUsed.titleLabel setText:newPswdTxtField.text];
        if(self.delegate != nil)
            [self.delegate closePopUpPassword];
    }
    else{
        proAlertView *alert = [[proAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"Incorrect old %@.",(isChangePswd?@"Password":@"PIN")] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
        [alert show];
        [alert release];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    if (self.activityController) {
        [self.activityController dismissActivity];
        self.activityController = nil;
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
	proAlertView *alert = [[proAlertView alloc] initWithTitle:@"Something Went Wrong" message:@"Please Try Again" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
    [alert setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
	[alert show];
	[alert release];
	return;
}

-(IBAction)clickBtnCancel:(id)sender{
    if(self.delegate != nil){
        [self.delegate closePopUpPassword];
    }
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    if(!isChangePswd){
        navBar.topItem.title = @"Change PIN";
        [lblOld setText:@"Old PIN"];
        [lblNew setText:@"New PIN"];
        [lblConfirm setText:@"Retype PIN"];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    BOOL isNumeric=FALSE;
	if ([string length] == 0) 
	{
		isNumeric=TRUE;
	}
	else if(!isChangePswd && (textField == newPswdTxtField || textField == oldPswdTxtField || textField==newConfirmPswdTxtField))
	{
		if ( [string compare:@"0"]==0 || [string compare:@"1"]==0
			|| [string compare:@"2"]==0 || [string compare:@"3"]==0
			|| [string compare:@"4"]==0 || [string compare:@"5"]==0
			|| [string compare:@"6"]==0 || [string compare:@"7"]==0
			|| [string compare:@"8"]==0 || [string compare:@"9"]==0)
		{
			isNumeric=TRUE;
		}
		else
		{
			unichar mychar=[string characterAtIndex:0];
			if (mychar==46)
			{
				int i;
				for (i=0; i<[textField.text length]; i++)
				{
					unichar c = [textField.text characterAtIndex: i];
					if(c==46)
						return FALSE;
				}
                isNumeric=TRUE;
			}
		}
	}
    else {
        isNumeric = TRUE;
    }
    
	return isNumeric;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // return UIInterfaceOrientationIsLandscape(interfaceOrientation);
    return UIInterfaceOrientationLandscapeRight;
}

@end
