//
//  STPNFixAppointmentViewController.m
//  3GMDoc

#import "STPNFixAppointmentViewController.h"
#import "_GMDocService.h"
#import "GetPatientInvocation.h"
#import "Response.h"
#import "DataExchange.h"
#import "Schedule.h"
#import "Patient.h"
#import "GetConnonInvocation.h"
#import "Nature.h"
#import "InsertAppointmentInvocation.h"
#import "Utils.h"
#import "Appointment.h"
#import "proAlertView.h"
#import <QuartzCore/QuartzCore.h>
#define min(X,Y) (X<Y?X:Y)

@interface STPNFixAppointmentViewController (private)<GetPatientInvocationnDelegate, GetConnonInvocationDelegate, InsertAppointmentDelegate>
@end

@implementation STPNFixAppointmentViewController
@synthesize delegate, tblNature, btnNature, txtPatient, btnPatSearch, btnPatAdd, lblSecName, lblSecTime, btnSubmit, btnCancel, patients, activityController, natures;
@synthesize service = _service, tblPatients, selectedPatIndex, selectedIndex,selectedScheduleIndex;

int req_number;

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
    
    req_number = 1;
    [self.service getConnonInvocation:@"1" delegate:self];
    
    self.tblPatients.backgroundColor = [UIColor clearColor];
    self.tblNature.backgroundColor = [UIColor clearColor];
    
    self.tblNature.layer.cornerRadius = 10;
    self.tblPatients.layer.cornerRadius = 10;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    Schedule *sec = [[DataExchange getSchedulerReponse] objectAtIndex:self.selectedScheduleIndex];
    
    self.lblSecName.text = sec.schedule_name;
    Appointment* apt = [[sec appointments] objectAtIndex:[self.selectedIndex integerValue]];
    self.lblSecTime.text = [NSString stringWithFormat:@"From %@ to %@",[DataExchange militaryToTwelveHr:apt.FromTime],[DataExchange militaryToTwelveHr:apt.ToTime]];
}

-(IBAction) clickSearchPatient:(id)sender{
        
    Response *res = [[DataExchange getLoginResponse] objectAtIndex:0];
    Schedule *sec = [[DataExchange getSchedulerReponse] objectAtIndex:self.selectedScheduleIndex];
    
    if([[self.txtPatient.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] > 0){
        self.activityController = [ISActivityOverlayController presentActivityOverViewController:self withLabel:@"Submitting ..."];
        [self.service getPatientInvocation:[res.userRoleID stringValue] Searchkey:self.txtPatient.text Sub_tenant_id:sec.sub_tenant_id delegate:self];
    }
    else{
        [Utils showAlert:@"Enter any text!" Title:@"Alert"];
    }
}

-(IBAction) closePopup:(id)sender{
    if(delegate != nil){
        [self.delegate closePopup:FALSE];
    }
}

#pragma mark -
#pragma mark Table view data source

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(tableView == self.tblNature)
        return self.natures.count;
    else
        return self.patients.count;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    if(tableView == self.tblNature){
        UITableViewCell *cell = [self.tblNature dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        }
        Nature *nat = [[DataExchange getNatureReponse] objectAtIndex:0];
        cell.textLabel.text = nat.AppNature;
        
        return cell;
    }
    else{
        UITableViewCell *cell = [self.tblPatients dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        }
        Patient *p = [self.patients objectAtIndex:indexPath.row];
        
        cell.textLabel.text = p.Patname;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if(tableView == self.tblNature){
        [self.btnNature setTitle:cell.textLabel.text forState:UIControlStateNormal];
        self.tblNature.hidden = YES;
    }
    else{
        selectedPatIndex = indexPath.row;
        self.txtPatient.text = cell.textLabel.text;
        self.tblPatients.hidden = YES;
        [self.txtPatient resignFirstResponder];
    }
}

-(void)setSelectedCell:(NSInteger)index{
    selectedPatIndex = index;
    self.txtPatient.text = [(Patient*)[self.patients objectAtIndex:index] Patname];
    self.tblPatients.hidden = YES;
    [self.txtPatient resignFirstResponder];
}

-(void)getPatientInvocationDidFinish:(GetPatientInvocation*)invocation
                        withPatients:(NSArray*)pats
                           withError:(NSError*)error{
    if (self.activityController) {
        [self.activityController dismissActivity];
        self.activityController = nil;
    }
    if(!error){
        if([pats count] > 0){
            self.patients = pats;
            [self.tblPatients reloadData];
            self.tblPatients.frame = CGRectMake(self.tblPatients.frame.origin.x, self.tblPatients.frame.origin.y, self.tblPatients.frame.size.width, min(20+44*pats.count,250));
            self.tblPatients.hidden = NO;
        }
    }
}

-(void)getConnonInvocationDidFinish:(GetConnonInvocation*)invocation
                        withResults:(NSArray*)results
                          withError:(NSError*)error{
    if(!error){
        if(req_number == 1){
            if([results count] > 0){
                [DataExchange setNatureResponse:results];
                natures = results;
                self.tblNature.frame = CGRectMake(self.tblNature.frame.origin.x, self.tblNature.frame.origin.y, self.tblNature.frame.size.width, min(20+44*natures.count,200));
                [self.tblNature reloadData];
            }
        }
    }
}

-(IBAction) clickNaturePatient:(id)sender{
    self.tblNature.hidden = NO;
}

-(IBAction) clickCancel:(id)sender{
    if(self.delegate != nil){
        [self.delegate closePopup:false];
    }
}

-(IBAction) clickAdd:(id)sender{
    if(self.delegate != nil){
        [self.delegate closePopupFromAddBtn];
    }
}

-(IBAction) clickSubmit:(id)sender{
    if([self.txtPatient.text length]  == 0){
        [Utils showAlert:@"Enter patient information!" Title:@"Alert"];
    }
    else if([self.btnNature.titleLabel.text isEqualToString:@"--Select--"]){
        [Utils showAlert:@"Plz select Nature!" Title:@"Alert"];
    }
    else{
        self.activityController = [ISActivityOverlayController presentActivityOverViewController:self withLabel:@"Submitting ..."];
        Schedule *sec = [[DataExchange getSchedulerReponse] objectAtIndex:selectedScheduleIndex];
        Appointment *appot = [sec.appointments objectAtIndex:[selectedIndex intValue]];
        Response *res = [[DataExchange getLoginResponse] objectAtIndex:0];
        Patient *pat = [self.patients objectAtIndex:selectedPatIndex];
        
        [self.service insertAppointmentInvocation:appot.AppId AvailStatusId:appot.AvlStatusId Mrno:pat.MRNO UserRollId:[res.userRoleID stringValue] OthDetails:@" " CurrentStatusId:@"1" AppNatureId:@"1" delegate:self];
    }
}

-(void)insertAppointmentDidFinish:(InsertAppointmentInvocation*)invocation withError:(NSError*)error{
    if (self.activityController) {
        [self.activityController dismissActivity];
        self.activityController = nil;
    }
    if(self.delegate != nil){
        [self.delegate closePopup:TRUE];
    }
    if(error){
        proAlertView *alert = [[proAlertView alloc] initWithTitle:@"Error!" message:@"Unable to fix this appointment!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
        [alert show];
        [alert release];
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    tblNature.hidden = true;
    tblPatients.hidden = true;
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
