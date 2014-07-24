//
//  STPNMoveAppointmentViewController.m
//  3GMDoc

#import "STPNMoveAppointmentViewController.h"
#import "Nature.h"
#import "DataExchange.h"
#import "_GMDocService.h"
#import "Schedule.h"
#import "GetConnonInvocation.h"
#import "STPNDateViewController.h"
#import "PostMoveAppointmentInvocation.h"
#import "Utils.h"
#import "Appointment.h"
#import "Response.h"
#import "Appointment.h"
#import <QuartzCore/QuartzCore.h>

@interface STPNMoveAppointmentViewController (private)<GetConnonInvocationDelegate, STPNTimeDelegate, PostMoveAppointmentDelegate,GetFreeSlotsInvocationDelegate>
@end

@implementation STPNMoveAppointmentViewController

@synthesize lblSecName, lblSecTime, btnSubmit, btnCancel;
@synthesize delegate, activityController, popover,lblAppTime;
@synthesize service = _service,avlSlotsArray,selectedScheduleIndex;
@synthesize selectedIndex,tblAvlSlots,btnAvlSlots;

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
    self.activityController = [ISActivityOverlayController presentActivityOverViewController:self withLabel:@"Fetching ..."];
    Schedule *sec = [[DataExchange getSchedulerReponse] objectAtIndex:self.selectedScheduleIndex];
    Appointment *appot = [sec.appointments objectAtIndex:[selectedIndex intValue]];
    Response *res = [[DataExchange getLoginResponse] objectAtIndex:0];
    [self.service getFreeSlotsInvocation:[res.userRoleID stringValue] TimeTableId:[NSString stringWithFormat:@"%d",[appot.TimeTableId integerValue]] delegate:self];
    self.tblAvlSlots.layer.cornerRadius = 10;
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    Schedule *sec = [[DataExchange getSchedulerReponse] objectAtIndex:self.selectedScheduleIndex];
    
    self.lblSecName.text = sec.schedule_name;
    Appointment* apt = [[sec appointments] objectAtIndex:[self.selectedIndex integerValue]];
    self.lblSecTime.text = [NSString stringWithFormat:@"From %@ to %@",[DataExchange militaryToTwelveHr:sec.from_time],[DataExchange militaryToTwelveHr:sec.to_time]];
    self.lblAppTime.text = [NSString stringWithFormat:@"From %@ to %@",[DataExchange militaryToTwelveHr:apt.FromTime],[DataExchange militaryToTwelveHr:apt.ToTime]];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
	
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
    if(tableView == self.tblAvlSlots)
        return self.avlSlotsArray.count;
    else
        return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [self.tblAvlSlots dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    NSString* fromTime = [(Appointment*)[self.avlSlotsArray objectAtIndex:indexPath.row] FromTime];
    NSString* toTime = [(Appointment*)[self.avlSlotsArray objectAtIndex:indexPath.row] ToTime];

    cell.textLabel.text = [NSString stringWithFormat:@"%@ -- %@",[DataExchange militaryToTwelveHr:fromTime],[DataExchange militaryToTwelveHr:toTime]];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    [self.btnAvlSlots setTitle:cell.textLabel.text forState:UIControlStateNormal];
    currAvlSlotSelIndex = indexPath.row;
    self.tblAvlSlots.hidden = true;
}

-(void)getFreeSlotsInvocationDidFinish:(GetFreeSlotsInvocation *)invocation 
                      withAppointments:(NSArray *)results 
                             withError:(NSError *)error{
    if(!error){
        avlSlotsArray = [[NSMutableArray alloc] initWithArray:results];
        [self.tblAvlSlots reloadData];
    }
    if (self.activityController) {
        [self.activityController dismissActivity];
        self.activityController = nil;
    }
}

-(IBAction) clickAvlSlots:(id)sender{
    self.tblAvlSlots.hidden = NO;
}

-(IBAction) clickCancel:(id)sender{
    if(self.delegate != nil){
        [self.delegate closePopup:FALSE];
    }
}

-(IBAction) clickSubmit:(id)sender{
    
   if([self.btnAvlSlots.titleLabel.text isEqualToString:@"--Select--"]){
        [Utils showAlert:@"Enter time information!" Title:@"Alert"];
    }
    else{
        self.activityController = [ISActivityOverlayController presentActivityOverViewController:self withLabel:@"Submitting ..."];
        Schedule *sec = [[DataExchange getSchedulerReponse] objectAtIndex:selectedScheduleIndex];
        Appointment *appot = [sec.appointments objectAtIndex:[selectedIndex intValue]];
        Response *res = [[DataExchange getLoginResponse] objectAtIndex:0];
        NSString* str = [NSString stringWithFormat:@"%d",[[(Appointment*)[avlSlotsArray objectAtIndex:currAvlSlotSelIndex] AppId] integerValue]];
        [self.service postMoveAppointmentInvocation:str UserRoleId:[NSString stringWithFormat:@"%d",[res.userRoleID integerValue]] OldAppId:[NSString stringWithFormat:@"%d",[appot.AppId integerValue]] TimeTableId:[NSString stringWithFormat:@"%d",[appot.TimeTableId integerValue]] delegate:self];
    }
}

-(void)postMoveAppointmentDidFinish:(PostMoveAppointmentInvocation*)invocation 
                          withError:(NSError*)error{
    if (self.activityController) {
        [self.activityController dismissActivity];
        self.activityController = nil;
    }
    if(self.delegate != nil){
        [self.delegate closePopup:TRUE];
    }
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    tblAvlSlots.hidden = true;
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
