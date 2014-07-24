//
//  STPNAppointmentRootViewController.m
//  3GMDoc

#import "STPNAppointmentRootViewController.h"
#import "DataExchange.h"
#import "Constant.h"
#import "Utils.h"
#import "_GMDocService.h"
#import "Response.h"
#import "GetScheduleInvocation.h"
#import "GetDocAddrOrContInvocation.h"
#import "GetStringInvocation.h"
#import "Schedule.h"
#import "CAVNSArrayTypeCategory.h"
#import "ImageCache.h"
#import "Appointment.h"
#import "Patdemographics.h"
#import "STPNLoggedIn.h"
#import "STPNFixAppointmentViewController.h"
#import "STPNBlockAppointmentViewController.h"
#import "STPNAddPatientViewController.h"
#import "STPNMoveAppointmentViewController.h"
#import "PostAppointmentInvocation.h"
#import "Booking.h"
#import "SubTenant.h"
#import <QuartzCore/QuartzCore.h>

@interface STPNAppointmentRootViewController (private)<GetScheduleInvocationDelegate, ImageCacheDelegate, STPNFixAppointmentDelegate, STPNBlockAppointmentDelegate, STPNAddPatientDelegate, STPNMoveAppointmentDelegate, PostAppointmentDelegate,GetDocAddrOrContInvocationDelegate,GetStringInvocationDelegate>
@end

@implementation STPNAppointmentRootViewController

@synthesize btnShowAll, schedulerTable, imgView, activityController,currIndexPath;
@synthesize phone, _indexPath, currDate, service, imgUrl, selectedDate;
@synthesize popover = _popover,doctorNameButton;
@synthesize selectedIndex,previousDate,previousButton,nextDate,nextButton;

const CGSize kIconSize = {700, 670};
float finalSchdeuleValue;
int sectionNumber;
int request_Numbe;

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

-(void) closePopup:(BOOL)reloadData
{
    [self.popover  dismissPopoverAnimated:NO];
    request_Numbe = 1;
    if(reloadData){
        if(!self.activityController)
            self.activityController = [ISActivityOverlayController presentActivityOverViewController:self withLabel:@"Loading ..."];
        [self.service getScheduleInvocation:[res.userRoleID stringValue] CurrentDate:self.selectedDate Type:@"1" delegate:self];
    }
}

- (void) closePopupFromAddBtn{
    [self.popover  dismissPopoverAnimated:NO];
    STPNAddPatientViewController *addController = [[STPNAddPatientViewController alloc] initWithNibName:@"STPNAddPatientViewController" bundle:nil];
    addController.areaId = [DataExchange getAreaID];
    addController.delegate = self;
    addController.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentModalViewController:addController animated:YES];
    addController.view.superview.frame = CGRectMake(242, 44, 540, 680);
    [addController release];
}

-(void)closeAddPatientPopup{
    STPNFixAppointmentViewController* apntmntController = [[[STPNFixAppointmentViewController alloc] initWithNibName:@"STPNFixAppointmentViewController" bundle:nil] autorelease];
    self.popover = [[[UIPopoverController alloc] initWithContentViewController:apntmntController] autorelease];
    apntmntController.delegate = self;
    apntmntController.selectedIndex = [NSNumber numberWithInt:addPatSelectedIndex];
    apntmntController.selectedScheduleIndex = addPatSelectedScheduleIndex;
    if([DataExchange getAddPatient]!=Nil){
        apntmntController.patients = [[NSArray alloc] initWithObjects:[DataExchange getAddPatient], nil];
        [apntmntController setSelectedCell:0];
        [DataExchange setAddPatient:Nil];
    }
    [self.popover setPopoverContentSize:CGSizeMake(540, 372)];
    [self.popover presentPopoverFromRect:CGRectMake(200, 60, 1, 1) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.service = [[[_GMDocService alloc] init] autorelease];
    res = [[DataExchange getLoginResponse] objectAtIndex:0];
    [DataExchange setUserRoleId:[res.userRoleID stringValue]];
    self.navigationItem.title=@"Schedule";
    hospitalBtn.layer.cornerRadius=5.0;
    hospitalBtn.layer.borderColor = [UIColor blackColor].CGColor;
    hospitalBtn.layer.borderWidth = 1.0;
    NSString *currentDate;
    NSDateFormatter *df = [[[NSDateFormatter alloc] init] autorelease];
    [df setDateFormat:@"dd-MMM-yyyy"];
    currentDate = [NSString stringWithFormat:@"%@",[df stringFromDate:[NSDate date]]];
    self.selectedDate = currentDate;
    
    weekday = [[[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:[NSDate date]] weekday];
    if(weekday>1){
        NSDateComponents *dateComponents = [[[NSDateComponents alloc] init] autorelease];
        [dateComponents setDay:9-weekday];    
        self.nextDate = [[NSCalendar currentCalendar]
                    dateByAddingComponents:dateComponents
                    toDate:[NSDate date] options:0];
        [dateComponents setDay:2-weekday];    
        self.previousDate = [[NSCalendar currentCalendar]
                        dateByAddingComponents:dateComponents
                        toDate:[NSDate date] options:0];
    }else{
        NSDateComponents *dateComponents = [[[NSDateComponents alloc] init] autorelease];
        [dateComponents setDay:1];    
        self.nextDate = [[NSCalendar currentCalendar]
                    dateByAddingComponents:dateComponents
                    toDate:[NSDate date] options:0];
        [dateComponents setDay:-6];    
        self.previousDate = [[NSCalendar currentCalendar]
                        dateByAddingComponents:dateComponents
                        toDate:[NSDate date] options:0];
    }
    NSDateComponents *dateComponents2 = [[[NSDateComponents alloc] init] autorelease];
    [dateComponents2 setDay:6];
    NSDate* tempNextDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents2 toDate:self.previousDate options:0];

    UIToolbar* tools = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 405, 44.01)];
    
    NSMutableArray* buttons = [[NSMutableArray alloc] initWithCapacity:5];
    
    self.previousButton = [[UIBarButtonItem alloc] initWithTitle:[NSString stringWithFormat:@"<< %@",[df stringFromDate:self.previousDate]] style:UIBarButtonItemStyleBordered target:self action:@selector(previous:)];
    [buttons addObject:self.previousButton];
    
    UIBarButtonItem* bi = [[UIBarButtonItem alloc] initWithTitle:@"Week" style:UIBarButtonItemStylePlain target:self action:nil];
    [buttons addObject:bi];
    [bi release];
    
    self.nextButton = [[UIBarButtonItem alloc] initWithTitle:[NSString stringWithFormat:@"%@ >>",[df stringFromDate:tempNextDate]] style:UIBarButtonItemStyleBordered target:self action:@selector(next:)];
    [buttons addObject:self.nextButton];
    
    bi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshView)];
    bi.style = UIBarButtonItemStyleBordered;
    [buttons addObject:bi];
    [bi release];
    
    bi = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(selectLogout:)];
    bi.style = UIBarButtonItemStyleBordered;
    [buttons addObject:bi];
    [bi release];
    
    [tools setItems:buttons animated:NO];
    
    [buttons release];
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:tools] autorelease];
    [tools release];
    
    _iconDownloader = [[ImageCache alloc] init];
    _iconDownloader.delegate = self;
    
    currDate = [[NSMutableString alloc]init];
    
    _indexPath = [[[NSIndexPath alloc]init] autorelease];
    [self.service getDocConOrAddInvocation:[res.userRoleID stringValue] AddrOrContId:[NSString stringWithFormat:@"%d",[[(UserDetail*)[[DataExchange getUserResult] objectAtIndex:0] addressId] integerValue]] AddrOrCont:YES delegate:self];
    
    NSString* url = [NSMutableString stringWithFormat:@"%@GetUserDetails?sub_tenant_id=%d&UserRoleID=%@",[DataExchange getbaseUrl],[DataExchange getSubTenantId],[DataExchange getUserRoleId]];
    [self.service getStringResponseInvocation:url Identifier:@"GetUserDetails" delegate:self];
    
    self.schedulerTable.rowHeight = 65;
    currentDayIndex = 0;
    showAll = true;
    btnShowAll.titleLabel.numberOfLines=0;
    btnShowAll.titleLabel.lineBreakMode = UILineBreakModeWordWrap;
    for (int i=0; i<phone.count; i++) {
        isSectionCompressed[i]=false;
    }
    [self loadDataView];
    [hospitalBtn setTitle:[NSString stringWithFormat:@"-%@-",[(SubTenant*)[[DataExchange getSubTenantIds] objectAtIndex:0] SubTenantName]] forState:UIControlStateNormal];
    [DataExchange setHospitalName:[NSString stringWithFormat:@"%@",[(SubTenant*)[[DataExchange getSubTenantIds] objectAtIndex:0] SubTenantName]]];
    [self tabBarController].delegate = self;
}

