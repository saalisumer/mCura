//
//  STPNAddPatientViewController.m
//  3GMDoc

#import "STPNAddPatientViewController.h"
#import "Patient.h"
#import "_GMDocService.h"
#import "AddPatientInvocation.h"
#import "PatientAddress.h"
#import "PatientContactDetails.h"
#import "Utils.h"
#import "DataExchange.h"
#import "Response.h"
#import "Schedule.h"
#import "STPNDatePickerViewController.h"
#import "ISActivityOverlayController.h"
#import <QuartzCore/QuartzCore.h>
#import "proAlertView.h"
#import "Base64.h"
//#import <QuartzCore/QuartzCore.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import "_GMDocAppDelegate.h"

@interface STPNAddPatientViewController (private)<AddPatientInvocationDelegate, STPNDatePickerDelegate,GetStringInvocationDelegate>
@end

@implementation STPNAddPatientViewController

@synthesize txtName, txtDob, txtMobile1, txtEmail, btnArea, btnGender, btnSubmit, btnCancel, genders, activityController,imagePicker,docCityId,docStateId;
@synthesize service = _service;
@synthesize popover = _popover;

@synthesize tblGenders, tblAreas, areas, areaId,tblCity,tblStates,tblCountry,btnCity,btnState,btnCountry,txtZipcode,tblages,arrayages;
@synthesize arrayCities,arrayState,arrayCountries,arrayCityIds,areaIds,arrayStateIds,txtAddress1,txtAddress2,delegate;

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


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    arrayages=[[NSMutableArray alloc]init];
    for (int i=0; i<=100; i++) {
        NSString *str=[[NSString alloc]initWithFormat:@"%i",i];
        [arrayages addObject:str];
    }
    
    self.genders = [[NSMutableArray alloc] initWithObjects:@"M", @"F", nil];
    self.areas = [[NSMutableArray alloc] init];
    self.arrayCities = [[NSMutableArray alloc] init];
    self.arrayCityIds = [[NSMutableArray alloc] init];
    self.areaIds = [[NSMutableArray alloc] init];
    self.arrayCountries = [[NSMutableArray alloc] init];
    self.arrayState = [[NSMutableArray alloc] init];
    self.arrayStateIds = [[NSMutableArray alloc] init];
    self.service = [[[_GMDocService alloc] init] autorelease];
    self.tblAreas.layer.cornerRadius = 10;
    self.tblGenders.layer.cornerRadius = 10;
    self.tblCity.layer.cornerRadius = 10;
    self.tblCountry.layer.cornerRadius = 10;
    self.tblStates.layer.cornerRadius = 10;
    [mainScrollView setContentSize:CGSizeMake(540, 643)];
    self.activityController = [ISActivityOverlayController presentActivityOverViewController:self withLabel:@"Loading ..."];
	NSString* url = [NSMutableString stringWithFormat:@"%@GetArea?AreaId=%@",[DataExchange getbaseUrl],areaId];
    [self.service getStringResponseInvocation:url Identifier:@"GetDoctorCity" delegate:self];
    
    url = [NSString stringWithFormat:@"%@GetCountry",[DataExchange getbaseUrl]];
    [self.service getStringResponseInvocation:url Identifier:@"GetCountry" delegate:self];
    pendingConnections=1;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField==txtDob){
    }
    else{
        
        static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
        static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
        static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
        static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
        static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162;
        
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
        
        [mainScrollView setContentSize:CGSizeMake(mainScrollView.frame.size.width, mainScrollView.frame.size.height+200)];
        CGRect viewFrame = self.view.frame;
        viewFrame.origin.y -= animatedDistance;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
        [self.view setFrame:viewFrame];
        [UIView commitAnimations];
        
    } //Else condition End
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField==txtDob){
    }
    else{
        static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
        CGRect viewFrame = self.view.frame;
        viewFrame.origin.y += animatedDistance;
        [mainScrollView setContentSize:CGSizeMake(mainScrollView.frame.size.width, mainScrollView.frame.size.height-200)];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
        [self.view setFrame:viewFrame];
        [UIView commitAnimations];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
	[textField resignFirstResponder];
	return YES;
}

