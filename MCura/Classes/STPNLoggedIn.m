//
//  STPNLoggedIn.m
//  3GMDoc

#import "STPNLoggedIn.h"
#import "DeviceDeatils.h"
#import "Utils.h"
#import "Constant.h"
#import "GetLoginInvocation.h"
#import "STPNHomeScreen.h"
#import "STPNDisclaimer.h"
#import "GetUserInvocation.h"
#import "_GMDocService.h"
#import "Response.h"
#import "DataExchange.h"
#import "GetSubtenIdInvocation.h"
#import "SubTenantsViewcontroller.h"
#import "SubTenant.h"
#import "proAlertView.h"

@interface STPNLoggedIn (private)<GetLoginInvocationDelegate, GetUserInvocationDelegate,GetSubtenIdInvocationDelegate,SubTenantsChoiceDelegate>
@end

@implementation STPNLoggedIn

@synthesize lblUsername, lblPassword, txtUsername, txtPassword, btnLogin, activityController;
@synthesize deviceDtls, device,subTenIdArray;
@synthesize service = _service;

int requestNumber = 0;
int alertIndex = 0;
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
    if([DataExchange getDeviceDetails].count==0){
        [Utils showAlert:@"Tablet UDID not supported" Title:@"Error!"];
        return;
    }
    device = [[DataExchange getDeviceDetails] objectAtIndex:0];
    [DataExchange setAppointmentRefreshIndex:0];
    [DataExchange setAddPatient:Nil];
    if ([device.TabletOwnerTypeId intValue] == pinCase) {
        [txtPassword setHidden:YES];
        [lblPassword setHidden:YES];
        lblUsername.text = @"PIN";
        txtUsername.placeholder = @"PIN";
        txtUsername.secureTextEntry = YES;
        CGRect rectLoginBTN = CGRectMake(btnLogin.frame.origin.x, btnLogin.frame.origin.y-70, btnLogin.frame.size.width, btnLogin.frame.size.height);
        [btnLogin setFrame:rectLoginBTN];
    }else if ([device.TabletOwnerTypeId intValue] == usrPswdCase){
        txtUsername.secureTextEntry = NO;
        [txtPassword setHidden:NO];
        [lblPassword setHidden:NO];
        lblUsername.text = @"UserName";
        txtUsername.placeholder = @"UserName";
    }
    self.service = [[[_GMDocService alloc] init] autorelease];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.view.frame = CGRectMake(0, 0, 1024, 748);
    if(self.activityController){
        [self.activityController dismissActivity];
        self.activityController = nil;
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
	static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
	static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
    static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
    static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
    static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 60;
	
    CGRect textFieldRect =[self.view.window convertRect:textField.bounds fromView:textField];
    CGRect viewRect =[self.view.window convertRect:self.view.bounds fromView:self.view];
	CGFloat midline = textFieldRect.origin.y + 5.0 * textFieldRect.size.height;
    CGFloat numerator = midline - viewRect.origin.y - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    CGFloat denominator = (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION) * viewRect.size.height;
    CGFloat heightFraction = numerator / denominator;
	
    if (heightFraction < 0.0)
    {
        heightFraction = 0.0;
    }
    else if (heightFraction > 1.0)
    {
        heightFraction = 1.0;
    }
	
	UIInterfaceOrientation orientation =[[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait ||orientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
    }
    else
    {
        animatedDistance = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
    }
	
	CGRect viewFrame = self.view.frame;
    viewFrame.origin.y -= animatedDistance;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
	[self.view setFrame:viewFrame];
    [UIView commitAnimations];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
	
	static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
	CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance;
	[UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    [self.view setFrame:viewFrame];
    [UIView commitAnimations];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
	[txtUsername resignFirstResponder];
	[txtPassword resignFirstResponder];
	return YES;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [txtUsername resignFirstResponder];
	[txtPassword resignFirstResponder];
}

-(IBAction)getLoggedIn:(id)sender{
    requestNumber = 1;
    [btnLogin setEnabled:NO];
	[txtUsername resignFirstResponder];
	[txtPassword resignFirstResponder];
  	BOOL value = FALSE;
    
	if ([device.TabletOwnerTypeId intValue] != pinCase)  {
        if(!value){
            value=  [Utils textFieldValidation:txtUsername label:txtUsername.placeholder];
            [btnLogin setEnabled:YES];
        }
        
        if(!value){
            value= [Utils textFieldValidation:txtPassword label:txtPassword.placeholder];
            [btnLogin setEnabled:YES];
        }
        
        if(!value)
        {
            if ([[NSUserDefaults standardUserDefaults]stringForKey:GM_USERID] == nil || ![[[NSUserDefaults standardUserDefaults]stringForKey:GM_USERID] isEqualToString:txtUsername.text])
                [[NSUserDefaults standardUserDefaults]setObject:txtUsername.text forKey:GM_USERID];
            
            if ([[NSUserDefaults standardUserDefaults]stringForKey:GM_PASSWORD] == nil || ![[[NSUserDefaults standardUserDefaults]stringForKey:GM_PASSWORD] isEqualToString:txtPassword.text])
                [[NSUserDefaults standardUserDefaults]setObject:txtPassword.text forKey:GM_PASSWORD];
            
            if ([Utils isConnectedToNetwork]) {
                alertIndex = 1;
                [btnLogin setEnabled:NO];
                [self getLoginURL];
            }
        }
    }else{
        if(!value){
            value=  [Utils textFieldValidation:txtUsername label:txtUsername.placeholder];
            [btnLogin setEnabled:YES];
        }
        if(!value)
        {
            if ([[NSUserDefaults standardUserDefaults]stringForKey:GM_USERID] == nil || ![[[NSUserDefaults standardUserDefaults]stringForKey:GM_USERID] isEqualToString:txtUsername.text])
                [[NSUserDefaults standardUserDefaults]setObject:txtUsername.text forKey:GM_USERID];
            if ([Utils isConnectedToNetwork]) {
                alertIndex = 1;
                [btnLogin setEnabled:NO];
                [self getLoginURL];
            }
        }
    }
}

-(void)getLoginURL{
    self.activityController = [ISActivityOverlayController presentActivityOverViewController:self withLabel:@"Logging in..."];
    if ([device.TabletOwnerTypeId intValue] != pinCase){
        [self.service getLoginInvocation:self.txtUsername.text Password:[NSString stringWithFormat:@"%@&TabID=%@",self.txtPassword.text,[device.TabletId stringValue]] Type:[NSString stringWithFormat:@"%d",usrPswdCase] delegate:self];
    }else{
        [self.service getLoginInvocation:self.txtUsername.text Password:[device.TabletId stringValue] Type:[NSString stringWithFormat:@"%d",pinCase] delegate:self];
    }
}

-(void)getRoleID_URL{
	requestNumber = 2;
	    
    Response *res = [[DataExchange getLoginResponse] objectAtIndex:0];
    if(![res.userRoleID isKindOfClass:[NSNull class]]){
        [self.service getSubTenantIdInvocation:[res.userRoleID stringValue] delegate:self];
    }
    else{
        if(self.activityController){
            [self.activityController dismissActivity];
            self.activityController = nil;
        }
        [btnLogin setEnabled:YES];
        [Utils showAlert:@"Login fail" Title:@"Info"];
    }
}

-(void)getLoginInvocationDidFinish:(GetLoginInvocation*)invocation
                      withResponse:(NSArray*)responses
                         withError:(NSError*)error{
    [btnLogin setEnabled:YES];
    if(!error){
        if(requestNumber == 1){
            if([responses count] > 0){
                [DataExchange setLoginResponse:responses];
                [self getRoleID_URL];
            }
            else{
                if(self.activityController){
                    [self.activityController dismissActivity];
                    self.activityController = nil;
                }
                [Utils showAlert:@"Login fail" Title:@"Info"];
            }
        }
    }
    else{
        if(self.activityController){
            [self.activityController dismissActivity];
            self.activityController = nil;
        }
        [Utils showAlert:@"Login fail" Title:@"Info"];
    }
}

-(void)getUserInvocationDidFinish:(GetUserInvocation*)invocation
                     withResponse:(NSArray*)responses
                        withError:(NSError*)error{
    
    if(self.activityController){
        [self.activityController dismissActivity];
        self.activityController = nil;
    }
    if(!error){
        if(requestNumber == 2){
            [DataExchange setUserResult:responses];
            proAlertView * alert = [[proAlertView alloc]initWithTitle:@"" message:@"Welcome to mCura" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alert setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
            [alert show];
            [alert release];
        }
    }
}

-(void)GetSubtenIdInvocationDidFinish:(GetSubtenIdInvocation *)invocation 
                     withSubTenantIds:(NSArray *)subTenantIds
                            withError:(NSError *)error{
    
    NSLog(@"subTenantIds- %d",subTenantIds.count);
    
    if(!error && subTenantIds.count>0){
        
        self.subTenIdArray = [[NSMutableArray alloc] init];
        for (int i=0; i<subTenantIds.count; i++) {
            [self.subTenIdArray addObject:[(SubTenant*)[subTenantIds objectAtIndex:i] SubTenantId]];
        }
        [DataExchange setSubTenantIds:subTenantIds];
        if(!popover.isPopoverVisible){
            [DataExchange setScheduleDayIndex:0];
            [self subTenantChoice:0];
        }
    }else{
        if(self.activityController){
            [self.activityController dismissActivity];
            self.activityController = nil;
        }
        proAlertView * alert = [[proAlertView alloc]initWithTitle:@"Sorry!" message:@"No Records found! Please check your connection and try again." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
        [alert show];
        [alert release];
    }
}

-(void)subTenantChoice:(NSInteger)index{
    [popover dismissPopoverAnimated:YES];
    [DataExchange setSubTenantIdIndex:index];
    [DataExchange setSubTenantId:[[self.subTenIdArray objectAtIndex:index] integerValue]];
    Response *res = [[DataExchange getLoginResponse] objectAtIndex:0];
    [self.service getUserInvocation:[res.userRoleID stringValue] Async:false delegate:self];
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (alertIndex == 1 && [[DataExchange getLoginResponse] count] > 0) {
        if (buttonIndex == [alertView cancelButtonIndex])
		{
            txtPassword.text = @"";
            txtUsername.text = @"";
            if ([[NSUserDefaults standardUserDefaults]stringForKey:@"DISCLAIMER"] != nil && [[[NSUserDefaults standardUserDefaults]stringForKey:@"DISCLAIMER"] isEqualToString:@"YES"]){
                STPNHomeScreen *viewController = [[STPNHomeScreen alloc]initWithNibName:@"STPNHomeScreen" bundle:nil];
                [self.navigationController pushViewController:viewController animated:YES];
                [viewController release];
                
            }else if ([[NSUserDefaults standardUserDefaults]stringForKey:@"DISCLAIMER"] == nil){
                STPNDisclaimer *viewController = [[STPNDisclaimer alloc]initWithNibName:@"STPNDisclaimer" bundle:nil];
                [self.navigationController pushViewController:viewController animated:YES];
                [viewController release];
            }
        }
	}
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.service = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // return UIInterfaceOrientationIsLandscape(interfaceOrientation);
    return UIInterfaceOrientationLandscapeRight;
}

@end
