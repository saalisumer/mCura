//
//  STPNBlockAppointmentViewController.m
//  3GMDoc

#import "STPNBlockAppointmentViewController.h"
#import "_GMDocService.h"
#import "DataExchange.h"
#import "Schedule.h"
#import "GetConnonInvocation.h"
#import "Nature.h"
#import "InsertAppointmentInvocation.h"
#import "Utils.h"
#import "Appointment.h"
#import "Response.h"
#import "PostAppointmentInvocation.h"
#import <QuartzCore/QuartzCore.h>

@interface STPNBlockAppointmentViewController (private)< PostAppointmentDelegate,GetConnonInvocationDelegate, InsertAppointmentDelegate>
@end

@implementation STPNBlockAppointmentViewController
@synthesize delegate, tblNature, btnNature, lblSecName, lblSecTime, txtOthDtl, btnSubmit, btnCancel, natures, status, activityController, selectedIndex;
@synthesize service = _service,hospitalName;
@synthesize appoint,selectedScheduleIndex;

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
    [self.service getConnonInvocation:@"1" delegate:self];
    self.status = [NSArray arrayWithObjects:@"Active", @"Pending", nil];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    Schedule *sec = [[DataExchange getSchedulerReponse] objectAtIndex:self.selectedScheduleIndex];
    
    self.lblSecName.text = sec.schedule_name;
    Appointment* apt = [[sec appointments] objectAtIndex:[self.selectedIndex integerValue]];
    self.lblSecTime.text = [NSString stringWithFormat:@"From %@ am to %@ am (%@)",[DataExchange militaryToTwelveHr:apt.FromTime],[DataExchange militaryToTwelveHr:apt.ToTime],self.hospitalName];
    self.tblNature.layer.cornerRadius = 10;
}

-(IBAction) closePopup:(id)sender{
    if(delegate != nil){
        [self.delegate closePopup:FALSE];
    }
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if(tableView == self.tblNature)
        return self.natures.count;
    else 
        return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [self.tblNature dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    Nature *nat = [[DataExchange getNatureReponse] objectAtIndex:0];
    cell.textLabel.text = nat.AppNature;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if(tableView == self.tblNature){
        [self.btnNature setTitle:cell.textLabel.text forState:UIControlStateNormal];
        self.tblNature.hidden = YES;
    }
}

-(void)getConnonInvocationDidFinish:(GetConnonInvocation*)invocation
                        withResults:(NSArray*)results
                          withError:(NSError*)error{
    if(!error){
            if([results count] > 0){
                [DataExchange setNatureResponse:results];
                natures = results;
                [self.tblNature reloadData];
            }
    }
}

-(IBAction) clickNaturePatient:(id)sender{
    self.tblNature.hidden = NO;
}

-(IBAction) clickCancel:(id)sender{
    
    if(self.delegate != nil){
        [self.delegate closePopup:FALSE];
    }
}

-(IBAction) clickSubmit:(id)sender{
    if([self.btnNature.titleLabel.text isEqualToString:@"--Select--"]){
        [Utils showAlert:@"Plz select Nature!" Title:@"Alert"];
    }
    else{
        self.activityController = [ISActivityOverlayController presentActivityOverViewController:self withLabel:@"Submitting ..."];
        Schedule *sec = [[DataExchange getSchedulerReponse] objectAtIndex:selectedScheduleIndex];
        Appointment *appot = [sec.appointments objectAtIndex:[selectedIndex intValue]];
        Response *res = [[DataExchange getLoginResponse] objectAtIndex:0];
        [self.service postAppointmentInvocation:@"B" UserRollId:[res.userRoleID stringValue] AppId:appot.AppId delegate:self];
    }
}

-(void)postAppointmentDidFinish:(PostAppointmentInvocation*)invocation withError:(NSError*)error{

    if (self.activityController) {
        [self.activityController dismissActivity];
        self.activityController = nil;
    }
    
    if(self.delegate != nil){
        [self.delegate closePopup:TRUE];
    }
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    tblNature.hidden = true;
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
