//
//  STPNHomeScreen.m
//  3GMDoc

#import "STPNHomeScreen.h"
#import "Utils.h"
#import "_GMDocService.h"
#import "DataExchange.h"
#import "Response.h"
#import "Schedule.h"
#import "GetScheduleInvocation.h"
#import "CAVNSArrayTypeCategory.h"
#import "SubTenant.h"
#import "mCuraSqlite.h"

@interface STPNHomeScreen (private)<GetScheduleInvocationDelegate,GetGenericInvocationDelegate,GetStringInvocationDelegate>
@end

@implementation STPNHomeScreen
@synthesize service = _service;
@synthesize activity;

int request_Numbe ;

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
    self.service = [[[_GMDocService alloc] init] autorelease];
   // if(![mCuraSqlite doGenericsExist])
       // [self.service getGenericInvocation:0 delegate:self];
    [self getScheduleURL];
}

-(void)getScheduleURL{

    request_Numbe  = 1;
        
    [self.activity setHidden:NO];
    [self.activity startAnimating];
    
    NSString *currentDate;
    NSDateFormatter *df = [[[NSDateFormatter alloc] init] autorelease];
    [df setDateFormat:@"dd-MMM-yyyy"];
    currentDate = [NSString stringWithFormat:@"%@",[df stringFromDate:[NSDate date]]];
      
    Response *res = [[DataExchange getLoginResponse] objectAtIndex:0];
    NSString* subTen = [NSString stringWithFormat:@"%d",[DataExchange getSubTenantId]];
    [self.service getSchedule2Invocation:[res.userRoleID stringValue] SubTenantId:subTen CurrentDate:currentDate Type:@"3" delegate:self];
}

-(void)fetchImageNameURL{
    
    request_Numbe = 2;
    
    [activity setHidden:NO];
    [activity startAnimating];
    
    NSString *currentDate;
    NSDateFormatter *df = [[[NSDateFormatter alloc] init] autorelease];
    [df setDateFormat:@"dd-MMM-yyyy"];
    currentDate = [NSString stringWithFormat:@"%@",[df stringFromDate:[NSDate date]]];
    
    Response *res = [[DataExchange getLoginResponse] objectAtIndex:0];
    [self.service getScheduleInvocation:[res.userRoleID stringValue] CurrentDate:currentDate Type:@"2" delegate:self];
}

-(void) GetStringInvocationDidFinish:(GetStringInvocation *)invocation 
                  withResponseString:(NSString *)responseString 
                      withIdentifier:(NSString *)identifier 
                           withError:(NSError *)error{
    if(!error){
        NSArray* response = [responseString JSONValue];
        if([identifier isEqualToString:@"GetBrands"]){
            [NSThread detachNewThreadSelector:@selector(fillBrandsTable:) toTarget:self withObject:response];
        }
    }
}

-(void) fillBrandsTable:(NSMutableArray*)response{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    [mCuraSqlite DeleteAllBrands];
    NSDictionary* dictTemp;
    for (int i=0; i<response.count; i++) {
        dictTemp = [response objectAtIndex:i];
        Brand* brandtemp = [[[Brand alloc] init] autorelease];
        brandtemp.BrandName = [dictTemp objectForKey:@"Name"];
        brandtemp.BrandId = [dictTemp objectForKey:@"Id"];
        [mCuraSqlite InsertANewBrandRecord:brandtemp ForGenericId:0];
    }
    [pool release];
}

-(void) getGenericInvocationDidFinish:(GetGenericInvocation*)invocation
                      withInvocations:(NSArray*)invocations
                            withError:(NSError*)error{
    if(!error){
        if([invocations count] > 0){
            [NSThread detachNewThreadSelector:@selector(fillGenericsTable:) toTarget:self withObject:invocations];
        }
    }
}

-(void) fillGenericsTable:(NSMutableArray*)invocations{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    [mCuraSqlite DeleteAllGenerics];
    for (int i=0; i<invocations.count; i++) {
        [mCuraSqlite InsertANewGenericRecord:[invocations objectAtIndex:i]];
    }
    [pool release];
}

-(void)getScheduleInvocationDidFinish:(GetScheduleInvocation*)invocation
                         withSchedule:(NSArray*)schedules
                            withError:(NSError*)error{

    if(!error){
        if(request_Numbe == 1){
            if([schedules count] > 0){
                [DataExchange setSchedulerResponse:schedules];
                [self fetchImageNameURL];
            }
            else{
                //Setting Delay time to avoid service request time out error
                double delayInSeconds = 5;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    
                    NSArray* wired = [[NSBundle mainBundle] loadNibNamed:@"TabViewController" owner:self options:nil];
                    UITabBarController* tabBar = [wired firstObjectWithClass:[UITabBarController class]];
                    [self.navigationController pushViewController:tabBar animated:YES];

                });
                
             }
        }
        else if(request_Numbe == 2){
             if([schedules count] > 0){
                 Schedule *sec = [[DataExchange getSchedulerReponse] objectAtIndex:0];
                 sec.scheduleImg = [schedules objectAtIndex:0];
                 
                 NSMutableString* str = [NSString stringWithFormat:@"%@",sec.scheduleImg];
                 if(str==NULL)
                     str = [NSString stringWithFormat:@"%@",@" "];
                 [DataExchange setScheduleImageName:str];
                 NSArray* wired = [[NSBundle mainBundle] loadNibNamed:@"TabViewController" owner:self options:nil];
                 UITabBarController* tabBar = [wired firstObjectWithClass:[UITabBarController class]];
                 [self.navigationController pushViewController:tabBar animated:YES];
             }
        }
    }
    else{
        [Utils showAlert:@"\nCould not retrieve data.\n\nPlease check you Network setting and try again later.\nApplication will be terminated unexpectedly or action doesn't perform anything!" Title:@"Connection  Login"];
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