-(void)refreshView{
    if(!self.activityController)
        self.activityController = [ISActivityOverlayController presentActivityOverViewController:self withLabel:@"Loading ..."];
    request_Numbe = 1;
    [self.service getSchedule2Invocation:[res.userRoleID stringValue] SubTenantId:[NSString stringWithFormat:@"%d",[DataExchange getSubTenantId]] CurrentDate:self.selectedDate Type:@"3" delegate:self];
}

-(void)viewWillAppear:(BOOL)animated{
    UIToolbar* toolsLeft = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 160, 44.01)];
    NSMutableArray* buttons = [[NSMutableArray alloc] initWithCapacity:2];
    UIBarButtonItem* bi = [[UIBarButtonItem alloc] initWithTitle:@"Welcome" style:[UIFont boldSystemFontOfSize:16] target:self action:nil];
    
    
    //new code
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    
    
    
    
    [buttons addObject:bi];
    [bi release];
    NSString* str=[(UserDetail*)[[DataExchange getUserResult] objectAtIndex:0] u_name];
    self.doctorNameButton = [[UIBarButtonItem alloc] initWithTitle:str style:UIBarButtonItemStylePlain target:self action:nil];
    [buttons addObject:self.doctorNameButton];
    [toolsLeft setItems:buttons animated:NO];
    [buttons release];
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:toolsLeft] autorelease];
    [toolsLeft release];
}

-(void)viewDidAppear:(BOOL)animated{
    if([DataExchange getAppointmentRefreshIndex]==1){
        [DataExchange setAppointmentRefreshIndex:0];
        if(!self.activityController)
            self.activityController = [ISActivityOverlayController presentActivityOverViewController:self withLabel:@"Loading ..."];
        request_Numbe = 1;
        [self.service getSchedule2Invocation:[res.userRoleID stringValue] SubTenantId:[NSString stringWithFormat:@"%d",[DataExchange getSubTenantId]] CurrentDate:self.selectedDate Type:@"3" delegate:self];
    }
}

- (void)loadDataView{
    self.phone = [[NSMutableArray alloc]init];
    if([[DataExchange getSchedulerReponse] count] > 0){
        self.phone = [[[NSMutableArray alloc] initWithCapacity:[[DataExchange getSchedulerReponse] count]] autorelease];
        [self.phone addObjectsFromArray:[DataExchange getSchedulerReponse]];
    }
    
    if([[DataExchange getSchedulerReponse] count] > 0){
        NSString *imgName = [DataExchange getScheduleImageName];
        self.imgUrl = [[[NSMutableString alloc]initWithString:[NSString stringWithFormat:@"http://%@/image/",[DataExchange getDomainUrl]]] autorelease];
        if(imgName==NULL){
            imgView.image = [UIImage imageNamed:@""];
            [self.schedulerTable reloadData];
            return;
        }
        [self.imgUrl appendString:[imgName stringByReplacingOccurrencesOfString:@"\"" withString:@""]];
        
        if(!self.activityController)
            self.activityController = [ISActivityOverlayController presentActivityOverViewController:self withLabel:@"Loading ..."];
        switch (weekday) {
            case 1:
                [self showSundaySchedules];
                break;
            case 2:
                [self showMondaySchedules];
                break;
            case 3:
                [self showTuesdaySchedules];
                break;
            case 4:
                [self showWednesdaySchedules];
                break;
            case 5:
                [self showThursdaySchedules];
                break;
            case 6:
                [self showFridaySchedules];
                break;
            case 7:
                [self showSaturdaySchedules];
                break;
            default:
                break;
        }
        [self loadImage:self.imgUrl];
    }
    else{
        if (self.activityController) {
            [self.activityController dismissActivity];
            self.activityController = nil;
        }
       [Utils showAlert:@"No record found!" Title:@"Alert"];
    }
}