#pragma mark -
#pragma mark Table view data source

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if(tableView == self.tblages)
        //return self.arrayages.count;
        return 1;
    else if(tableView == self.tblGenders)
        return self.genders.count;
    else if(tableView == self.tblCity)
        return self.arrayCities.count;
    else if(tableView == self.tblCountry)
        return self.arrayCountries.count;
    else if(tableView == self.tblStates)
        return self.arrayState.count;
    else
        return self.areas.count;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    if(tableView == self.tblGenders){
        UITableViewCell *cell = [self.tblGenders dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        }
        
        cell.textLabel.text =[self.genders objectAtIndex:indexPath.row];
        return cell;
    }
    else if(tableView == self.tblages){
        UITableViewCell *cell = [self.tblages dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        }
        //  NSString *str=[[NSString alloc]initWithFormat:@"%@ years",[self.arrayages objectAtIndex:indexPath.row]];
        //  cell.textLabel.text = str;
        return cell;
    }
    
    else if(tableView == self.tblCity){
        UITableViewCell *cell = [self.tblCity dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        }
        cell.textLabel.text = [self.arrayCities objectAtIndex:indexPath.row];
        return cell;
    }
    else if(tableView == self.tblCountry){
        UITableViewCell *cell = [self.tblCountry dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        }
        cell.textLabel.text = [self.arrayCountries objectAtIndex:indexPath.row];
        return cell;
    }
    else if(tableView == self.tblStates){
        UITableViewCell *cell = [self.tblStates dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        }
        cell.textLabel.text = [self.arrayState objectAtIndex:indexPath.row];
        return cell;
    }
    else{
        UITableViewCell *cell = [self.tblAreas dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        }
        cell.textLabel.text = [self.areas objectAtIndex:indexPath.row];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if(tableView == self.tblGenders){
        [self.btnGender setTitle:cell.textLabel.text forState:UIControlStateNormal];
        self.tblGenders.hidden = YES;
    }
    
    else if(tableView == self.tblages){
        /*
         NSString *str=[[NSString alloc]initWithFormat:@"%@ years",[self.arrayages objectAtIndex:indexPath.row]];
         self.txtDob.text = str;
         NSDate * selectedDate = [NSDate date];
         NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
         [formatter setDateFormat: @"dd-MM-yyyy"];
         
         NSString *stringFromDate = [formatter stringFromDate:selectedDate];
         [formatter release];
         NSArray* componentArr = [stringFromDate componentsSeparatedByString:@"-"];
         // NSInteger existsDays=[(NSString*)[componentArr objectAtIndex:0] integerValue];
         // NSInteger existsMonth = [(NSString*)[componentArr objectAtIndex:1] integerValue];
         NSInteger existsYears = [(NSString*)[componentArr objectAtIndex:2] integerValue];
         int i= (existsYears -[self.txtDob.text integerValue]);
         Dobstr = [[NSMutableString alloc]initWithString:@"1-Jan-"];
         [Dobstr appendFormat:@"%i",i];
         tblages.hidden=YES;
         */
    }
    else if(tableView == self.tblCity){
        [self.btnCity setTitle:cell.textLabel.text forState:UIControlStateNormal];
        docCityId = [[arrayCityIds objectAtIndex:indexPath.row] integerValue];
        NSString* url = [NSMutableString stringWithFormat:@"%@GetCityArea?cityId=%d",[DataExchange getbaseUrl],docCityId];
        [self.service getStringResponseInvocation:url Identifier:@"GetAreaFromCity" delegate:self];
        self.tblCity.hidden = YES;
        pendingConnections++;
    }
    else if(tableView == self.tblCountry){
        [self.btnCountry setTitle:cell.textLabel.text forState:UIControlStateNormal];
        self.tblCountry.hidden = YES;
    }
    else if(tableView == self.tblStates){
        [self.btnState setTitle:cell.textLabel.text forState:UIControlStateNormal];
        docStateId = [[arrayStateIds objectAtIndex:indexPath.row] integerValue];
        NSString* url = [NSMutableString stringWithFormat:@"%@GetCity2?StateID=%d",[DataExchange getbaseUrl],docStateId];
        [self.service getStringResponseInvocation:url Identifier:@"GetCityFromState" delegate:self];
        self.tblStates.hidden = YES;
        pendingConnections++;
    }
    else{
        areaId = [areaIds objectAtIndex:indexPath.row];
        [self.btnArea setTitle:cell.textLabel.text forState:UIControlStateNormal];
        self.tblAreas.hidden = YES;
    }
}

