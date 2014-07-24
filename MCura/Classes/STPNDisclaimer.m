//
//  STPNDisclaimer.m
//  3GMDoc

#import "STPNDisclaimer.h"
#import "STPNHomeScreen.h"
#import "Utils.h"
#import "DataExchange.h"
#import "proAlertView.h"

@implementation STPNDisclaimer

@synthesize disclaimerAgree, diclaimerDisagree, disclaimerStr; 

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
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.disclaimerAgree.tag = 1;
    self.diclaimerDisagree.tag = 2;
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

-(IBAction)discalaimer:(id)sender{
    UIButton *button = (UIButton *)sender;
    
    if (button.tag == 1) {
        self.disclaimerStr = @"YES";
        
        [[NSUserDefaults standardUserDefaults]setObject:self.disclaimerStr forKey:@"DISCLAIMER"];
        
        STPNHomeScreen *viewController = [[STPNHomeScreen alloc]initWithNibName:@"STPNHomeScreen" bundle:nil];
        [self.navigationController pushViewController:viewController animated:YES];
        [viewController release];
    
    }else if (button.tag == 2){
        
        proAlertView * alert = [[proAlertView alloc] initWithTitle:@"" message:@"Yor are disagree with term and condition.Do you want to exit?" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel",nil];
        [alert setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
        [alert show];
        [alert release];
    }    
}
- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == [alertView cancelButtonIndex])
    {
        exit(0);
    }else{
        
    }
}

@end