-(void)previous:(id)sender{
    
    request_Numbe = 1;
    if(!self.activityController)
        self.activityController = [ISActivityOverlayController presentActivityOverViewController:self withLabel:@"Loading ..."];
    
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateFormat:@"dd-MMM-yyyy"];
    
    // Retrieve NSDate instance from stringified date presentation
    NSDate *dateFromString = [dateFormatter dateFromString:self.selectedDate];

    NSDateComponents *dateComponents = [[[NSDateComponents alloc] init] autorelease];
    [dateComponents setDay:-7];
    
    NSDateComponents *dateComponents2 = [[[NSDateComponents alloc] init] autorelease];
    [dateComponents2 setDay:6];
    
    // Retrieve date with increased days count
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:dateFromString options:0];
    self.previousDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self.previousDate options:0];
    self.nextDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self.nextDate options:0];
    
    NSDate* tempNextDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents2 toDate:self.previousDate options:0];
    self.selectedDate = [dateFormatter stringFromDate:newDate];
    [self.previousButton setTitle:[NSString stringWithFormat:@"<< %@",[dateFormatter stringFromDate:self.previousDate]]];
    [self.nextButton setTitle:[NSString stringWithFormat:@"%@ >>",[dateFormatter stringFromDate:tempNextDate]]];
    [self.service getSchedule2Invocation:[res.userRoleID stringValue] SubTenantId:[NSString stringWithFormat:@"%d",[DataExchange getSubTenantId]] CurrentDate:self.selectedDate Type:@"3" delegate:self];
}

-(void)next:(id)sender{

    request_Numbe = 1;
    
    if(!self.activityController)
        self.activityController = [ISActivityOverlayController presentActivityOverViewController:self withLabel:@"Loading ..."];
    
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateFormat:@"dd-MMM-yyyy"];
    
    // Retrieve NSDate instance from stringified date presentation
    NSDate *dateFromString = [dateFormatter dateFromString:self.selectedDate];
    
    NSDateComponents *dateComponents = [[[NSDateComponents alloc] init] autorelease];
    [dateComponents setDay:7];
    
    NSDateComponents *dateComponents2 = [[[NSDateComponents alloc] init] autorelease];
    [dateComponents2 setDay:6];
    
    // Retrieve date with increased days count
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:dateFromString options:0];
    self.previousDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self.previousDate options:0];
    self.nextDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self.nextDate options:0];
    
    NSDate* tempNextDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents2 toDate:self.previousDate options:0];
    [self.previousButton setTitle:[NSString stringWithFormat:@"<< %@",[dateFormatter stringFromDate:self.previousDate]]];
    [self.nextButton setTitle:[NSString stringWithFormat:@"%@ >>",[dateFormatter stringFromDate:tempNextDate]]];
    self.selectedDate = [dateFormatter stringFromDate:newDate];
    [self.service getSchedule2Invocation:[res.userRoleID stringValue] SubTenantId:[NSString stringWithFormat:@"%d",[DataExchange getSubTenantId]] CurrentDate:self.selectedDate Type:@"3" delegate:self];
}