-(IBAction) clickGenderBtn:(id)sender{
    self.tblGenders.hidden = NO;
}

-(IBAction) clickAreaBtn:(id)sender{
    self.tblAreas.hidden = NO;
}

-(IBAction) clickCityBtn:(id)sender{
    self.tblCity.hidden = NO;
}

-(IBAction) clickStateBtn:(id)sender{
    self.tblStates.hidden = NO;
}

-(IBAction) clickCountryBtn:(id)sender{
    self.tblCountry.hidden = NO;
}

+(NSString*)AgeFromString:(NSString*)dob{
    NSDate* existsDate;
    NSArray* componentArr = [dob componentsSeparatedByString:@"-"];
    NSInteger existsDays = [(NSString*)[componentArr objectAtIndex:1] integerValue];
    NSInteger existsMonth=[(NSString*)[componentArr objectAtIndex:0] integerValue];
    NSInteger existsYears = [(NSString*)[componentArr objectAtIndex:2] integerValue];
    
    NSDateComponents *comps = [[[NSDateComponents alloc] init] autorelease];
    [comps setDay:existsDays];
    [comps setMonth:existsMonth];
    [comps setYear:existsYears];
    existsDate = [[NSCalendar currentCalendar] dateFromComponents:comps];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	unsigned int unitFlags = NSDayCalendarUnit;
	NSDateComponents *components = [gregorian components:unitFlags fromDate:existsDate toDate:[NSDate date] options:0];
    NSInteger diffInDays = [components day];
	NSInteger diffInMonths=0;
    NSInteger diffInYears=0;
    
    while(diffInDays>31){
        diffInMonths++;
        diffInDays -=31;
        if(diffInMonths>12){
            diffInYears++;
            diffInMonths -=12;
        }
    }
    NSString* result = (diffInYears==0?[NSString stringWithFormat:@"%d Months",diffInMonths]:[NSString stringWithFormat:@"%d Years",diffInYears]);
    return result;
}

