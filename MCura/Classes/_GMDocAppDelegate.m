//
//  _GMDocAppDelegate.m
//  mCura

#import "_GMDocAppDelegate.h"
#import "SplashViewController.h"
#import "DataExchange.h"
#import "mCuraSqlite.h"
#import "UINavigationController+AutoRotation_ios6.h"
@implementation _GMDocAppDelegate

@synthesize window;
@synthesize navigationController,csb,profileimagevalue;

#pragma mark -
#pragma mark Application lifecycle

void uncaughtExceptionHandler(NSException *exception) {
    NSLog(@"CRASH: %@", exception);
    NSLog(@"Stack Trace: %@", [exception callStackSymbols]);
    // Internal error reporting
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    
    [mCuraSqlite copyDatabaseIfNeeded];    
	BOOL openSuccessful=[mCuraSqlite openDatabase:[mCuraSqlite getDBPath]];
	if(openSuccessful)
		NSLog(@"He he database");
    
    [self CustomizeControl];
     self.profileimagevalue =0;
    
    // Override point for customization after app launch.
//    [DataExchange setDomainUrl:@"localsearch.itchimes.net"];
    [DataExchange setDomainUrl:mCuraBaseUrl];
    [DataExchange setbaseUrl:[NSString stringWithFormat:@"%@/health_dev.svc/Json/",[DataExchange getDomainUrl]]];
    SplashViewController* splashController = [[SplashViewController alloc] init];
    
    navigationController = [[UINavigationController alloc] initWithRootViewController:splashController];
    [navigationController setNavigationBarHidden:YES];
    [splashController release];
    [window setRootViewController:navigationController];
    [window makeKeyAndVisible];
    
	return YES;
}


-(void)CustomizeControl{
    
    // Customing the segmented control
    UIImage *segmentSelected =
    [[UIImage imageNamed:@"segcontrol_sel.png"]
     resizableImageWithCapInsets:UIEdgeInsetsMake(0, 15, 0, 15)];
    UIImage *segmentUnselected =
    [[UIImage imageNamed:@"segcontrol_uns.png"]
     resizableImageWithCapInsets:UIEdgeInsetsMake(0, 15, 0, 15)];
    UIImage *segmentSelectedUnselected =
    [UIImage imageNamed:@"segcontrol_sel-uns.png"];
    UIImage *segUnselectedSelected =
    [UIImage imageNamed:@"segcontrol_uns-sel.png"];
    UIImage *segmentUnselectedUnselected =
    [UIImage imageNamed:@"segcontrol_uns-uns.png"];
    
    [[UISegmentedControl appearance] setBackgroundImage:segmentUnselected
                                               forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [[UISegmentedControl appearance] setBackgroundImage:segmentSelected
                                               forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    
    [[UISegmentedControl appearance] setDividerImage:segmentUnselectedUnselected
                                 forLeftSegmentState:UIControlStateNormal
                                   rightSegmentState:UIControlStateNormal
                                          barMetrics:UIBarMetricsDefault];
    [[UISegmentedControl appearance] setDividerImage:segmentSelectedUnselected
                                 forLeftSegmentState:UIControlStateSelected
                                   rightSegmentState:UIControlStateNormal
                                          barMetrics:UIBarMetricsDefault];
    [[UISegmentedControl appearance] setDividerImage:segUnselectedSelected
                                 forLeftSegmentState:UIControlStateNormal
                                   rightSegmentState:UIControlStateSelected barMetrics:UIBarMetricsDefault];

}
- (void)applicationWillResignActive:(UIApplication *)application {
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    
}

- (void)initializeCustomStatusBar{
    [self.csb release];
    [self setCsb:[[CustomStatusBar alloc] initWithFrame:[UIApplication sharedApplication].statusBarFrame]];
    //[self.window addSubview:self.csb];
}

- (void)showCSMMsg{
    [self.csb showWithStatusMessage:@"Fetching Brand data..."];
}

- (void)showCSMPercentage:(NSInteger)percentage{
    [self.csb showWithPercentageStatus:[NSString stringWithFormat:@"%d %%",percentage]];
}

#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    
}

- (void)dealloc {
    [navigationController release];
    [window release];
    [super dealloc];
}

-(NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        if (self.profileimagevalue ==0) {
            
            return UIInterfaceOrientationMaskLandscapeRight;
        }
        else{
            return UIInterfaceOrientationMaskAll;
        }
    }
    else  /* iphone */
        return UIInterfaceOrientationMaskAllButUpsideDown;
}

@end