-(void)schedule:(id)sender{
    STPNFixAppointmentViewController* apntmntController = [[[STPNFixAppointmentViewController alloc] initWithNibName:@"STPNFixAppointmentViewController" bundle:nil] autorelease];
    self.popover = [[[UIPopoverController alloc] initWithContentViewController:apntmntController] autorelease];
    apntmntController.delegate = self;
    apntmntController.selectedIndex = [NSNumber numberWithInt:addPatSelectedIndex];
    apntmntController.selectedScheduleIndex = addPatSelectedScheduleIndex;
    if([DataExchange getAddPatient]!=Nil){
        apntmntController.patients = [[NSArray alloc] initWithObjects:[DataExchange getAddPatient], nil];
        [apntmntController setSelectedCell:0];
        [DataExchange setAddPatient:Nil];
    }
    [self.popover setPopoverContentSize:CGSizeMake(540, 372)];
    [self.popover presentPopoverFromRect:CGRectMake(200, 60, 1, 1) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
}

-(IBAction)hospitalBtnPressed{
    SubTenantsViewcontroller* controller = [[SubTenantsViewcontroller alloc] initWithNibName:@"SubTenantsViewcontroller" bundle:nil];
    controller.arraySubTenants = [DataExchange getSubTenantIds];
    controller.delegate = self;
    popover = [[UIPopoverController alloc] initWithContentViewController:controller];
    [controller release];
    [popover setPopoverContentSize:CGSizeMake(400, 20 + 50*[[DataExchange getSubTenantIds] count])];
    [popover presentPopoverFromRect:hospitalBtn.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
}

-(void)subTenantChoice:(NSInteger)index{
    [popover dismissPopoverAnimated:YES];
    [DataExchange setSubTenantIdIndex:index];
    [DataExchange setSubTenantId:[[(SubTenant*)[[DataExchange getSubTenantIds] objectAtIndex:index] SubTenantId] integerValue]];
    request_Numbe = 1;
    [DataExchange setHospitalName:[NSString stringWithFormat:@"%@",[(SubTenant*)[[DataExchange getSubTenantIds] objectAtIndex:index] SubTenantName]]];
    NSString* url = [NSMutableString stringWithFormat:@"%@GetUserDetails?sub_tenant_id=%d&UserRoleID=%@",[DataExchange getbaseUrl],[DataExchange getSubTenantId],[DataExchange getUserRoleId]];
    [self.service getStringResponseInvocation:url Identifier:@"GetUserDetails" delegate:self];
    [self.service getSchedule2Invocation:[res.userRoleID stringValue] SubTenantId:[NSString stringWithFormat:@"%d",[DataExchange getSubTenantId]] CurrentDate:self.selectedDate Type:@"3" delegate:self];
    [hospitalBtn setTitle:[NSString stringWithFormat:@"-%@-",[(SubTenant*)[[DataExchange getSubTenantIds] objectAtIndex:index] SubTenantName]] forState:UIControlStateNormal];
}

-(IBAction)showAllSchedules{
    for (int i=0; i<phone.count; i++) {
        isSectionCompressed[i]=false;
    }
    showAll = true;
    [self.schedulerTable reloadData];
}

-(IBAction)showMondaySchedules{
    currentDayString = @"Mon";
    currentDayIndex = phone.count;
    showAll = false;
    for (int i=0; i<phone.count; i++) {
        if([[phone objectAtIndex:i] isKindOfClass:[Schedule class]]){
            if([[(Schedule*)[phone objectAtIndex:i] day] compare:currentDayString options:NSCaseInsensitiveSearch]==NSOrderedSame){
                currentDayIndex = i;
                break;
            }
        }
    }
    for (int i=0; i<phone.count; i++) {
        isSectionCompressed[i]=false;
    }
    [DataExchange setScheduleDayIndex:currentDayIndex];
    [self.schedulerTable reloadData];
}

-(IBAction)showTuesdaySchedules{
    currentDayString = @"Tue";
    currentDayIndex = phone.count;
    showAll = false;
    for (int i=0; i<phone.count; i++) {
        if([[phone objectAtIndex:i] isKindOfClass:[Schedule class]]){
            if([[(Schedule*)[phone objectAtIndex:i] day] compare:currentDayString options:NSCaseInsensitiveSearch]==NSOrderedSame){
                currentDayIndex = i;
                break;
            }
        }
    }
    for (int i=0; i<phone.count; i++) {
        isSectionCompressed[i]=false;
    }
    [DataExchange setScheduleDayIndex:currentDayIndex];
    [self.schedulerTable reloadData];
}

-(IBAction)showWednesdaySchedules{
    currentDayString = @"Wed";
    currentDayIndex = phone.count;
    showAll = false;
    for (int i=0; i<phone.count; i++) {
        if([[phone objectAtIndex:i] isKindOfClass:[Schedule class]]){
            if([[(Schedule*)[phone objectAtIndex:i] day] compare:currentDayString options:NSCaseInsensitiveSearch]==NSOrderedSame){
                currentDayIndex = i;
                break;
            }
        }
    }
    for (int i=0; i<phone.count; i++) {
        isSectionCompressed[i]=false;
    }
    [DataExchange setScheduleDayIndex:currentDayIndex];
    [self.schedulerTable reloadData];
}

-(IBAction)showThursdaySchedules{
    currentDayString = @"Thu";
    currentDayIndex = phone.count;
    showAll = false;
    for (int i=0; i<phone.count; i++) {
        if([[phone objectAtIndex:i] isKindOfClass:[Schedule class]]){
            if([[(Schedule*)[phone objectAtIndex:i] day] compare:currentDayString options:NSCaseInsensitiveSearch]==NSOrderedSame){
                currentDayIndex = i;
                break;
            }
        }
    }
    for (int i=0; i<phone.count; i++) {
        isSectionCompressed[i]=false;
    }
    [DataExchange setScheduleDayIndex:currentDayIndex];
    [self.schedulerTable reloadData];
}

-(IBAction)showFridaySchedules{
    currentDayString = @"Fri";
    currentDayIndex = phone.count;
    showAll = false;
    for (int i=0; i<phone.count; i++) {
        if([[phone objectAtIndex:i] isKindOfClass:[Schedule class]]){
            if([[(Schedule*)[phone objectAtIndex:i] day] compare:currentDayString options:NSCaseInsensitiveSearch]==NSOrderedSame){
                currentDayIndex = i;
                break;
            }
        }
    }
    for (int i=0; i<phone.count; i++) {
        isSectionCompressed[i]=false;
    }
    [DataExchange setScheduleDayIndex:currentDayIndex];
    [self.schedulerTable reloadData];
}

-(IBAction)showSaturdaySchedules{
    currentDayString = @"Sat";
    currentDayIndex = phone.count;
    showAll = false;
    for (int i=0; i<phone.count; i++) {
        if([[phone objectAtIndex:i] isKindOfClass:[Schedule class]]){
            if([[(Schedule*)[phone objectAtIndex:i] day] compare:currentDayString options:NSCaseInsensitiveSearch]==NSOrderedSame){
                currentDayIndex = i;
                break;
            }
        }
    }
    for (int i=0; i<phone.count; i++) {
        isSectionCompressed[i]=false;
    }
    [DataExchange setScheduleDayIndex:currentDayIndex];
    [self.schedulerTable reloadData];
}

-(IBAction)showSundaySchedules{
    currentDayString = @"Sun";
    currentDayIndex = phone.count;
    showAll = false;
    for (int i=0; i<phone.count; i++) {
        if([[phone objectAtIndex:i] isKindOfClass:[Schedule class]]){
            if([[(Schedule*)[phone objectAtIndex:i] day] compare:currentDayString options:NSCaseInsensitiveSearch]==NSOrderedSame){
                currentDayIndex = i;
                break;
            }
        }
    }
    for (int i=0; i<phone.count; i++) {
        isSectionCompressed[i]=false;
    }
    [DataExchange setScheduleDayIndex:currentDayIndex];
    [self.schedulerTable reloadData];
}

-(void)selectLogout:(id)sender{
    [DataExchange setScheduleDayIndex:0];
    UINavigationController* nvc = self.tabBarController.navigationController;
	NSArray* controllers = [nvc viewControllers];
	UIViewController* tvc = Nil;
	for (UIViewController* vc in controllers) { 
        if ([vc isKindOfClass:[STPNLoggedIn class]]) {
			tvc = (UIViewController *)(STPNLoggedIn*)vc;
			break;
		}
	}
    
    [self.tabBarController.navigationController popToViewController:tvc animated:YES];
}

-(void)loadImage:(NSString *)imgurl{
    if([imgurl length] > 0){
        
        UIImage *image = [_iconDownloader iconForUrl:imgurl];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0] ;
        
        if (image == Nil) {
            [_iconDownloader startDownloadForUrl:imgurl withSize:kIconSize forIndexPath:indexPath];
            
        }
        else {	
            if (self.activityController) {
                [self.activityController dismissActivity];
                self.activityController = nil;
            }
            imgView.image = image;
        }
    }
}

-(void)stopImageCache {
	if (_iconDownloader != Nil) {
		[_iconDownloader cancelDownload];
		[_iconDownloader release];
		_iconDownloader = Nil;
	}
}

-(void)iconDownloadedForUrl:(NSString*)url forIndexPaths:(NSArray*)paths withImage:(UIImage*)img withDownloader:(ImageCache*)downloader {
	[self loadImage:self.imgUrl];
}

#pragma mark table View
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if(showAll)
        return [phone count];
    else{
        int count=0;
        for (int i=0; i<phone.count; i++) {
            Schedule *sec = [phone objectAtIndex:i];
            if ([sec.day isEqualToString:currentDayString]) {
                count++;
            }
        }
        if(count==0)
            return 1;
        else
            return count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(showAll){
        Schedule *sec = [phone objectAtIndex:section];
        return [sec.appointments count];
    }else if(isSectionCompressed[section]){
        return 0;
    }else if(currentDayIndex<phone.count){
        Schedule *sec;
        int count=0;
        int i=0;
        for (i=0; i<phone.count; i++) {
            Schedule *secTemp = [phone objectAtIndex:i];
            if ([secTemp.day isEqualToString:currentDayString]) {
                count++;
                if(count==section+1)
                    break;
            }
        }
        sec = [phone objectAtIndex:i];
        if([sec.current_status isEqualToString:@"Active"]){
            return [sec.appointments count];
        }else{
            return 0;
        }
    }else
        return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSMutableString *sectionTitle = [[[NSMutableString alloc] init] autorelease];
    
    Schedule *sec;
    if(showAll)
        sec = [phone objectAtIndex:section];
    else if(currentDayIndex<phone.count){
        int count=0;
        int i=0;
        for (i=0; i<phone.count; i++) {
            Schedule *secTemp = [phone objectAtIndex:i];
            if ([secTemp.day isEqualToString:currentDayString]) {
                count++;
                if(count==section+1)
                    break;
            }
        }
        sec = [phone objectAtIndex:i];
        
    }
    else{
        UIView *view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)] autorelease];
        view.backgroundColor = [[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"cell_bg.png"]] autorelease];
        
        UILabel *lblDay = [[[UILabel alloc] init] autorelease];
        lblDay.frame = CGRectMake(0, 0, 320, 30);
        lblDay.backgroundColor = [UIColor clearColor];
        lblDay.textColor = [UIColor blackColor];
        lblDay.shadowColor = [UIColor whiteColor];
        lblDay.textAlignment = UITextAlignmentCenter;
        lblDay.shadowOffset = CGSizeMake(0.0, 1.0);
        lblDay.font = [UIFont boldSystemFontOfSize:16];
        lblDay.numberOfLines = 1;
        lblDay.text = @"No Appointments";
        [view addSubview:lblDay];
        
        UILabel *lblDate = [[[UILabel alloc] init] autorelease];
        lblDate.frame = CGRectMake(0, 30, 320, 30);
        lblDate.backgroundColor = [UIColor clearColor];
        lblDate.textColor = [UIColor blackColor];
        lblDate.shadowColor = [UIColor whiteColor];
        lblDate.textAlignment = UITextAlignmentRight;
        lblDate.shadowOffset = CGSizeMake(0.0, 1.0);
        lblDate.font = [UIFont boldSystemFontOfSize:16];
        lblDate.numberOfLines = 1;
        NSDateFormatter *df = [[[NSDateFormatter alloc] init] autorelease];
        [df setDateFormat:@"dd-MMM-yyyy hh:mm:ss"];
        lblDate.text = [df stringFromDate:[NSDate date]];
        [view addSubview:lblDate];
        
        return view;
    }
    
    [sectionTitle appendString : [DataExchange militaryToTwelveHr:sec.from_time]];
    [sectionTitle appendString:@"-"];
    [sectionTitle appendString : [DataExchange militaryToTwelveHr:sec.to_time]];
    
    [sectionTitle appendString:@"\n"];
    [sectionTitle appendString: sec.schedule_name];
    
    if (sectionTitle == nil) {
        return nil;
    }
    
    // Create label with section title
    UILabel *label = [[[UILabel alloc] init] autorelease];
    label.frame = CGRectMake(20, 6, 300, 60);
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor blackColor];
    label.shadowColor = [UIColor whiteColor];
    label.shadowOffset = CGSizeMake(0.0, 1.0);
    label.font = [UIFont boldSystemFontOfSize:16];
    label.numberOfLines = 2;
    label.text = sectionTitle;
    
    // Create header view and add label as a subview
    UIView *view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)] autorelease];
    view.backgroundColor = [[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"cell_bg.png"]] autorelease];
    [view addSubview:label];
    
    UILabel *lblDay = [[[UILabel alloc] init] autorelease];
    lblDay.frame = CGRectMake(150, 30, 150, 30);
    lblDay.backgroundColor = [UIColor clearColor];
    lblDay.textColor = [UIColor blackColor];
    lblDay.shadowColor = [UIColor whiteColor];
    lblDay.textAlignment = UITextAlignmentRight;
    lblDay.shadowOffset = CGSizeMake(0.0, 1.0);
    lblDay.font = [UIFont boldSystemFontOfSize:16];
    lblDay.numberOfLines = 1;
    lblDay.text = sec.day;
    [view addSubview:lblDay];
    if(![sec.current_status isEqualToString:@"Active"]){
        [lblDay setTextColor:[UIColor redColor]];
        [lblDay setText:@"Schedule Blocked"];
        isSectionCompressed[section]=TRUE;
    }
    
    UILabel *lblDate = [[[UILabel alloc] init] autorelease];
    lblDate.frame = CGRectMake(150, 5, 150, 30);
    lblDate.backgroundColor = [UIColor clearColor];
    lblDate.textColor = [UIColor blackColor];
    lblDate.shadowColor = [UIColor whiteColor];
    lblDate.textAlignment = UITextAlignmentRight;
    lblDate.shadowOffset = CGSizeMake(0.0, 1.0);
    lblDate.font = [UIFont boldSystemFontOfSize:16];
    lblDate.numberOfLines = 1;
    NSDateFormatter *df = [[[NSDateFormatter alloc] init] autorelease];
    [df setDateFormat:@"dd-MMM-yyyy"];
    lblDate.text = [df stringFromDate:[STPNAppointmentRootViewController mfDateFromDotNetJSONString:sec.date]];
    [view addSubview:lblDate];
    
    UIButton* overlayBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
    overlayBtn.tag = 10+section;
    [overlayBtn addTarget:self action:@selector(toggleSection:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:overlayBtn];
    return view;
}