-(IBAction) clickProfileImageBtn{
    proAlertView *message = [[proAlertView alloc] initWithTitle:@"" message:@"Profile Photo!" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
    [message setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
    [message addButtonWithTitle:@"Take Photo"];
    [message addButtonWithTitle:@"Choose Existing"];
    
    [message show];
    [message release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    self.imagePicker = [[[UIImagePickerController alloc] init] autorelease];
	
    if(buttonIndex == 1){
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        self.imagePicker.mediaTypes =[UIImagePickerController availableMediaTypesForSourceType:self.imagePicker.sourceType];
        self.imagePicker.delegate = self;
        self.imagePicker.allowsEditing = NO;
        [self presentModalViewController:self.imagePicker animated:YES];
	}
	else if(buttonIndex == 2){
        _GMDocAppDelegate *appdel=(_GMDocAppDelegate*)[[UIApplication sharedApplication]delegate];
        appdel.profileimagevalue =1;
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        // self.imagePicker.mediaTypes =[UIImagePickerController availableMediaTypesForSourceType:self.imagePicker.sourceType];
        self.imagePicker.mediaTypes =[[NSArray alloc] initWithObjects:(NSString*)kUTTypeImage, nil];
        
        self.imagePicker.delegate = self;
        self.popover = [[UIPopoverController alloc] initWithContentViewController:self.imagePicker];
        [self.popover presentPopoverFromRect:profilePicView.frame
                                      inView:self.view
                    permittedArrowDirections:UIPopoverArrowDirectionLeft
                                    animated:YES];
        
        self.popover.delegate=self;
	}
}

-(BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController{
    
    _GMDocAppDelegate *appdel=(_GMDocAppDelegate*)[[UIApplication sharedApplication]delegate];
    appdel.profileimagevalue = 0;
    return YES;
}

#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)info {
    [self didTakePicture:image];
	[self didFinishWithCamera];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if([mediaType isEqualToString:@"public.image"]){
        UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
        [self didTakePicture:image];
        [self didFinishWithCamera];
        _GMDocAppDelegate *appdel=(_GMDocAppDelegate*)[[UIApplication sharedApplication]delegate];
        appdel.profileimagevalue =1;
        return;
    }
    else if ([mediaType isEqualToString:@"public.movie"]){
        NSURL *aURL    = [info objectForKey:UIImagePickerControllerMediaURL];
        NSString *pathToVideo = [aURL path];
        UISaveVideoAtPathToSavedPhotosAlbum(pathToVideo, self, @selector(video:didFinishSavingWithError:contextInfo:), NULL);
    }
}

- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    [self didFinishWithCamera];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self didFinishWithCamera];
}

- (void)didTakePicture:(UIImage *)picture{
    profileImg=picture;
    [profilePicView setBackgroundImage:picture forState:UIControlStateNormal];
}

- (void)didFinishWithCamera {
    if(self.imagePicker.sourceType==UIImagePickerControllerSourceTypeCamera){
        [self dismissModalViewControllerAnimated:YES];
    }
    else if([popover isPopoverVisible]){
        [popover dismissPopoverAnimated:NO];
        [popover release];
    }
}

#pragma mark -
#pragma mark remaining

- (void) closePopUpDate:(NSString*)dt{
    [self.popover dismissPopoverAnimated:NO];
    
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateFormat: @"dd-MMM-yyyy"];
    NSDate *dateFromString = [dateFormatter dateFromString:dt];
    
    if([self daysBetweenDate:dateFromString andDate:[NSDate date]]<0){
        proAlertView *alert = [[proAlertView alloc] initWithTitle:@"Error!" message:@"Date-of-birth is not valid. Please try again! " delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
        [alert show];
        [alert release];
        return;
    }
    if(dt != nil){
        NSLog(@"%@",self.txtDob.text);
        self.txtDob.text = dt;
    }
}

-(NSInteger) daysBetweenDate:(NSDate *)firstDate andDate:(NSDate *)secondDate {
    unsigned int flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    NSDateComponents* components = [calendar components:flags fromDate:firstDate];
    NSDate* date1Only = [calendar dateFromComponents:components];
    
    NSDateComponents* components2 = [calendar components:flags fromDate:secondDate];
    NSDate* date2Only = [calendar dateFromComponents:components2];
    
    NSDateComponents *componentsFinal = [calendar components: NSDayCalendarUnit fromDate:date1Only toDate:date2Only options: 0];
    NSInteger days = [componentsFinal day];
    return days;
}

-(IBAction) clickFromDOB:(id)sender{
    
    // tblages.hidden=NO;
    // [self.txtDob resignFirstResponder];
    /*
     
     UITextField *theSender = sender;
     
     STPNDatePickerViewController *addController = [[STPNDatePickerViewController alloc] initWithNibName:@"STPNDatePickerViewController" bundle:nil];
     
     addController.delegate = self;
     
     self.popover = [[[UIPopoverController alloc] initWithContentViewController:addController] autorelease];
     self.popover.popoverContentSize = CGSizeMake(300, 259);
     
     [self.popover presentPopoverFromRect:CGRectMake(0.00,00.00, 25.00, 40.00) inView:theSender permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
     [addController release];
     */
}

-(IBAction) clickCancel:(id)sender{
    [self dismissModalViewControllerAnimated:YES];
    if(self.delegate)
        [delegate closeAddPatientPopup];
}

-(IBAction) clickSubmit:(id)sender{
    NSDate * selectedDate = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat: @"dd-MM-yyyy"];
    
    NSString *stringFromDate = [formatter stringFromDate:selectedDate];
    [formatter release];
    NSArray* componentArr = [stringFromDate componentsSeparatedByString:@"-"];
    // NSInteger existsDays=[(NSString*)[componentArr objectAtIndex:0] integerValue];
    // NSInteger existsMonth = [(NSString*)[componentArr objectAtIndex:1] integerValue];
    NSInteger existsYears = [(NSString*)[componentArr objectAtIndex:2] integerValue];
    if (self.txtDob.text!=nil) {
        int i= (existsYears -[self.txtDob.text integerValue]);
        Dobstr = [[NSMutableString alloc]initWithString:@"1-Jan-"];
        [Dobstr appendFormat:@"%i",i];
        tblages.hidden=YES;
    }
    else{
        Dobstr=nil;
    }
    
    
    if([self.txtName.text length]  == 0){
        
        [Utils showAlert:@"Enter Name of patient!" Title:@"Alert"];
        
    }
	else if([self.txtDob.text length]  == 0){
        
        [Utils showAlert:@"Enter dob of patient!" Title:@"Alert"];
        
    }
	else if([self.btnGender.titleLabel.text isEqualToString:@"--Select--"]){
        
        [Utils showAlert:@"Select gender of patient!" Title:@"Alert"];
        
    }
	else if([self.btnArea.titleLabel.text isEqualToString:@"--Select Area--"]){
        
        [Utils showAlert:@"Select area of patient!" Title:@"Alert"];
        
    }
    else if([self.btnCountry.titleLabel.text isEqualToString:@"--Select--"]){
        
        [Utils showAlert:@"Select Country!" Title:@"Alert"];
        
    }
    else if([self.btnCity.titleLabel.text isEqualToString:@"--Select--"]){
        
        [Utils showAlert:@"Select city!" Title:@"Alert"];
        
    }
    else if([self.btnState.titleLabel.text isEqualToString:@"--Select--"]){
        
        [Utils showAlert:@"Select state!" Title:@"Alert"];
        
    }
    else if(txtMobile1.text.length==0){
        [Utils showAlert:@"Please enter mobile number of patient!" Title:@"Alert"];
    }
    else if(txtMobile1.text.length<10){
        [Utils showAlert:@"Please enter a ten digit mobile number!" Title:@"Alert"];
    }
    //  else if(txtEmail.text.length==0){
    //    [Utils showAlert:@"Please enter an e-mail!" Title:@"Alert"];
    //  }
    else{
        
        PatientAddress *patAdrs = [[[PatientAddress alloc] init] autorelease];
        patAdrs.Address1 = self.txtAddress1.text;
        patAdrs.Address2 = self.txtAddress2.text;
        patAdrs.AreaId = [NSNumber numberWithInt:[areaId integerValue]];
        patAdrs.Zipcode = self.txtZipcode.text;
        NSArray *pattAdrs = [NSArray arrayWithObject:patAdrs];
        
        PatientContactDetails *patCtrlDtl = [[[PatientContactDetails alloc] init] autorelease];
        
        if([self.txtMobile1.text length] > 0)
            patCtrlDtl.Mobile = self.txtMobile1.text;
        if([self.txtEmail.text length] > 0)
            patCtrlDtl.Email = self.txtEmail.text;
        NSArray *pattCtrlDtl = [NSArray arrayWithObject:patCtrlDtl];
        
        Patient *pat = [[[Patient alloc] init] autorelease];
        pat.Patname = self.txtName.text;
        // pat.dob = self.txtDob.text;
        pat.dob = Dobstr;
        if([self.btnGender.titleLabel.text isEqualToString:@"M"]){
            pat.GenderId = [NSNumber numberWithInt:1];
        }
        else if([self.btnGender.titleLabel.text isEqualToString:@"F"]){
            pat.GenderId = [NSNumber numberWithInt:2];
        }
        pat.PatientAddress = pattAdrs;
        pat.PatientContactDetails = pattCtrlDtl;
        
        self.activityController = [ISActivityOverlayController presentActivityOverViewController:self withLabel:@"Loading..."];
        
        Response *res = [[DataExchange getLoginResponse] objectAtIndex:0];
        Schedule *sec = [[DataExchange getSchedulerReponse] objectAtIndex:0];
        
        if(self.delegate){
            [DataExchange setAddPatient:pat];
        }
        
        [self.service addPatientInvocation:pat UserRollId:[res.userRoleID stringValue] SubTenantId:sec.sub_tenant_id delegate:self];
    }
}

