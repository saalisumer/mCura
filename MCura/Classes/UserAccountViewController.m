//
//  UserAccountViewController.m
//  mCura
//
//  Created by Aakash Chaudhary on 02/04/12.
//  Copyright (c) 2012 aakash272@gmail.com. All rights reserved.
//

#import "UserAccountViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "Patdemographics.h"
#import "Utils.h"
#import "ISActivityOverlayController.h"
#import "_GMDocService.h"
#import "GetLabInvocation.h"
#import "GetPharmacyInvocation.h"
#import "GetPatientContactDetail.h"
#import "ImageCache.h"
#import "Response.h"
#import "DataExchange.h"
#import "PatientContactDetails.h"
#import "Schedule.h"
#import "DeviceDeatils.h"
#import "STPNLoggedIn.h"
#import "BusinessPairingView.h"
#import "ReportsView.h"
#import "HelpView.h"
#import "ProfileSetingsView.h"
#import "TemplatesView.h"
#import "Schedule.h"
#import "SubTenant.h"

#define Schedules 0
#define Business_Pairing (Schedules+1)
#define Templates (Business_Pairing+1)
#define Reports (Templates+1)
#define Profile_settings (Reports+1)
#define Help (Profile_settings+1)
#define My_Account (Help+1)

@interface UserAccountViewController (private)<GetPatientContactDetailDelegate, ImageCacheDelegate,GetLabInvocationDelegate,GetPharmacyInvocationDelegate>
@end

@implementation UserAccountViewController

@synthesize tblView,pat,sch,templatesView,repView,profSetView;
@synthesize activityController, service,arrPharmaPlusLab;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];    
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.service = [[[_GMDocService alloc] init] autorelease];
    
    self.navigationItem.titleView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mCURA.png"]] autorelease];
    
    UIBarButtonItem* bi = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(selectLogout:)];
    bi.style = UIBarButtonItemStyleBordered;
    self.navigationItem.rightBarButtonItem = bi;
    [bi release];
    
    self.sch = [[ScheduleView alloc] initWithParent:self];
    self.activityController = [ISActivityOverlayController presentActivityOverViewController:self withLabel:@"Loading..."];
    Schedule *sec = [[DataExchange getSchedulerReponse] objectAtIndex:0];
    [self.service getPharmacyInvocation:[DataExchange getUserRoleId] SchedulesId:sec.schedule_id forType:2 delegate:self];
    self.arrPharmaPlusLab = [[NSMutableArray alloc] init];
    self.tblView.rowHeight = 60;
}

-(void)viewWillAppear:(BOOL)animated{
    UIToolbar* toolsLeft = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 200, 44.01)];
    NSMutableArray *buttons = [[NSMutableArray alloc] initWithCapacity:3];
    UIBarButtonItem* bi = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back.png"] style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
    [buttons addObject:bi];
    [bi release];
    bi = [[UIBarButtonItem alloc] initWithTitle:@"Welcome" style:UIBarButtonItemStylePlain target:self action:nil];
    [buttons addObject:bi];
    [bi release];
    NSString* str=[(UserDetail*)[[DataExchange getUserResult] objectAtIndex:0] u_name];
    bi = [[UIBarButtonItem alloc] initWithTitle:str style:UIBarButtonItemStylePlain target:self action:nil];
    [buttons addObject:bi];
    [bi release];
    [toolsLeft setItems:buttons animated:NO];
    [buttons release];
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:toolsLeft] autorelease];
    [toolsLeft release];
}

-(void) getLabInvocationDidFinish:(GetLabInvocation*)invocation
                         withLabs:(NSArray*)Labs
                        withError:(NSError*)error{
    if(!error){
        for (int i=0; i<Labs.count; i++){
            [self.arrPharmaPlusLab addObject:[Labs objectAtIndex:i]];
        }
        self.sch.arrPharmaPlusLab = [[NSMutableArray alloc] initWithArray:self.arrPharmaPlusLab];
        self.sch.arraySubTenants = [[NSMutableArray alloc] initWithArray:arrayOfSubTenants];
        for (int i=0; i<Labs.count; i++){
            [arrSubtenIds addObject:[(SubTenant*)[Labs objectAtIndex:i] SubTenantId]];
        }
        self.sch.arraySubTenantIds = arrSubtenIds;
        [self.sch reloadDataOfFacility];
        [currentSettingsView addSubview:self.sch];
    }
    if(self.activityController){
        [self.activityController dismissActivity];
        self.activityController = nil;
    }
}