-(void)toggleSection:(id)sender{
    int section = [(UIButton*)sender tag]-10;
    isSectionCompressed[section] = !isSectionCompressed[section];
    [self.schedulerTable reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 60.00;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.00;
}



//customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Schedule *sec;
    int count=0;
    int i=0;

    if(showAll)
        sec = [phone objectAtIndex:indexPath.section];
    else{
        for (i=0; i<phone.count; i++) {
            Schedule *secTemp = [phone objectAtIndex:i];
            if ([secTemp.day isEqualToString:currentDayString]) {
                count++;
                if(count==indexPath.section+1)
                    break;
            }
        }
        sec = [phone objectAtIndex:i];
    }
    
    static NSString* sRowCell = @"RowCell";	
    cell = (ScheduleTableCell*)[self.schedulerTable dequeueReusableCellWithIdentifier:sRowCell];	
    if (Nil == cell) {
        cell = [ScheduleTableCell createTextRowWithOwner:self withDelegate:self];
    }
    
    Appointment *appoint = [sec.appointments objectAtIndex:indexPath.row];
    
    if ([[appoint.AvlStatusId stringValue] isEqualToString:@"2"]) {
        NSMutableString *strTime = [[NSMutableString alloc]init];
        [strTime appendString:[DataExchange militaryToTwelveHr:appoint.FromTime]];
        [strTime appendString:@"-"];
        [strTime appendString:[DataExchange militaryToTwelveHr:appoint.ToTime]];
        
        cell.lblTime.text = strTime;    
        cell.btnLock.hidden = YES;
        cell.btnMove.tag = 1;
        cell.btnDelete.tag = 2;
        
        //New code
        [cell.btnMove setBackgroundImage:[UIImage imageNamed:@"move.png"] forState:UIControlStateNormal];
        [cell.btnDelete setBackgroundImage:[UIImage imageNamed:@"delete.png"] forState:UIControlStateNormal];

//Old Code
        //[cell.btnMove setImage:[UIImage imageNamed:@"move.png"] forState:UIControlStateNormal];
       // [cell.btnDelete setImage:[UIImage imageNamed:@"delete.png"] forState:UIControlStateNormal];
        [strTime release];
        
        unsigned int flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit;
        NSCalendar* calendar = [NSCalendar currentCalendar];
        
        NSInteger hourVal = [[[appoint.FromTime componentsSeparatedByString:@":"] objectAtIndex:0] integerValue];
        NSInteger minutesValue = [[[appoint.FromTime componentsSeparatedByString:@":"] objectAtIndex:1] integerValue];
        NSDateComponents* components = [calendar components:flags fromDate:[STPNAppointmentRootViewController mfDateFromDotNetJSONString:sec.date]];
        [components setHour:hourVal];
        [components setMinute:minutesValue];
        NSDate* date1Only = [calendar dateFromComponents:components];
        
        NSDateComponents* components2 = [calendar components:flags fromDate:[NSDate date]];
        NSDate* date2Only = [calendar dateFromComponents:components2];
        
        if([date1Only compare:date2Only]==NSOrderedAscending){
            cell.btnMove.hidden = YES;
            cell.btnDelete.hidden = YES;
        }
    }
    else if ([[appoint.AvlStatusId stringValue] isEqualToString:@"1"]) {
        
        NSMutableString *strTime = [[NSMutableString alloc]init];
        [strTime appendString:[DataExchange militaryToTwelveHr:appoint.FromTime]];
        [strTime appendString:@"-"];
        [strTime appendString:[DataExchange militaryToTwelveHr:appoint.ToTime]];
        
        cell.lblTime.text = strTime;
        cell.lblDiscription.text = nil;
        cell.btnDesc.hidden = YES;
        cell.btnMove.tag = 3;
        cell.btnDelete.tag = 4;
        //new code
        [cell.btnMove setBackgroundImage:[UIImage imageNamed:@"fix.png"] forState:UIControlStateNormal];
        [cell.btnDelete setBackgroundImage:[UIImage imageNamed:@"block.png"] forState:UIControlStateNormal];
//oldcode
        
       //[cell.btnMove setImage:[UIImage imageNamed:@"fix.png"] forState:UIControlStateNormal];
       // [cell.btnDelete setImage:[UIImage imageNamed:@"block.png"] forState:UIControlStateNormal];
        
        
        
        
        cell.btnLock.hidden = YES;
        
        
        
        
        
        [strTime release];
        
        unsigned int flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit;
        NSCalendar* calendar = [NSCalendar currentCalendar];
        
        NSInteger hourVal = [[[appoint.FromTime componentsSeparatedByString:@":"] objectAtIndex:0] integerValue];
        NSInteger minutesValue = [[[appoint.FromTime componentsSeparatedByString:@":"] objectAtIndex:1] integerValue];
        NSDateComponents* components = [calendar components:flags fromDate:[STPNAppointmentRootViewController mfDateFromDotNetJSONString:sec.date]];
        [components setHour:hourVal];
        [components setMinute:minutesValue];
        NSDate* date1Only = [calendar dateFromComponents:components];
        
        NSDateComponents* components2 = [calendar components:flags fromDate:[NSDate date]];
        NSDate* date2Only = [calendar dateFromComponents:components2];
        
        if([date1Only compare:date2Only]==NSOrderedAscending){
            cell.btnMove.hidden = YES;
            cell.btnDelete.hidden = YES;
        }
    }
    else if ([[appoint.AvlStatusId stringValue] isEqualToString:@"3"]) {
        
        NSMutableString *strTime = [[NSMutableString alloc]init];
        [strTime appendString:[DataExchange militaryToTwelveHr:appoint.FromTime]];
        [strTime appendString:@"-"];
        [strTime appendString:[DataExchange militaryToTwelveHr:appoint.ToTime]];
        
        cell.lblTime.text = strTime;
        cell.lblDiscription.text = nil;
        cell.btnDesc.hidden = YES;
        cell.btnMove.hidden = YES;
        cell.btnDelete.hidden = YES;
        cell.btnLock.hidden = NO;
        [cell.btnLock setImage:[UIImage imageNamed:@"unblock.png"] forState:UIControlStateNormal];
        [strTime release];
    }
    Patdemographics *pat = [appoint.patdemographics objectAtIndex:0];
    if(pat != NULL){
        NSMutableString *strDesc = [[[NSMutableString alloc]init] autorelease];
        [strDesc appendString:pat.patName];
        [strDesc appendString:@","];
        if ( [pat.patDOB length]!=0) {
            NSDateFormatter *df = [[[NSDateFormatter alloc] init] autorelease];
            [df setDateFormat:@"dd-MMM-yyyy"];
            NSString *dob;
            dob = [CurrentVisitDetailViewController AgeFromString:[df stringFromDate:[PharmacyViewController mfDateFromDotNetJSONString:pat.patDOB]]];
            dob = [dob stringByReplacingOccurrencesOfString:@"Years" withString:@""];
            [strDesc appendFormat:@"%@",dob];
            [strDesc appendString:@","];
        }
        if ([[pat.genderID stringValue] isEqualToString:@"1"]) {
            [strDesc appendString:@" M"];
        }else if ([[pat.genderID stringValue] isEqualToString:@"2"]) {
            [strDesc appendString:@" F"];
        }
        cell.lblDiscription.text = strDesc;
        cell.btnDesc.hidden = false;
        cell.lblDiscription.hidden = false;
    }
    else{
        cell.btnDesc.hidden = YES;
        cell.lblDiscription.hidden = true;
    }
    if(showAll)
        cell.selectedScheduleIndex = indexPath.section;
    else{
        cell.selectedScheduleIndex = i;
    }
    cell.tag=indexPath.row;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.clipsToBounds = TRUE;
    
    return cell;
}