-(void)addPatientInvocationDidFinish:(AddPatientInvocation*)invocation withPatDemoId:(NSString*)demoId withError:(NSError*)error{
    if(!error){
        patDemoId = [demoId integerValue];
        NSLog(@"patDemoId- %d",patDemoId);
        [NSThread detachNewThreadSelector:@selector(postImage) toTarget:self withObject:nil];
    }
    else {
        proAlertView* alert = [[proAlertView alloc] initWithTitle:@"Error" message:error.description delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
        [alert show];
        [alert release];
        if (self.activityController) {
            [self.activityController dismissActivity];
            self.activityController = Nil;
        }
    }
}

-(void)postImage{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSString *urlString = [NSString stringWithFormat:@"http://%@FileUploadImage",[DataExchange getbaseUrl]];
    //set up the request body
    NSMutableData *body = [[[NSMutableData alloc] init] autorelease];
    NSString* firstStr = @"{\"fileStream\":\"";
    NSString* lastStr = @"\"}";
    // add image data
    [body appendData:[firstStr dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[Base64 encode:UIImageJPEGRepresentation(profileImg,1.0)] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[lastStr dataUsingEncoding:NSUTF8StringEncoding]];
    NSString* length = [NSString stringWithFormat:@"%d",body.length];
    // setting up the request object now
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    [request setAllHTTPHeaderFields:[[NSDictionary alloc] initWithObjects:[[NSArray alloc] initWithObjects:@"application/json",@"utf-8",[DataExchange getDomainUrl],[NSString stringWithFormat:@"%@",length], nil] forKeys:[[NSArray alloc] initWithObjects:@"Content-Type",@"charset",@"Host",@"Content-Length", nil]]];
    [request setHTTPBody:body];
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *response= [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding];
    [pool release];
    if([response rangeOfString:@"Request"].location == NSNotFound)
        [self performSelectorOnMainThread:@selector(SuccessToPostImage:) withObject:response waitUntilDone:NO];
}

-(void)SuccessToPostImage:(NSString*)response{
    NSString* dataToPost = [NSString stringWithFormat:@"{\"PatDemoid\":%d,\"UserRoleID\":%@,\"ImagePathId\":%@}",patDemoId,[DataExchange getUserRoleId],response];
    NSURL* myUrl = [[[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://%@UpdatePatientImage",[DataExchange getbaseUrl]]] autorelease];
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
    [request setURL:myUrl];
    [request setHTTPMethod:@"POST"];
    [request setAllHTTPHeaderFields:[[[NSDictionary alloc] initWithObjects:[[[NSArray alloc] initWithObjects:@"application/json",@"utf-8",[DataExchange getDomainUrl],[NSString stringWithFormat:@"%d",dataToPost.length], nil] autorelease] forKeys:[[[NSArray alloc] initWithObjects:@"Content-Type",@"charset",@"Host",@"Content-Length", nil]autorelease]]autorelease]];
    [request setHTTPBody:[NSData dataWithBytes:[dataToPost UTF8String] length:[dataToPost lengthOfBytesUsingEncoding:NSUTF8StringEncoding]]];
    patImgPostConnection = [[[NSURLConnection alloc] initWithRequest:request delegate:self] autorelease];
}

-(void)GetStringInvocationDidFinish:(GetStringInvocation *)invocation
                 withResponseString:(NSString *)responseString
                     withIdentifier:(NSString *)identifier
                          withError:(NSError *)error{
    if(!error){
        NSArray* response = [responseString JSONValue];
        if([identifier isEqualToString:@"GetCity"]){
            [self.arrayCities removeAllObjects];
            [self.arrayCityIds removeAllObjects];
            if(![response isKindOfClass:[NSNull class]]){
                if(response.count>0){
                    NSString* url = [NSMutableString stringWithFormat:@"%@GetCityArea?cityId=%d",[DataExchange getbaseUrl], docCityId];
                    [self.service getStringResponseInvocation:url Identifier:@"GetArea" delegate:self];
                    
                    NSDictionary* dictTemp;
                    for (int i=0; i<response.count; i++) {
                        dictTemp = [response objectAtIndex:i];
                        if([[dictTemp objectForKey:@"CityId"] integerValue] == docCityId){
                            [btnCity setTitle:[dictTemp objectForKey:@"City"] forState:UIControlStateNormal];
                            docStateId = [[dictTemp objectForKey:@"StateId"] integerValue];
                            url = [NSMutableString stringWithFormat:@"%@GetState_StateID?StateID=%@",[DataExchange getbaseUrl],[dictTemp objectForKey:@"StateId"]];
                            [self.service getStringResponseInvocation:url Identifier:@"GetState" delegate:self];
                            break;
                        }
                    }
                    
                    for(int i=0;i<response.count;i++){
                        [self.arrayCities addObject:[[response objectAtIndex:i] objectForKey:@"City"]];
                        [self.arrayCityIds addObject:[[response objectAtIndex:i] objectForKey:@"CityId"]];
                    }
                    
                    pendingConnections++;
                    [self.tblCity reloadData];
                }else{
                    pendingConnections=0;
                    if (self.activityController) {
                        [self.activityController dismissActivity];
                        self.activityController = Nil;
                    }
                }
            }
            else if (self.activityController) {
                pendingConnections=0;
                [self.activityController dismissActivity];
                self.activityController = Nil;
            }
        }
        else if([identifier isEqualToString:@"GetCountry"]){
            pendingConnections--;
            if(response.count>0){
                NSDictionary* dictTemp = [response objectAtIndex:0];
                [self.arrayCountries addObject:[dictTemp objectForKey:@"CountryProperty"]];
                [btnCountry setTitle:[self.arrayCountries objectAtIndex:0] forState:UIControlStateNormal];
                [self.tblCountry reloadData];
            }
            else if (self.activityController) {
                pendingConnections=0;
                [self.activityController dismissActivity];
                self.activityController = Nil;
            }
        }
        else if([identifier isEqualToString:@"GetState"]){
            pendingConnections--;
            [self.arrayState removeAllObjects];
            [self.arrayStateIds removeAllObjects];
            for (int i=0; i<response.count; i++) {
                NSDictionary* dictTemp = [response objectAtIndex:i];
                if([[dictTemp objectForKey:@"StateId"] integerValue] == docStateId){
                    [btnState setTitle:[dictTemp objectForKey:@"StateProperty"] forState:UIControlStateNormal];
                }
                if(![[dictTemp objectForKey:@"StateProperty"] isKindOfClass:[NSNull class]]){
                    [self.arrayState addObject:[dictTemp objectForKey:@"StateProperty"]];
                    [self.arrayStateIds addObject:[dictTemp objectForKey:@"StateId"]];
                }
            }
            if (self.activityController && response.count==0) {
                [self.activityController dismissActivity];
                self.activityController = Nil;
            }
            [self.tblStates reloadData];
        }
        else if([identifier isEqualToString:@"GetArea"]){
            pendingConnections--;
            [self.areas removeAllObjects];
            [self.areaIds removeAllObjects];
            for (int i=0; i<response.count; i++) {
                NSDictionary* dictTemp = [response objectAtIndex:i];
                if([[dictTemp objectForKey:@"AreaId"] integerValue] == [areaId integerValue]){
                    [btnArea setTitle:[dictTemp objectForKey:@"Area"] forState:UIControlStateNormal];
                }
                if(![[dictTemp objectForKey:@"Area"] isKindOfClass:[NSNull class]]){
                    [self.areas addObject:[dictTemp objectForKey:@"Area"]];
                    [self.areaIds addObject:[dictTemp objectForKey:@"AreaId"]];
                }
            }
            if (self.activityController && response.count==0) {
                [self.activityController dismissActivity];
                self.activityController = Nil;
            }
            [self.tblAreas reloadData];
        }
        else if([identifier isEqualToString:@"GetDoctorCity"]){
            docCityId = [(NSNumber*)[(NSDictionary*)response objectForKey:@"CityId"] integerValue];
            NSString* url = [NSMutableString stringWithFormat:@"%@GetCity_Area?AreaId=%@",[DataExchange getbaseUrl],areaId];
            [self.service getStringResponseInvocation:url Identifier:@"GetCity" delegate:self];
        }
        else if([identifier isEqualToString:@"GetAreaFromCity"]){
            pendingConnections--;
            [self.areas removeAllObjects];
            [self.areaIds removeAllObjects];
            for (int i=0; i<response.count; i++) {
                NSDictionary* dictTemp = [response objectAtIndex:i];
                if([[dictTemp objectForKey:@"AreaId"] integerValue] == [areaId integerValue]){
                    [btnArea setTitle:[dictTemp objectForKey:@"Area"] forState:UIControlStateNormal];
                }
                if(![[dictTemp objectForKey:@"Area"] isKindOfClass:[NSNull class]]){
                    [self.areas addObject:[dictTemp objectForKey:@"Area"]];
                    [self.areaIds addObject:[dictTemp objectForKey:@"AreaId"]];
                }
            }
            [self.tblAreas reloadData];
        }
        else if([identifier isEqualToString:@"GetCityFromState"]){
            pendingConnections--;
            [self.arrayCities removeAllObjects];
            [self.arrayCityIds removeAllObjects];
            if(response.count>0){
                NSDictionary* dictTemp = [response objectAtIndex:0];
                [btnCity setTitle:[dictTemp objectForKey:@"City"] forState:UIControlStateNormal];
                docStateId = [[dictTemp objectForKey:@"StateId"] integerValue];
            }
            else if (self.activityController) {
                [self.activityController dismissActivity];
                self.activityController = Nil;
            }
            
            for(int i=0;i<response.count;i++){
                [self.arrayCities addObject:[[response objectAtIndex:i] objectForKey:@"City"]];
                [self.arrayCityIds addObject:[[response objectAtIndex:i] objectForKey:@"CityId"]];
            }
            
            [self.tblCity reloadData];
        }
        
        if (self.activityController && pendingConnections==0) {
            [self.activityController dismissActivity];
            self.activityController = Nil;
        }
    }
}

#pragma mark connection delegate

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    NSLog(@"%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    if(connection==patImgPostConnection){
        if (self.activityController) {
            [self.activityController dismissActivity];
            self.activityController = Nil;
        }
        [self dismissModalViewControllerAnimated:YES];
        if(self.delegate){
            [delegate closeAddPatientPopup];
        }
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	proAlertView *alert = [[proAlertView alloc] initWithTitle:@"Something Went Wrong" message:@"Please Try Again" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
    [alert setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
	[alert show];
	[alert release];
	return;
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    tblAreas.hidden = true;
    tblGenders.hidden = true;
    tblStates.hidden = true;
    tblCity.hidden = true;
    tblCountry.hidden = true;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    BOOL isNumeric=FALSE;
	if ([string length] == 0)
	{
		isNumeric=TRUE;
	}
	else if(textField == txtMobile1 || textField == txtZipcode || textField == txtDob)
	{
		if ( [string compare:@"0"]==0 || [string compare:@"1"]==0
			|| [string compare:@"2"]==0 || [string compare:@"3"]==0
			|| [string compare:@"4"]==0 || [string compare:@"5"]==0
			|| [string compare:@"6"]==0 || [string compare:@"7"]==0
			|| [string compare:@"8"]==0 || [string compare:@"9"]==0
            //|| [string compare:@"."]==0
            )
		{
			isNumeric=TRUE;
		}
		else
		{
			unichar mychar=[string characterAtIndex:0];
			if (mychar==46)
			{
				int i;
				for (i=0; i<[textField.text length]; i++)
				{
					unichar c = [textField.text characterAtIndex: i];
					if(c==46)
						return FALSE;
				}
                isNumeric=TRUE;
			}
		}
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        if(newLength > 10){
            isNumeric = NO;
        }
        if(newLength==7 && textField==txtZipcode){
            isNumeric = NO;
        }
        if(newLength==4 && textField==txtDob){
            isNumeric = NO;
        }
	}
    else {
        isNumeric = TRUE;
    }
    
	return isNumeric;
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