-(void) getPharmacyInvocationDidFinish:(GetPharmacyInvocation*)invocation
                         withPharmacys:(NSArray*)pharmacys
                             withError:(NSError*)error{
    if(!error){
        if([pharmacys count] > 0){
            arrSubtenIds = [[NSMutableArray alloc] init];
            for (int i=0; i<pharmacys.count; i++){
                [arrSubtenIds addObject:[(SubTenant*)[pharmacys objectAtIndex:i] SubTenantId]];
            }
            arrayOfSubTenants = [[NSMutableArray alloc] initWithArray:pharmacys];
            self.arrPharmaPlusLab = [[NSMutableArray alloc] init];
            Schedule *sec = [[DataExchange getSchedulerReponse] objectAtIndex:0];
            [self.service getLabInvocation:[DataExchange getUserRoleId] SchedulesId:sec.schedule_id forType:2 delegate:self];
        }
    }
}

-(void)selectLogout:(id)sender{
    
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

-(void)back:(id)sender{
    UITabBarController *tabBar = [self tabBarController];
    [tabBar setSelectedIndex:0];    
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
   UITableViewCell *cell = [self.tblView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    }
    
    cell.textLabel.font = [UIFont systemFontOfSize:26];

    switch (indexPath.row) {
        case Schedules:
            cell.textLabel.text = @"Schedule";
            cell.imageView.image = [UIImage imageNamed:@"Schedule.png"];
            break;
        case Business_Pairing:
            cell.textLabel.text = @"Business Pairing";
            cell.imageView.image = [UIImage imageNamed:@"BizPair.png"];
            break;
        case Reports:
            cell.textLabel.text = @"Reports";
            cell.imageView.image = [UIImage imageNamed:@"SettingsReport.png"];
            break;
        case Templates:
            cell.textLabel.text = @"Templates";
            cell.imageView.image = [UIImage imageNamed:@"SettingsTemplate.png"];
            break;
        case Profile_settings:
            cell.textLabel.text = @"Profile Settings";
            cell.imageView.image = [UIImage imageNamed:@"Profile Setting.png"];
            break;
        case Help:
            cell.textLabel.text = @"Help";
            cell.imageView.image = [UIImage imageNamed:@"Help.png"];
            break;
        default:
            break;
    }    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row%2==0) {
        cell.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    for (UIView* view in [currentSettingsView subviews]) {
        [view removeFromSuperview];
        view = nil;
    }
    switch (indexPath.row) {
        case Schedules:
            self.sch = [[ScheduleView alloc] initWithParent:self];
            self.sch.arraySubTenants = arrayOfSubTenants;
            self.sch.arrPharmaPlusLab = self.arrPharmaPlusLab;
            [self.sch reloadDataOfFacility];
            [currentSettingsView addSubview:self.sch];
            break;
        case Business_Pairing:
            [currentSettingsView addSubview:[[BusinessPairingView alloc] initWithParent:self]];
            break;
        case Reports:
            self.repView = [[ReportsView alloc] initWithParent:self];
            [currentSettingsView addSubview:self.repView];
            break;
        case Templates:
            self.templatesView = [[TemplatesView alloc] initWithParent:self];
            [currentSettingsView addSubview:self.templatesView];
            break;
        case Profile_settings:
            self.profSetView = [[ProfileSetingsView alloc] initWithParent:self];
            [currentSettingsView addSubview:self.profSetView];
            break;
        case Help:
            [currentSettingsView addSubview:[[HelpView alloc] init]];
            break;
        default:
            break;
    }
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