#pragma mark others
-(UIImage* ) resizedImage:(UIImage *)inImage andRect:(CGRect)thumbRect
{
    CGImageRef			imageRef = [inImage CGImage];
    CGImageAlphaInfo	alphaInfo = CGImageGetAlphaInfo(imageRef);
    
    if (alphaInfo == kCGImageAlphaNone)
        alphaInfo = kCGImageAlphaNoneSkipLast;
    
    // Build a bitmap context that's the size of the thumbRect
    CGContextRef bitmap = CGBitmapContextCreate(NULL,thumbRect.size.width,		// width
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

-(NSString *)processString:(NSString *)_string{
    
    NSString *temp;
    NSRange range = {0,5};
    temp = [_string substringWithRange:range];
    temp = [temp stringByReplacingOccurrencesOfString:@":" withString:@"."];
    return temp;
}

-(void) changeFixBtnValue:(ScheduleTableCell*)cellValue{
    if(cellValue.btnMove.tag == 3){
        STPNFixAppointmentViewController *addController = [[STPNFixAppointmentViewController alloc] initWithNibName:@"STPNFixAppointmentViewController" bundle:nil];
        addController.delegate = self;
        addController.selectedIndex = [NSNumber numberWithInt:cellValue.tag];
        addController.selectedScheduleIndex = cellValue.selectedScheduleIndex;
        addPatSelectedIndex = [cellValue tag];
        addPatSelectedScheduleIndex = cellValue.selectedScheduleIndex;
        if([DataExchange getAddPatient]!=Nil){
            addController.patients = [[NSArray alloc] initWithObjects:[DataExchange getAddPatient], nil];
            [addController setSelectedCell:0];
            [DataExchange setAddPatient:Nil];
        }
        self.popover = [[[UIPopoverController alloc] initWithContentViewController:addController] autorelease];
        self.popover.popoverContentSize = CGSizeMake(540, 410);
        [self.popover presentPopoverFromRect:CGRectMake(250, 60, 1, 1) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
        [addController release];
    }
    else{
        
        STPNMoveAppointmentViewController *addController = [[STPNMoveAppointmentViewController alloc] initWithNibName:@"STPNMoveAppointmentViewController" bundle:nil];        
        addController.delegate = self;
        addController.selectedIndex = [NSNumber numberWithInt:cellValue.tag];
        addController.selectedScheduleIndex = cellValue.selectedScheduleIndex;
        self.popover = [[[UIPopoverController alloc] initWithContentViewController:addController] autorelease]; 
        self.popover.popoverContentSize = CGSizeMake(540, 372);
        [self.popover presentPopoverFromRect:CGRectMake(250, 60, 1, 1) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
        [addController release];
    }
}

-(void) changeBlockBtnValue:(ScheduleTableCell*)cellValue{
    if(cellValue.btnDelete.tag == 4){
        STPNBlockAppointmentViewController *addController = [[STPNBlockAppointmentViewController alloc] initWithNibName:@"STPNBlockAppointmentViewController" bundle:nil];
        addController.delegate = self;
        addController.hospitalName = [(SubTenant*)[[DataExchange getSubTenantIds] objectAtIndex:[DataExchange getSubTenantIdIndex]] SubTenantName];
        addController.selectedIndex = [NSNumber numberWithInt:cellValue.tag];
        addController.selectedScheduleIndex = cellValue.selectedScheduleIndex;
        Schedule *sec = [[DataExchange getSchedulerReponse] objectAtIndex:cellValue.selectedScheduleIndex];
        addController.appoint = [sec.appointments objectAtIndex:cellValue.tag];
        self.popover = [[[UIPopoverController alloc] initWithContentViewController:addController] autorelease]; 
        self.popover.popoverContentSize = CGSizeMake(540, 300);
        [self.popover presentPopoverFromRect:CGRectMake(250, 60, 1, 1) inView:cellValue.btnMove permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
        [addController release];
    }
    else{
        self.currIndexPath = [NSIndexPath indexPathForRow:cellValue.tag inSection:cellValue.selectedScheduleIndex];
        selectedIndex = [NSNumber numberWithInt:cellValue.tag];
        proAlertView *alert = [[proAlertView alloc] initWithTitle:@"Delete" message:@"Do you really want to delete this appointment?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
        [alert setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
        [alert show];
        [alert release];
    }
}

-(void) descBtnClick:(ScheduleTableCell*)cellValue{
    [DataExchange setSchedulerResponse:phone];
    selectedIndex = [NSNumber numberWithInt:cellValue.tag];
    
    Schedule *sec = [phone objectAtIndex:cellValue.selectedScheduleIndex];
    [DataExchange setScheduleDayIndex:cellValue.selectedScheduleIndex];
    Appointment *appoint = [sec.appointments objectAtIndex:cellValue.tag];
        
    Patdemographics *pat = [appoint.patdemographics objectAtIndex:0];
    
    Booking *bk = [appoint.bookings objectAtIndex:0];
    appointmentController = [[AppointmentViewController alloc] init];
    
    UITabBarController *tabBar = [self tabBarController];
    [tabBar setSelectedIndex:1];
    NSArray* temp = [tabBar viewControllers];
    appointmentController = [[AppointmentViewController alloc] init];
    appointmentController.pat = pat;
    appointmentController.currentIndex = [selectedIndex integerValue];
    appointmentController.phone = [[[NSMutableArray alloc] initWithArray:self.phone] autorelease];
    appointmentController.patMrno = [bk.mrno stringValue];
    [[temp objectAtIndex:1] popToRootViewControllerAnimated:NO];
    [[temp objectAtIndex:1] pushViewController:appointmentController animated:YES];
}

-(void) lockBtnClick:(ScheduleTableCell*)cellValue{
    self.currIndexPath = [NSIndexPath indexPathForRow:cellValue.tag inSection:cellValue.selectedScheduleIndex];
    selectedIndex = [NSNumber numberWithInt:cellValue.tag];
    proAlertView *alert = [[proAlertView alloc] initWithTitle:@"Unlock" message:@"Do you really want to unblock this appointment?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    [alert setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
    [alert show];
    [alert release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger) index
{	
    Schedule *sec = [[DataExchange getSchedulerReponse] objectAtIndex:self.currIndexPath.section];
    Appointment *appot = [sec.appointments objectAtIndex:self.currIndexPath.row];
    	
	if(index == 1 && [alertView.title isEqualToString:@"Unlock"])
	{
        self.activityController = [ISActivityOverlayController presentActivityOverViewController:self withLabel:@"Loading ..."];    
        [self.service postAppointmentInvocation:@"D" UserRollId:[res.userRoleID stringValue] AppId:appot.AppId delegate:self];
	}
	else if(index == 1 && [alertView.title isEqualToString:@"Delete"]) {
        if(!self.activityController)
            self.activityController = [ISActivityOverlayController presentActivityOverViewController:self withLabel:@"Loading ..."];    
		[self.service postAppointmentInvocation:@"D" UserRollId:[res.userRoleID stringValue] AppId:appot.AppId delegate:self];
	}
}

-(void)postAppointmentDidFinish:(PostAppointmentInvocation*)invocation withError:(NSError*)error{
    request_Numbe = 1;
    [self.service getScheduleInvocation:[res.userRoleID stringValue] CurrentDate:self.selectedDate Type:@"1" delegate:self];
}

-(void)fetchImageNameURL{
    request_Numbe = 2;
    [self.service getScheduleInvocation:[res.userRoleID stringValue] CurrentDate:self.selectedDate Type:@"2" delegate:self];
}

-(void)GetDocAddrInvocationDidFinish:(GetDocAddrOrContInvocation *)invocation 
                 withDocAddressArray:(NSArray *)doctReferArray 
                           withError:(NSError *)error{
    if(!error){
        [DataExchange setAreaID:[NSString stringWithFormat:@"%d",[[(PatientAddress*)[doctReferArray objectAtIndex:0] AreaId] integerValue]]];
    }
}

-(void)GetStringInvocationDidFinish:(GetStringInvocation *)invocation 
                 withResponseString:(NSString *)responseString 
                     withIdentifier:(NSString *)identifier 
                          withError:(NSError *)error{
    if(!error){
        NSArray* response = [responseString JSONValue];
        if([identifier isEqualToString:@"GetUserDetails"]){
            if([response isKindOfClass:[NSNull class]]){
                return;
            }
            
            NSDictionary* dictDisp = [(NSDictionary*)response objectForKey:@"DisplayLabel"];
            NSMutableArray* arrayDisplaySettings = [[NSMutableArray alloc] init];
            if(![dictDisp isKindOfClass:[NSNull class]]){
                [arrayDisplaySettings addObject:(![[dictDisp objectForKey:@"Line1"] isKindOfClass:[NSNull class]]?[dictDisp objectForKey:@"Line1"]:@"")];
                [arrayDisplaySettings addObject:(![[dictDisp objectForKey:@"Line2"]  isKindOfClass:[NSNull class]]?[dictDisp objectForKey:@"Line2"]:@"")];
                [arrayDisplaySettings addObject:(![[dictDisp objectForKey:@"Line3"]  isKindOfClass:[NSNull class]]?[dictDisp objectForKey:@"Line3"]:@"")];
                [arrayDisplaySettings addObject:(![[dictDisp objectForKey:@"Line4"]  isKindOfClass:[NSNull class]]?[dictDisp objectForKey:@"Line4"]:@"")];
            }
            if(arrayDisplaySettings.count==0){
                [arrayDisplaySettings addObject:@""];
                [arrayDisplaySettings addObject:@""];
                [arrayDisplaySettings addObject:@""];
                [arrayDisplaySettings addObject:@""];
            }
            [DataExchange setDocDisplayData:[[NSMutableArray alloc] initWithArray:arrayDisplaySettings copyItems:YES]];
        }
    }
}

-(void)getScheduleInvocationDidFinish:(GetScheduleInvocation*)invocation
                         withSchedule:(NSArray*)schedules
                            withError:(NSError*)error{
    if(!error){
        if(request_Numbe == 1){
            if([schedules count] > 0){
                
                [DataExchange setSchedulerResponse:schedules];
                [DataExchange setScheduleData:schedules];
                [self fetchImageNameURL];
            }
            else{
                [DataExchange setSchedulerResponse:schedules];
                [DataExchange setScheduleData:schedules];
                self.phone = [[NSMutableArray alloc] init];
                [schedulerTable reloadData];
                imgView.image = nil;
                [Utils showAlert:@"No record found!" Title:@"Alert"];
                if (self.activityController) {
                    [self.activityController dismissActivity];
                    self.activityController = nil;
                }
            }
        }
        else if(request_Numbe == 2){
            if([schedules count] > 0){
                NSMutableString* str = [NSString stringWithFormat:@"%@",[schedules objectAtIndex:0]];
                if(str==NULL)
                    str = [NSString stringWithFormat:@"%@",@" "];
                [DataExchange setScheduleImageName:str];
                [self loadDataView];
            }
            else{
                [Utils showAlert:@"No record found!" Title:@"Alert"];
                if (self.activityController) {
                    [self.activityController dismissActivity];
                    self.activityController = nil;
                }
            }
        }
    }
    else{
        [Utils showAlert:@"\nCould not retrieve data.\n\nPlease check you Network setting and try again later.\nApplication will be terminated unexpectfully or action doesn't perform anything!" Title:@"Connection  Login"];
        if (self.activityController) {
            [self.activityController dismissActivity];
            self.activityController = nil;
        }
    }
}

+ (NSDate *)mfDateFromDotNetJSONString:(NSString *)string{
    static NSRegularExpression *dateRegEx = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateRegEx = [[NSRegularExpression alloc] initWithPattern:@"^\\/date\\((-?\\d++)(?:([+-])(\\d{2})(\\d{2}))?\\)\\/$" options:NSRegularExpressionCaseInsensitive error:nil];
    });
    NSTextCheckingResult *regexResult = [dateRegEx firstMatchInString:string options:0 range:NSMakeRange(0, [string length])];
    
    if (regexResult) {
        // milliseconds
        NSTimeInterval seconds = [[string substringWithRange:[regexResult rangeAtIndex:1]] doubleValue] / 1000.0;
        // timezone offset
        if ([regexResult rangeAtIndex:2].location != NSNotFound) {
            NSString *sign = [string substringWithRange:[regexResult rangeAtIndex:2]];
            // hours
            seconds += [[NSString stringWithFormat:@"%@%@", sign, [string substringWithRange:[regexResult rangeAtIndex:3]]] doubleValue] * 60.0 * 60.0;
            // minutes
            seconds += [[NSString stringWithFormat:@"%@%@", sign, [string substringWithRange:[regexResult rangeAtIndex:4]]] doubleValue] * 60.0;
        }
        return [NSDate dateWithTimeIntervalSince1970:seconds];
    }
    return nil;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self stopImageCache];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
   // return UIInterfaceOrientationIsLandscape(interfaceOrientation);
    return UIInterfaceOrientationLandscapeRight;
}

@end
