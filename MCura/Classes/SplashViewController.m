//
//  SplashViewController.m
//  3GMDoc

#import "SplashViewController.h"
#import "_GMDocService.h"
#import "GetTabletInvocation.h"
#import "Utils.h"
#import "DataExchange.h"

@interface SplashViewController (private)<GetTabletInvocationDelegate>
@end

@implementation SplashViewController

@synthesize service = _service, splashImageView;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    loadingLabel = [[[UILabel alloc]initWithFrame:CGRectMake(1024/2-70, 768/2+140, 100.0, 20.0)] autorelease];
    loadingLabel.text = @"Loading.......";
    activity = [[[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(1024/2+55, 768/2+135,40 , 40)] autorelease];
    [activity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:loadingLabel];
    [self.view addSubview:activity];
	[activity startAnimating];
	self.service = [[[_GMDocService alloc] init] autorelease];
//    NSLog(@"%@",[[UIDevice currentDevice] uniqueIdentifier]);
	//[self.service GetTabletInvocation:[[UIDevice currentDevice] uniqueIdentifier] delegate:self];
   [self.service GetTabletInvocation:@"d36cc0b8aeb85316eb150f321bbb44d31b0ac759" delegate:self];
//    [self.service GetTabletInvocation:@"00120001" delegate:self];
    
}

-(void)getTabletInvocationDidFinish:(GetTabletInvocation*)invocation
						withTablets:(NSArray*)tablets
						  withError:(NSError*)error{
    [loadingLabel setHidden:YES];
	[activity stopAnimating];
    
    if(!error){
        [self fadeScreen];
        [DataExchange setDeviceDetails:tablets];
    }
    else{
        [Utils showAlert:@"\nCould not retrieve data.\n\nPlease check you Network setting and try again later.\nApplication will be terminated unexpectfully or action doesn't perform anything!" Title:@"Connection  Login"];
    }
}

- (void)fadeScreen
{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:1.75];       
	[UIView setAnimationDelegate:self];        
	[UIView setAnimationDidStopSelector:@selector(finishedFading)];   	
	self.view.alpha = 0.0;       
	[UIView commitAnimations];  
}


- (void) finishedFading
{
	[UIView beginAnimations:nil context:nil]; // begins animation block
	[UIView setAnimationDuration:1.75];        // sets animation duration
	self.view.alpha = 1.0;   // fades the view to 1.0 alpha over 0.75 seconds
	viewController.view.backgroundColor = [UIColor blackColor];
	viewController.view.alpha = 1.0;
	[UIView commitAnimations];   // commits the animation block.  This Block is done.
	[self.splashImageView removeFromSuperview];
	[self stop];
}

-(void)stop{
    [activity setHidden:YES];
    [loadingLabel setHidden:YES];
    [activity stopAnimating];
	viewController = [[STPNLoggedIn alloc]initWithNibName:@"STPNLoggedIn" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
	[viewController release];
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // return UIInterfaceOrientationIsLandscape(interfaceOrientation);
    return UIInterfaceOrientationLandscapeRight;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];	
}

- (void)viewDidUnload {

}

- (void)dealloc {
    [super dealloc];
}

@end
