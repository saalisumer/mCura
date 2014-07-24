//
//  CurrentVisitDetailViewController.m
//  mCura
//
//  Created by Aakash Chaudhary on 02/04/12.
//  Copyright (c) 2012 aakash272@gmail.com. All rights reserved.
///


#import "CurrentVisitDetailViewController.h"
#import "Utils.h"
#import "ISActivityOverlayController.h"
#import "_GMDocService.h"
#import "GetPatientContactDetail.h"
#import "ImageCache.h"
#import "Base64.h"
#import "DataExchange.h"
#import "PatientContactDetails.h"
#import <QuartzCore/QuartzCore.h>
#import "STPNLoggedIn.h"
#import "GetPatComplaints.h"
#import "PatAllergy.h"
#import "PatHealth.h"
#import "PatVital.h"
#import "Severity.h"
#import "SubTenant.h"
#import "LabOrder.h"
#import "PharmacyOrder.h"
#import "STPNAddPatientViewController.h"
#import "Appointment.h"
#import "Booking.h"
#import "CustomPopoverViewController.h"
#import "GetLabReportInvocation.h"
#import "LabReport.h"
#import "GetNotesInvocation.h"
#import "MedRecNature.h"
#import "DocCurrVisitViewController.h"
#import "ReferralViewController.h"
#import "HelpViewController.h"
#import "AddHAViewController.h"
#import "LabOrderEditViewController.h"
#import "CurrImageryEditViewController.h"
#import "PostVitalCommentsVC.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import "_GMDocAppDelegate.h"




#define topBarHeight 120
#define numRows 4

@interface CurrentVisitDetailViewController (private)<GetPatientContactDetailDelegate, ImageCacheDelegate,GetPatComplaintsInvocationDelegate,LabOrderViewControllerDelegate,GetPatientAllergyInvocationDelegate,GetPaientVitalsInvocationDelegate,GetUserInvocationDelegate,GetSeverityInvocationDelegate,GetLabOrPharmacyInvocationDelegate,PopoverResponseClassDelegate,GetLabReportInvocationDelegate,GetVitalsInvocationDelegate,GetNotesInvocationDelegate,GetMedRecNatureInvocationDelegate,GetDocAddrOrContInvocationDelegate,GetStringInvocationDelegate,PostVitalCommentsVCDelegate>
@end
@implementation CurrentVisitDetailViewController
@synthesize lblName, lblAge, lblSex, lblNumber, lblDOB, profileImage,nextPatientBtn,patientCityString;
@synthesize severitiesArray,finalImageToBeSaved,pat,currentIndex,currentDoctor,currDocContact;
@synthesize activityController, service,severitiesTblView,natureTblView,currLoggedInDoctor;
@synthesize dateDtls, nameDtls, imageDtls, capturedImages, imagePicker,currentColor,previousPatMob;
@synthesize mrno,pharmacyOrderArray,patMedRecordsArray,phone,hideNextPatientButton,popover;
@synthesize allergiesTblView,healthConditionTblView,vitalsTblView,res,sec,currDocAddress;
@synthesize vitalsArray,healthArray,allergiesArray,doctorNamesArray,currentComplaint,previousPatEmail;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    if(!self.activityController)
        self.activityController = [ISActivityOverlayController presentActivityOverViewController:self withLabel:@"Loading..."];
    self.service = [[[_GMDocService alloc] init] autorelease];
    
    
    
    if (self.capturedImages == Nil) {
		self.capturedImages = [NSMutableArray array];
	}
    currentIndex=0;
    isVitalsSorted = false;
    currentVitalsSortString = @"--Select All--";
    postImageCase = false;
    complaintLabOrPharmacyIndex=0;
    sortingOfArraysIsNotDone = true;
    editCompliance = false;
    isCurrentVisitImage = false;
    currentCount=0;
    currentSeverity = -1;
    severityBtn.titleLabel.numberOfLines = 0;
    severityBtn.titleLabel.lineBreakMode = UILineBreakModeWordWrap;
    [severityBtn setTitle:@"Select Severity" forState:UIControlStateNormal];
    severityBtn.titleLabel.textAlignment = UITextAlignmentCenter;
    
    self.navigationItem.titleView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mCURA.png"]] autorelease];
    
    UIToolbar* toolsRight = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 180, 44)];
    NSMutableArray *buttonsRight = [[NSMutableArray alloc] initWithCapacity:2];
    UIBarButtonItem* bi = [[UIBarButtonItem alloc] initWithTitle:@"Help" style:UIBarButtonItemStyleBordered target:self action:@selector(showHelpView)];
    [buttonsRight addObject:bi];
    [bi release];
    bi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(selectLogout:)];
    bi.style = UIBarButtonItemStyleBordered;
    [buttonsRight addObject:bi];
    [bi release];
    bi = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(logoutUser)];
    bi.style = UIBarButtonItemStyleBordered;
    [buttonsRight addObject:bi];
    [bi release];
    [toolsRight setItems:buttonsRight animated:NO];
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:toolsRight] autorelease];
    [toolsRight release];
    
    self.res = [[DataExchange getLoginResponse] objectAtIndex:0];
    self.sec = [[DataExchange getSchedulerReponse] objectAtIndex:([DataExchange getScheduleDayIndex]>[DataExchange getSchedulerReponse].count?0:[DataExchange getScheduleDayIndex])];
    
    doctorNamesArray = [[NSMutableArray alloc] init];
    
    self.natureTblView.rowHeight = 55;
    pastEpisodesTxtVw.autocorrectionType = UITextAutocorrectionTypeNo;
    onsetTxtVw.autocorrectionType = UITextAutocorrectionTypeNo;
    durationTxtVw.autocorrectionType = UITextAutocorrectionTypeNo;
    
    
    
    
    [[associatedSymptomsTxtVw layer] setCornerRadius:5];
    associatedSymptomsTxtVw.autocorrectionType = UITextAutocorrectionTypeNo;
    [[chiefComplaintTxtVw layer] setCornerRadius:5];
    chiefComplaintTxtVw.autocorrectionType = UITextAutocorrectionTypeNo;
    [[otherSymptomsTxtVw layer] setCornerRadius:5];
    otherSymptomsTxtVw.autocorrectionType = UITextAutocorrectionTypeNo;
    
    drawImage = [[UIImageView alloc] initWithImage:nil];
	drawImage.frame = CGRectMake(0, 0, 510, 350);
    drawImage.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [labOrderImgView addSubview:drawImage];
    self.finalImageToBeSaved = labOrderImgView.image;
    
    daysBtn.layer.cornerRadius = 10;
    hrsBtn.layer.cornerRadius = 10;
    monthsBtn.layer.cornerRadius = 10;
    yrsBtn.layer.cornerRadius = 10;
    progressionBtn.layer.cornerRadius = 10;
    regressionBtn.layer.cornerRadius = 10;
    severitiesTblView.layer.cornerRadius = 10;
    daysBtn.clipsToBounds = true;
    hrsBtn.clipsToBounds = true;
    yrsBtn.clipsToBounds = true;
    monthsBtn.clipsToBounds = true;
    progressionBtn.clipsToBounds = true;
    regressionBtn.clipsToBounds = true;
    getDocDetails = true;
    [self.service getUserInvocation:[self.res.userRoleID stringValue] Async:true delegate:self];
    [self.service getVitalsInvocation:[self.res.userRoleID stringValue] delegate:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:self.view.window];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:self.view.window];
    
    [self daysBtnPrsd];
    [self progressionBtnPrsd];
    popoverVisible = false;
    
    pharmacyOrderView.layer.cornerRadius = 10;
    pharmacyOrderView.clipsToBounds = true;
    pharmacyOrderInnerView.layer.cornerRadius = 10;
    
    [self.service getSeverityInvocationWithdelegate:self];
    [self.service getMedRecNatureInvocationWithdelegate:self];
    vitalsBtn.titleLabel.lineBreakMode = UILineBreakModeWordWrap;
    
    if(hideNextPatientButton)
        nextPatientBtn.hidden = true;
    [self checkOnlyPatient];
    
    if (IS_OS_7_OR_LATER)
    {
        [self moveAllSubviewsDown];
        
    }
    else
    {
        
        
    }
}

- (void) moveAllSubviewsDown
{
    float barHeight = 65;
    int check=0;
    for (UIView *view in self.view.subviews) {
        
        if ([view isKindOfClass:[UIImageView class]] && check==0) {
            check=1;
        } else {
            view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y + barHeight, view.frame.size.width, view.frame.size.height);
        }
    }
    [self moveup];
}


- (void) moveup{
    
    if (IS_OS_7_OR_LATER)
    {
        self.healthConditionTblView.frame = CGRectMake(700,110,324,170);
    }
    else
    {
    }
    [self moveh];

}
- (void) moveh{
    
    if (IS_OS_7_OR_LATER)
    {
        self.allergiesTblView.frame = CGRectMake(700,325,324,170);
    }
    else
    {
    }
}



-(void)viewWillAppear:(BOOL)animated{
    UIToolbar* toolsLeft = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    // create the array to hold the buttons, which then gets added to the toolbar
    NSMutableArray *buttons = [[NSMutableArray alloc] initWithCapacity:3];
    UIBarButtonItem* bi = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back.png"] style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
    [buttons addObject:bi];
    [bi release];
    bi = [[UIBarButtonItem alloc] initWithTitle:@"Welcome" style:UIBarButtonItemStylePlain target:self action:nil];
    
    
    //new code
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];

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

-(void) setupPatientData{
    if(!self.activityController)
        self.activityController = [ISActivityOverlayController presentActivityOverViewController:self withLabel:@"Loading..."];
    
    doctorNamesArray = nil;
    self.lblName.text = self.pat.patName;
    if(![self.pat.patDOB isKindOfClass:[NSNull class]]){
        if([self.pat.patDOB length]!=0) {
            NSDateFormatter *df = [[[NSDateFormatter alloc] init] autorelease];
            [df setDateFormat:@"dd-MM-yyyy"];
            NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
            [dateFormatter setDateFormat:@"dd-MM-yyyy"];
            self.lblDOB.text = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:[CurrentVisitDetailViewController mfDateFromDotNetJSONString:pat.patDOB]]];
            self.lblAge.text = [CurrentVisitDetailViewController AgeFromString:[df stringFromDate:[PharmacyViewController mfDateFromDotNetJSONString:self.pat.patDOB]]];
        }
    }
    
    if ([[pat.genderID stringValue] isEqualToString:@"1"]) {
        self.lblSex.text = @"Male";
    }else if ([[pat.genderID stringValue] isEqualToString:@"2"]) {
        self.lblSex.text = @"Female";
    }
    
    if([DataExchange getPatImage]!=nil)
        [profileImage setBackgroundImage:[self resizeImage:[UIImage imageWithData:[DataExchange getPatImage]] size:profileImage.frame.size] forState:UIControlStateNormal];
    [self.service getPatientContactInvocation:[self.res.userRoleID stringValue] Contact_id:[pat.contactID stringValue] delegate:self];
    [self.service getPatMedRecordsInvocation:[self.res.userRoleID stringValue] mrNo:self.mrno subTenantId:self.sec.sub_tenant_id delegate:self];
    [self.service getPatientVitalsInvocation:[self.res.userRoleID stringValue] Mrno:self.mrno delegate:self];
}

- (void)keyboardDidHide:(NSNotification *)n{
    if(!self.popover.isPopoverVisible && !self.presentedViewController){
        CGRect viewFrame = self.view.frame;
        viewFrame.origin.y = 0;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.5];
        //do some animation
        [self.view setFrame:viewFrame];
        [UIView commitAnimations];
        popoverVisible = false;
    }
}

- (void)keyboardDidShow:(NSNotification *)n {
    if(!self.popover.isPopoverVisible && !self.presentedViewController){
        CGRect viewFrame = self.view.frame;
        viewFrame.origin.y = -220;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.5];
        //do some animation
        [self.view setFrame:viewFrame];
        [UIView commitAnimations];
        popoverVisible = false;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(void)GetMedRecNatureInvocationDidFinish:(GetMedRecNatureInvocation *)invocation
                    withMedRecNatureArray:(NSArray *)medRecArray
                                withError:(NSError *)error{
    if(!error){
        for (int i=0; i<medRecArray.count; i++) {
            if([[(MedRecNature*)[medRecArray objectAtIndex:i] RecNatureProperty] isEqualToString:@"Patient Complaints"])
                complaintsRecNatureId = [[(MedRecNature*)[medRecArray objectAtIndex:i] RecNatureId] integerValue];
            else if([[(MedRecNature*)[medRecArray objectAtIndex:i] RecNatureProperty] isEqualToString:@"Lab Report"])
                labReportRecNatureId = [[(MedRecNature*)[medRecArray objectAtIndex:i] RecNatureId] integerValue];
            else if([[(MedRecNature*)[medRecArray objectAtIndex:i] RecNatureProperty] isEqualToString:@"Pharmacy Order"])
                pharmacyOrderRecNatureId = [[(MedRecNature*)[medRecArray objectAtIndex:i] RecNatureId] integerValue];
            else if([[(MedRecNature*)[medRecArray objectAtIndex:i] RecNatureProperty] isEqualToString:@"Lab Order"])
                labOrderRecNatureId = [[(MedRecNature*)[medRecArray objectAtIndex:i] RecNatureId] integerValue];
            else if([[(MedRecNature*)[medRecArray objectAtIndex:i] RecNatureProperty] isEqualToString:@"Doctor Note"])
                doctorNoteRecNatureId = [[(MedRecNature*)[medRecArray objectAtIndex:i] RecNatureId] integerValue];
            else if([[(MedRecNature*)[medRecArray objectAtIndex:i] RecNatureProperty] isEqualToString:@"Current Visit Image"])
                currentVisitImageRecNatureId = [[(MedRecNature*)[medRecArray objectAtIndex:i] RecNatureId] integerValue];
            else if([[(MedRecNature*)[medRecArray objectAtIndex:i] RecNatureProperty] isEqualToString:@"Doctor Comments"])
                doctorCommentsRecNatureId = [[(MedRecNature*)[medRecArray objectAtIndex:i] RecNatureId] integerValue];
            else if([[(MedRecNature*)[medRecArray objectAtIndex:i] RecNatureProperty] isEqualToString:@"Referrals"])
                referralsRecNatureId = [[(MedRecNature*)[medRecArray objectAtIndex:i] RecNatureId] integerValue];
            else if([[(MedRecNature*)[medRecArray objectAtIndex:i] RecNatureProperty] isEqualToString:@"Template"])
                templateRecNatureId = [[(MedRecNature*)[medRecArray objectAtIndex:i] RecNatureId] integerValue];
            else if([[(MedRecNature*)[medRecArray objectAtIndex:i] RecNatureProperty] isEqualToString:@"Plan"])
                planRecNatureId = [[(MedRecNature*)[medRecArray objectAtIndex:i] RecNatureId] integerValue];
        }
        [self setupPatientData];
    }
}

-(void)getUserInvocationDidFinish:(GetUserInvocation*)invocation
                     withResponse:(NSArray*)responses
                        withError:(NSError*)error{
    if(!error && responses.count>0){
        [self.doctorNamesArray replaceObjectAtIndex:currentCount withObject:[(UserDetail*)[responses objectAtIndex:0] u_name]];
        for(int i=currentCount;i<patMedRecordsArray.count;i++)
            if([[self.doctorNamesArray objectAtIndex:i] isEqualToString:@"Doctor Name"]){
                [self.service getUserInvocation:[(PatMedRecords*)[patMedRecordsArray objectAtIndex:i] UserRoleId] Async:FALSE  delegate:self];
                currentCount++;
                break;
            }
        if(doctorNamesArray.count==patMedRecordsArray.count){
            [natureTblView reloadData];
            [natureTblView beginUpdates];
            [natureTblView endUpdates];
        }
    }
}

-(void) getPatMedRecordsInvocationDidFinish:(GetPatMedRecords*)invocations
                          withPatMedRecords:(NSArray*)patMedRecords
                                  withError:(NSError*)error{
    if (self.activityController) {
        [self.activityController dismissActivity];
        self.activityController = nil;
    }
    if(!error && patMedRecords.count>0){
        currentCount = 0;
        self.patMedRecordsArray = nil;
        self.patMedRecordsArray = [[[NSMutableArray alloc] initWithArray:patMedRecords] autorelease];
        self.dateDtls = nil;
        self.imageDtls = nil;
        self.dateDtls = [[[NSMutableArray alloc] init] autorelease];
        self.imageDtls = [[[NSMutableArray alloc] init] autorelease];
        doctorNamesArray = [[NSMutableArray alloc] init];
        PatMedRecords* temp1 = (PatMedRecords*)[self.patMedRecordsArray objectAtIndex:0];
        [profileImage setBackgroundImage:[self resizeImage:[[[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[temp1 ImagePath]]]] autorelease] size:profileImage.frame.size] forState:UIControlStateNormal];
        if (![temp1 Date]) {
            return;
        }
        NSDateFormatter *df = [[[NSDateFormatter alloc] init] autorelease];
        [df setDateFormat:@"dd-MM-yyyy"];
        for (int i=0; i<[patMedRecords count]; i++) {
            [doctorNamesArray addObject:(NSString*) @"Doctor Name"];
            [self.dateDtls addObject:[CurrentVisitDetailViewController mfDateFromDotNetJSONString:[(PatMedRecords*)[patMedRecords objectAtIndex:i] Date]]];
            PatMedRecords* temp = (PatMedRecords*)[self.patMedRecordsArray objectAtIndex:i];
            temp.Date = [NSString stringWithFormat:@"%@",[df stringFromDate:[self.dateDtls objectAtIndex:i]]];
            [self.patMedRecordsArray replaceObjectAtIndex:i withObject:temp];
            if([[(PatMedRecords*)[patMedRecords objectAtIndex:i] RecNatureId] integerValue]==complaintsRecNatureId)
                [self.imageDtls addObject:@"report.png"];
            else if([[(PatMedRecords*)[patMedRecords objectAtIndex:i] RecNatureId] integerValue]==labReportRecNatureId)
                [self.imageDtls addObject:@"laboratory.png"];
            else if([[(PatMedRecords*)[patMedRecords objectAtIndex:i] RecNatureId] integerValue]==pharmacyOrderRecNatureId)
                [self.imageDtls addObject:@"pripcrition.png"];
            else if([[(PatMedRecords*)[patMedRecords objectAtIndex:i] RecNatureId] integerValue]==labOrderRecNatureId)
                [self.imageDtls addObject:@"lab.png"];
            else if([[(PatMedRecords*)[patMedRecords objectAtIndex:i] RecNatureId] integerValue]==doctorNoteRecNatureId)
                [self.imageDtls addObject:@"notes.png"];
            else if([[(PatMedRecords*)[patMedRecords objectAtIndex:i] RecNatureId] integerValue]==currentVisitImageRecNatureId)
                [self.imageDtls addObject:@"current-visit.png"];
            else if([[(PatMedRecords*)[patMedRecords objectAtIndex:i] RecNatureId] integerValue]==doctorCommentsRecNatureId)
                [self.imageDtls addObject:@"doctor_comment.png"];
            else if([[(PatMedRecords*)[patMedRecords objectAtIndex:i] RecNatureId] integerValue]==referralsRecNatureId)
                [self.imageDtls addObject:@"doctor_referrals.png"];
            else if([[(PatMedRecords*)[patMedRecords objectAtIndex:i] RecNatureId] integerValue]==templateRecNatureId)
                [self.imageDtls addObject:@"doctor_template.png"];
            else if([[(PatMedRecords*)[patMedRecords objectAtIndex:i] RecNatureId] integerValue]==planRecNatureId)
                [self.imageDtls addObject:@"plan.png"];
            else
                [self.imageDtls addObject:@"cross.png"];
        }
        [natureTblView reloadData];
        [natureTblView beginUpdates];
        [natureTblView endUpdates];
        if(![patMedRecords count]==0){
            [self.service getUserInvocation:[(PatMedRecords*)[self.patMedRecordsArray objectAtIndex:0] UserRoleId] Async:false delegate:self];
        }
    }
}

-(void) getPatientContactDetailDidFinish:(GetPatientContactDetail*)invocation
                            withPatients:(NSArray*)patient_
                               withError:(NSError*)error{
    if(!error){
        PatientContactDetails *patDtls = [patient_ objectAtIndex:0];
        self.previousPatEmail = [NSString stringWithFormat:@"%@",patDtls.Email];
        self.previousPatMob = [NSString stringWithFormat:@"+91%@",[patDtls.Mobile stringByReplacingOccurrencesOfString:@"+91" withString:@""]];
        self.lblNumber.text = [NSString stringWithFormat:@"+91%@",[patDtls.Mobile stringByReplacingOccurrencesOfString:@"+91" withString:@""]];
    }
}

-(void) getPatComplaintsInvocationDidFinish:(GetPatComplaints*)invocations
                          withPatComplaints:(NSArray*)patComplaints
                                  withError:(NSError*)error{
    if(!error && (PatientComplaint*)[patComplaints objectAtIndex:0]!=Nil){
        labOrderView.hidden = true;
        pharmacyOrderView.hidden = true;
        NSString* durationStr;
        PatientComplaint* complaint = (PatientComplaint*)[patComplaints objectAtIndex:0];
        chiefComplaintTxtVw.text = complaint.cheifComp;
        onsetTxtVw.text = complaint.onset;
        currentComplaint = complaint;
        currentComplaintId = [complaint.complaintId integerValue];
        durationStr = complaint.duration;
        if([durationStr rangeOfString:@"Days"].location != NSNotFound){
            durationStr = [durationStr stringByReplacingOccurrencesOfString:@"Days" withString:@""];
            [daysBtn setImage:[self imageWithColor:[UIColor grayColor]] forState:UIControlStateNormal];
            [hrsBtn setImage:[self imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
            [monthsBtn setImage:[self imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
            [yrsBtn setImage:[self imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
        }
        else if([durationStr rangeOfString:@"Mnths"].location != NSNotFound){
            durationStr = [durationStr stringByReplacingOccurrencesOfString:@"Mnths" withString:@""];
            [daysBtn setImage:[self imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
            [hrsBtn setImage:[self imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
            [monthsBtn setImage:[self imageWithColor:[UIColor grayColor]] forState:UIControlStateNormal];
            [yrsBtn setImage:[self imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
        }else if([durationStr rangeOfString:@"Yrs"].location != NSNotFound){
            durationStr = [durationStr stringByReplacingOccurrencesOfString:@"Yrs" withString:@""];
            [daysBtn setImage:[self imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
            [hrsBtn setImage:[self imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
            [monthsBtn setImage:[self imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
            [yrsBtn setImage:[self imageWithColor:[UIColor grayColor]] forState:UIControlStateNormal];
        }else{
            durationStr = [durationStr stringByReplacingOccurrencesOfString:@"Hrs" withString:@""];
            [daysBtn setImage:[self imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
            [hrsBtn setImage:[self imageWithColor:[UIColor grayColor]] forState:UIControlStateNormal];
            [monthsBtn setImage:[self imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
            [yrsBtn setImage:[self imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
        }
        durationTxtVw.text = durationStr;
        if(![complaint.severityId isKindOfClass:[NSNull class]]){
            NSString* sevTxt = [(Severity*)[severitiesArray objectAtIndex:([complaint.severityId integerValue]-1)] SeverityProperty];
            [severityBtn.titleLabel setText:sevTxt];
            currentSeverity = [complaint.severityId integerValue]-1;
        }
        otherSymptomsTxtVw.text = complaint.otherSymptoms;
        associatedSymptomsTxtVw.text = complaint.associatedSymptoms;
        pastEpisodesTxtVw.text = complaint.episodesInPast;
        [progressionBtn setImage:[self imageWithColor:([complaint.progression isEqualToString:@"true"]?[UIColor grayColor]:[UIColor clearColor])] forState:UIControlStateNormal];
        [regressionBtn setImage:[self imageWithColor:([complaint.regression isEqualToString:@"true"]?[UIColor grayColor]:[UIColor clearColor])] forState:UIControlStateNormal];
    }
    else{
        proAlertView *alert = [[proAlertView alloc] initWithTitle:@"Error !" message:[[error userInfo] objectForKey:@"message"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
        [alert show];
        [alert release];
    }
    if (self.activityController) {
        [self.activityController dismissActivity];
        self.activityController = Nil;
    }
}

-(void)getPatHealthInvocationDidFinish:(GetPatMedRecords *)invocations
                  withPatHealthRecords:(NSArray *)patHealthRecords
                             withError:(NSError *)error{
    if(!error){
        healthArray = [[NSMutableArray alloc] initWithArray:patHealthRecords];
        [healthConditionTblView reloadData];
    }
}

-(void)getPatAllergyInvocationDidFinish:(GetPatMedRecords *)invocations
                       withPatAllergies:(NSArray *)patAllergies
                              withError:(NSError *)error{
    if(!error){
        allergiesArray = [[NSMutableArray alloc] initWithArray:patAllergies];
        [allergiesTblView reloadData];
        
    }
}

-(void) getPaientVitalsInvocationDidFinish:(GetPaientVitalsInvocation*)invocation
                                withVitals:(NSArray*)vitals
                                 withError:(NSError*)error{
    if(!error){
        vitalsArray = [[NSMutableArray alloc] initWithArray:vitals];
        [vitalsTblView reloadData];
    }
}

-(void)getPatMedRecordsInvocationDidFinish:(GetPatMedRecords *)invocations
                        withPatAddressCity:(NSString *)cityStr
                                 withError:(NSError *)error{
    if(!error){
        self.patientCityString = [NSString stringWithFormat:@"%@",cityStr];
    }
}

-(void) GetSeverityInvocationDidFinish:(GetSeverityInvocation*)invocation
                        withSeverities:(NSArray*)Severities
                             withError:(NSError*)error{
    if(!error){
        severitiesArray = [[NSMutableArray alloc] initWithArray:Severities];
        [severitiesTblView reloadData];
        [severitiesTblView setFrame:CGRectMake(severitiesTblView.frame.origin.x, severitiesTblView.frame.origin.y, severitiesTblView.frame.size.width, (44*Severities.count>250?250:44*Severities.count))];
    }
}

-(void) GetVitalsInvocationDidFinish:(GetVitalsInvocation *)invocation
                          withVitals:(NSArray *)vitalsArr
                           withError:(NSError *)error{
    vitalsValuesArray = [[NSMutableArray alloc] initWithArray:vitalsArr];
    vitalsNamesArray = [[NSMutableArray alloc] init];
    for (int i =0; i<vitalsValuesArray.count; i++) {
        [vitalsNamesArray addObject:[(PatVital*)[vitalsValuesArray objectAtIndex:i] VitalName]];
    }
    [vitalsNamesArray insertObject:@"--Select All--" atIndex:0];
}

-(void) GetLabOrPharmacyInvocationDidFinish:(GetLabOrPharmacyInvocation*)invocation
                               withLabOrder:(LabOrder*)labOrder
                                  withError:(NSError*)error{
    if(!error){
        pharmacyOrderView.hidden = true;
        labOrderView.hidden = false;
        labOrderImgView.image = [[[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@/image/labreport/%@",[DataExchange getDomainUrl],[labOrder imagePath]]]]] autorelease];
    }
    else{
        proAlertView *message = [[proAlertView alloc] initWithTitle:@"" message:@"No data available for this Lab order" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [message setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
        [message show];
        [message release];
    }
    if (self.activityController) {
        [self.activityController dismissActivity];
        self.activityController = nil;
    }
}

-(void) GetLabOrPharmacyInvocationDidFinish:(GetLabOrPharmacyInvocation*)invocation
                          withPharmacyOrder:(NSArray*)pharmacyOrder
                                  withError:(NSError*)error{
    if(!error){
        currPharmacyOrderArray = [[NSMutableArray alloc] initWithArray:pharmacyOrder];
        [self showPharmacyOrder];
    }
    else{
        for(UIView *v in [pharmacyOrderScrollView subviews])
        {
            [v removeFromSuperview];
        }
        proAlertView *message = [[proAlertView alloc] initWithTitle:@"" message:@"No data available for this Pharmacy order" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [message setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
        [message show];
        [message release];
    }
    if (self.activityController) {
        [self.activityController dismissActivity];
        self.activityController = nil;
    }
}

-(void) GetLabReportInvocationDidFinish:(GetLabReportInvocation *)invocation
                           withDocument:(NSURL *)labDocUrl
                              withError:(NSError *)error{
    if (self.activityController) {
        [self.activityController dismissActivity];
        self.activityController = nil;
    }
    if(!error){
        pdfOrDocController = [[UIViewController alloc] init];
        docView = [[UIWebView alloc] initWithFrame:CGRectMake(0, topBarHeight, 800, 513)];
        NSURLRequest *request = [NSURLRequest requestWithURL:labDocUrl];
        [docView loadRequest:request];
        [pdfOrDocController.view setBackgroundColor:[UIColor whiteColor]];
        [pdfOrDocController.view addSubview:docView];
        
        UIImageView* topBgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 800, topBarHeight)];
        topBgView.image = [UIImage imageNamed:@"topBar.png"];
        [pdfOrDocController.view addSubview:topBgView];
        [topBgView release];
        
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(5, 5, 25, 25)];
        [btn addTarget:self action:@selector(closePopup) forControlEvents:UIControlEventTouchUpInside];
        [btn setBackgroundImage:[UIImage imageNamed:@"cross.png"] forState:UIControlStateNormal];
        [pdfOrDocController.view addSubview:btn];
        
        UIButton* btnEdit = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnEdit setFrame:CGRectMake(760, 5, 25, 25)];
        [btnEdit addTarget:self action:@selector(pdfOrDocEdit) forControlEvents:UIControlEventTouchUpInside];
        [btnEdit setBackgroundImage:[UIImage imageNamed:@"pen.png"] forState:UIControlStateNormal];
        [pdfOrDocController.view addSubview:btnEdit];
        [btnEdit release];
        
        UILabel* label1 = [[UILabel alloc] initWithFrame:CGRectMake(46, 0, 230, topBarHeight/numRows)];
        label1.text = [NSString stringWithFormat:@"Patient: %@",pat.patName];
        label1.textAlignment = UITextAlignmentLeft;
        label1.backgroundColor = [UIColor clearColor];
        [pdfOrDocController.view addSubview:label1];
        UILabel* label11 = [[UILabel alloc] initWithFrame:CGRectMake(46, topBarHeight/numRows, 230, topBarHeight/numRows)];
        label11.text = [NSString stringWithFormat:@"City: %@",self.patientCityString];
        label11.textAlignment = UITextAlignmentLeft;
        label11.backgroundColor = [UIColor clearColor];
        [pdfOrDocController.view addSubview:label11];
        NSDateFormatter *df = [[[NSDateFormatter alloc] init] autorelease];
        [df setDateFormat:@"dd-MM-yyyy"];
        NSString* dob = [df stringFromDate:[PharmacyViewController mfDateFromDotNetJSONString:pat.patDOB]];
        UILabel* label2 = [[UILabel alloc] initWithFrame:CGRectMake(46, (2*topBarHeight)/numRows, 230, topBarHeight/numRows)];
        label2.text = [NSString stringWithFormat:@"Age.: %@",[CurrentVisitDetailViewController AgeFromString:dob]];
        label2.textAlignment = UITextAlignmentLeft;
        label2.backgroundColor = [UIColor clearColor];
        [pdfOrDocController.view addSubview:label2];
        UILabel* label3 = [[UILabel alloc] initWithFrame:CGRectMake(46, (3*topBarHeight)/numRows, 230, topBarHeight/numRows)];
        label3.text = [NSString stringWithFormat:@"Mobile No.: %@",lblNumber.text];
        label3.textAlignment = UITextAlignmentLeft;
        label3.backgroundColor = [UIColor clearColor];
        [pdfOrDocController.view addSubview:label3];
        
        UILabel* label4 = [[UILabel alloc] initWithFrame:CGRectMake(524, 0, 230, topBarHeight/numRows)];//doctor name
        label4.text = [NSString stringWithFormat:@"%@",([[DataExchange getDocDisplayData] count]==0?@"":[[DataExchange getDocDisplayData] objectAtIndex:0])];
        label4.textAlignment = UITextAlignmentCenter;
        label4.backgroundColor = [UIColor clearColor];
        [pdfOrDocController.view addSubview:label4];
        UILabel* label5 = [[UILabel alloc] initWithFrame:CGRectMake(524, topBarHeight/numRows, 230, topBarHeight/numRows)];//doctor address
        label5.text = [NSString stringWithFormat:@"%@",([[DataExchange getDocDisplayData] count]==0?@"":[[DataExchange getDocDisplayData] objectAtIndex:1])];
        label5.textAlignment = UITextAlignmentCenter;
        label5.backgroundColor = [UIColor clearColor];
        [pdfOrDocController.view addSubview:label5];
        UILabel* label6 = [[UILabel alloc] initWithFrame:CGRectMake(524, (2*topBarHeight)/numRows, 230, topBarHeight/numRows)];//doctor address2
        label6.text = [NSString stringWithFormat:@"%@",([[DataExchange getDocDisplayData] count]==0?@"":[[DataExchange getDocDisplayData] objectAtIndex:2])];
        label6.textAlignment = UITextAlignmentCenter;
        label6.backgroundColor = [UIColor clearColor];
        [pdfOrDocController.view addSubview:label6];
        UILabel* label7 = [[UILabel alloc] initWithFrame:CGRectMake(524, (3*topBarHeight)/numRows, 230, topBarHeight/numRows)];//doctor mobile
        label7.text = [NSString stringWithFormat:@"%@",([[DataExchange getDocDisplayData] count]==0?@"":[[DataExchange getDocDisplayData] objectAtIndex:3])];
        label7.textAlignment = UITextAlignmentCenter;
        label7.backgroundColor = [UIColor clearColor];
        [pdfOrDocController.view addSubview:label7];
        
        UIView* border = [[UIView alloc] initWithFrame:CGRectMake(0, topBarHeight-3, 800, 3)];
        border.backgroundColor = [UIColor grayColor];
        [pdfOrDocController.view addSubview:border];
        [border release];
        [label1 release];
        [label2 release];
        [label3 release];
        [label4 release];
        [label5 release];
        [label6 release];
        [label7 release];
        
        self.popover = [[UIPopoverController alloc] initWithContentViewController:pdfOrDocController];
        self.popover.popoverContentSize = CGSizeMake(800, 513+topBarHeight);
        self.popover.delegate = self;
        [self.popover presentPopoverFromRect:CGRectMake(0, 0, 20, 20) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }else if (self.activityController) {
        [self.activityController dismissActivity];
        self.activityController = nil;
    }
}

-(void) GetLabReportInvocationDidFinish:(GetLabReportInvocation *)invocation
                         withLabReports:(NSArray *)LabReports
                              withError:(NSError *)error{
    if (self.activityController) {
        [self.activityController dismissActivity];
        self.activityController = nil;
    }
    if(!error && LabReports.count>0){
        pharmacyOrderView.hidden = true;
        labOrderView.hidden = false;
        labOrderImgView.image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@/%@",[DataExchange getDomainUrl],[LabReports objectAtIndex:0]]]]];
        if(previousNotesImageClicked!=nil){//comparison case
            compareImagesAlert = [[proAlertView alloc] initWithTitle:nil message:@"Would you like to compare this Lab report with the previous image?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes",nil];
            [compareImagesAlert setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
            compareImagesAlert.tag = 99;//lab reports case
            [compareImagesAlert show];
        }
    }
    else{
        proAlertView *message = [[proAlertView alloc] initWithTitle:@"" message:@"No data available for this Lab Report" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [message setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
        [message show];
        [message release];
    }
}

-(void)getAsyncUserInvocationDidFinish:(GetUserInvocation *)invocation
                          withResponse:(NSArray *)responses
                             withError:(NSError *)error{
    if(!error){
        if(getDocDetails){
            self.currLoggedInDoctor = (UserDetail*)[responses objectAtIndex:0];
            [self.service getDocConOrAddInvocation:[self.res.userRoleID stringValue] AddrOrContId:[[(UserDetail*)[responses objectAtIndex:0] addressId] stringValue] AddrOrCont:YES delegate:self];
            [self.service getDocConOrAddInvocation:[self.res.userRoleID stringValue] AddrOrContId:[[(UserDetail*)[responses objectAtIndex:0] contactId] stringValue] AddrOrCont:NO delegate:self];
            getDocDetails = false;
        }
        else{
            self.currentDoctor = [NSString stringWithFormat:@"%@",[(UserDetail*)[responses objectAtIndex:0] u_name]];
        }
    }
}

-(void)GetDocAddrInvocationDidFinish:(GetDocAddrOrContInvocation *)invocation
                 withDocAddressArray:(NSArray *)doctAddrArray
                           withError:(NSError *)error{
    if(!error){
        self.currDocAddress = (PatientAddress*)[doctAddrArray objectAtIndex:0];
    }
}

-(void)GetDocContInvocationDidFinish:(GetDocAddrOrContInvocation *)invocation
                 withDocContactArray:(NSArray *)doctContactArray
                           withError:(NSError *)error{
    if(!error){
        self.currDocContact = (PatientContactDetails*)[doctContactArray objectAtIndex:0];
    }
}

-(void) GetNotesInvocationDidFinish:(GetNotesInvocation *)invocation
                 withNotesDataArray:(NSArray *)notesArray
                          withError:(NSError *)error{
    if(!error){
        for (int i=0; i<notesArray.count; i++) {
            if([[notesArray objectAtIndex:i] isKindOfClass:[UIImage class]]){
                if(previousNotesImageClicked!=nil){//comparison case
                    labOrderImgView.image = (UIImage*)[notesArray objectAtIndex:i];
                    compareImagesAlert = [[proAlertView alloc] initWithTitle:nil message:@"Would you like to compare this doctor note with the previous image?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes",nil];
                    [compareImagesAlert setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
                    compareImagesAlert.tag = -99;// notes case
                    [compareImagesAlert show];
                }
                else if(isCurrentVisitImage){
                    isCurrentVisitImage = false;
                    CurrImageryEditViewController* controller = [[CurrImageryEditViewController alloc] initWithNibName:@"CurrImageryEditViewController" bundle:nil];
                    controller.userRoleId = [self.res.userRoleID stringValue];
                    controller.mrno = self.mrno;
                    controller.mParent = self;
                    controller.firstImage = (UIImage*)[notesArray objectAtIndex:i];
                    [self presentModalViewController:controller animated:YES];
                    [controller release];
                }else{
                    UIViewController* controller = [[UIViewController alloc] init];
                    UIImage* currImg = (UIImage*)[notesArray objectAtIndex:i];
                    UIImageView* imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 800, currImg.size.height*800/(currImg.size.width))];
                    UIScrollView* scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, topBarHeight, 800, 513)];
                    scrollView.delegate = self;
                    [scrollView addSubview:imgView];
                    imgView.tag = 999;
                    scrollView.userInteractionEnabled = true;
                    scrollView.multipleTouchEnabled = true;
                    scrollView.zoomScale = 4.0;
                    scrollView.minimumZoomScale = 1;
                    scrollView.maximumZoomScale = 4;
                    imgView.image = currImg;
                    [controller.view setBackgroundColor:[UIColor whiteColor]];
                    [controller.view addSubview:scrollView];
                    
                    UIImageView* topBgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 800, topBarHeight)];
                    topBgView.image = [UIImage imageNamed:@"topBar.png"];
                    [controller.view addSubview:topBgView];
                    [topBgView release];
                    
                    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
                    [btn setFrame:CGRectMake(5, 5, 25, 25)];
                    [btn addTarget:self action:@selector(closePopup) forControlEvents:UIControlEventTouchUpInside];
                    [btn setBackgroundImage:[UIImage imageNamed:@"cross.png"] forState:UIControlStateNormal];
                    [controller.view addSubview:btn];
                    
                    UILabel* label1 = [[UILabel alloc] initWithFrame:CGRectMake(46, 0, 230, topBarHeight/numRows)];
                    label1.text = [NSString stringWithFormat:@"Patient: %@",pat.patName];
                    label1.textAlignment = UITextAlignmentLeft;
                    label1.backgroundColor = [UIColor clearColor];
                    [controller.view addSubview:label1];
                    UILabel* label11 = [[UILabel alloc] initWithFrame:CGRectMake(46, topBarHeight/numRows, 230, topBarHeight/numRows)];
                    label11.text = [NSString stringWithFormat:@"City: %@",self.patientCityString];
                    label11.textAlignment = UITextAlignmentLeft;
                    label11.backgroundColor = [UIColor clearColor];
                    [controller.view addSubview:label11];
                    NSDateFormatter *df = [[[NSDateFormatter alloc] init] autorelease];
                    [df setDateFormat:@"dd-MM-yyyy"];
                    NSString* dob = [df stringFromDate:[PharmacyViewController mfDateFromDotNetJSONString:pat.patDOB]];
                    UILabel* label2 = [[UILabel alloc] initWithFrame:CGRectMake(46, (2*topBarHeight)/numRows, 230, topBarHeight/numRows)];
                    label2.text = [NSString stringWithFormat:@"Age.: %@",[CurrentVisitDetailViewController AgeFromString:dob]];
                    label2.textAlignment = UITextAlignmentLeft;
                    label2.backgroundColor = [UIColor clearColor];
                    [controller.view addSubview:label2];
                    UILabel* label3 = [[UILabel alloc] initWithFrame:CGRectMake(46, (3*topBarHeight)/numRows, 230, topBarHeight/numRows)];
                    label3.text = [NSString stringWithFormat:@"Mobile No.: %@",lblNumber.text];
                    label3.textAlignment = UITextAlignmentLeft;
                    label3.backgroundColor = [UIColor clearColor];
                    [controller.view addSubview:label3];
                    
                    UILabel* label4 = [[UILabel alloc] initWithFrame:CGRectMake(524, 0, 230, topBarHeight/numRows)];//doctor name
                    label4.text = [NSString stringWithFormat:@"%@",([[DataExchange getDocDisplayData] count]==0?@"":[[DataExchange getDocDisplayData] objectAtIndex:0])];
                    label4.textAlignment = UITextAlignmentCenter;
                    label4.backgroundColor = [UIColor clearColor];
                    [controller.view addSubview:label4];
                    UILabel* label5 = [[UILabel alloc] initWithFrame:CGRectMake(524, topBarHeight/numRows, 230, topBarHeight/numRows)];//doctor address
                    label5.text = [NSString stringWithFormat:@"%@",([[DataExchange getDocDisplayData] count]==0?@"":[[DataExchange getDocDisplayData] objectAtIndex:1])];
                    label5.textAlignment = UITextAlignmentCenter;
                    label5.backgroundColor = [UIColor clearColor];
                    [controller.view addSubview:label5];
                    UILabel* label6 = [[UILabel alloc] initWithFrame:CGRectMake(524, (2*topBarHeight)/numRows, 230, topBarHeight/numRows)];//doctor address2
                    label6.text = [NSString stringWithFormat:@"%@",([[DataExchange getDocDisplayData] count]==0?@"":[[DataExchange getDocDisplayData] objectAtIndex:2])];
                    label6.textAlignment = UITextAlignmentCenter;
                    label6.backgroundColor = [UIColor clearColor];
                    [controller.view addSubview:label6];
                    UILabel* label7 = [[UILabel alloc] initWithFrame:CGRectMake(524, (3*topBarHeight)/numRows, 230, topBarHeight/numRows)];//doctor mobile
                    label7.text = [NSString stringWithFormat:@"%@",([[DataExchange getDocDisplayData] count]==0?@"":[[DataExchange getDocDisplayData] objectAtIndex:3])];
                    label7.textAlignment = UITextAlignmentCenter;
                    label7.backgroundColor = [UIColor clearColor];
                    [controller.view addSubview:label7];
                    
                    UIView* border = [[UIView alloc] initWithFrame:CGRectMake(0, topBarHeight-3, 800, 3)];
                    border.backgroundColor = [UIColor grayColor];
                    [controller.view addSubview:border];
                    [border release];
                    [label1 release];
                    [label2 release];
                    [label3 release];
                    [label4 release];
                    [label5 release];
                    [label6 release];
                    [label7 release];
                    
                    self.popover = [[UIPopoverController alloc] initWithContentViewController:controller];
                    self.popover.popoverContentSize = CGSizeMake(800, 513+topBarHeight);
                    self.popover.delegate = self;
                    [self.popover presentPopoverFromRect:CGRectMake(0, 0, 20, 20) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
                    [imgView release];
                    [controller release];
                }
            }
            else if([[notesArray objectAtIndex:i] isKindOfClass:[NSString class]]){
                UIViewController* controller = [[UIViewController alloc] init];
                UITextView* txtView = [[UITextView alloc] initWithFrame:CGRectMake(0, topBarHeight, 800, 513)];
                txtView.text = (NSString*)[notesArray objectAtIndex:i];
                txtView.editable = false;
                txtView.font = [UIFont fontWithName:@"TimesNewRomanPSMT" size:16];
                [controller.view setBackgroundColor:[UIColor whiteColor]];
                [controller.view addSubview:txtView];
                
                UIImageView* topBgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 800, topBarHeight)];
                topBgView.image = [UIImage imageNamed:@"topBar.png"];
                [controller.view addSubview:topBgView];
                [topBgView release];
                
                UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
                [btn setFrame:CGRectMake(5, 5, 25, 25)];
                [btn addTarget:self action:@selector(closePopup) forControlEvents:UIControlEventTouchUpInside];
                [btn setBackgroundImage:[UIImage imageNamed:@"cross.png"] forState:UIControlStateNormal];
                [controller.view addSubview:btn];
                
                UILabel* label1 = [[UILabel alloc] initWithFrame:CGRectMake(46, 0, 230, topBarHeight/numRows)];
                label1.text = [NSString stringWithFormat:@"Patient: %@",pat.patName];
                label1.textAlignment = UITextAlignmentLeft;
                label1.backgroundColor = [UIColor clearColor];
                [controller.view addSubview:label1];
                UILabel* label11 = [[UILabel alloc] initWithFrame:CGRectMake(46, topBarHeight/numRows, 230, topBarHeight/numRows)];
                label11.text = [NSString stringWithFormat:@"City: %@",self.patientCityString];
                label11.textAlignment = UITextAlignmentLeft;
                label11.backgroundColor = [UIColor clearColor];
                [controller.view addSubview:label11];
                NSDateFormatter *df = [[[NSDateFormatter alloc] init] autorelease];
                [df setDateFormat:@"dd-MM-yyyy"];
                NSString* dob = [df stringFromDate:[PharmacyViewController mfDateFromDotNetJSONString:pat.patDOB]];
                UILabel* label2 = [[UILabel alloc] initWithFrame:CGRectMake(46, (2*topBarHeight)/numRows, 230, topBarHeight/numRows)];
                label2.text = [NSString stringWithFormat:@"Age.: %@",[CurrentVisitDetailViewController AgeFromString:dob]];
                label2.textAlignment = UITextAlignmentLeft;
                label2.backgroundColor = [UIColor clearColor];
                [controller.view addSubview:label2];
                UILabel* label3 = [[UILabel alloc] initWithFrame:CGRectMake(46, (3*topBarHeight)/numRows, 230, topBarHeight/numRows)];
                label3.text = [NSString stringWithFormat:@"Mobile No.: %@",lblNumber.text];
                label3.textAlignment = UITextAlignmentLeft;
                label3.backgroundColor = [UIColor clearColor];
                [controller.view addSubview:label3];
                
                UILabel* label4 = [[UILabel alloc] initWithFrame:CGRectMake(524, 0, 230, topBarHeight/numRows)];//doctor name
                label4.text = [NSString stringWithFormat:@"%@",([[DataExchange getDocDisplayData] count]==0?@"":[[DataExchange getDocDisplayData] objectAtIndex:0])];
                label4.textAlignment = UITextAlignmentCenter;
                label4.backgroundColor = [UIColor clearColor];
                [controller.view addSubview:label4];
                UILabel* label5 = [[UILabel alloc] initWithFrame:CGRectMake(524, topBarHeight/numRows, 230, topBarHeight/numRows)];//doctor address
                label5.text = [NSString stringWithFormat:@"%@",([[DataExchange getDocDisplayData] count]==0?@"":[[DataExchange getDocDisplayData] objectAtIndex:1])];
                label5.textAlignment = UITextAlignmentCenter;
                label5.backgroundColor = [UIColor clearColor];
                [controller.view addSubview:label5];
                UILabel* label6 = [[UILabel alloc] initWithFrame:CGRectMake(524, (2*topBarHeight)/numRows, 230, topBarHeight/numRows)];//doctor address2
                label6.text = [NSString stringWithFormat:@"%@",([[DataExchange getDocDisplayData] count]==0?@"":[[DataExchange getDocDisplayData] objectAtIndex:2])];
                label6.textAlignment = UITextAlignmentCenter;
                label6.backgroundColor = [UIColor clearColor];
                [controller.view addSubview:label6];
                UILabel* label7 = [[UILabel alloc] initWithFrame:CGRectMake(524, (3*topBarHeight)/numRows, 230, topBarHeight/numRows)];//doctor mobile
                label7.text = [NSString stringWithFormat:@"%@",([[DataExchange getDocDisplayData] count]==0?@"":[[DataExchange getDocDisplayData] objectAtIndex:3])];
                label7.textAlignment = UITextAlignmentCenter;
                label7.backgroundColor = [UIColor clearColor];
                [controller.view addSubview:label7];
                
                UIView* border = [[UIView alloc] initWithFrame:CGRectMake(0, topBarHeight-3, 800, 3)];
                border.backgroundColor = [UIColor grayColor];
                [controller.view addSubview:border];
                [border release];
                [label1 release];
                [label2 release];
                [label3 release];
                [label4 release];
                [label5 release];
                [label6 release];
                [label7 release];
                
                self.popover = [[UIPopoverController alloc] initWithContentViewController:controller];
                self.popover.popoverContentSize = CGSizeMake(800, 513+topBarHeight);
                self.popover.delegate = self;
                [self.popover presentPopoverFromRect:CGRectMake(0, 0, 20, 20) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
                [txtView release];
                [controller release];
            }
            else if([[notesArray objectAtIndex:i] isKindOfClass:[NSMutableArray class]]){//open pdf and doc files in a webview
                pdfOrDocController = [[UIViewController alloc] init];
                docView = [[UIWebView alloc] initWithFrame:CGRectMake(0, topBarHeight, 800, 513)];
                NSURL *url = [(NSMutableArray*)[notesArray objectAtIndex:i] objectAtIndex:0];
                NSURLRequest *request = [NSURLRequest requestWithURL:url];
                [docView loadRequest:request];
                [pdfOrDocController.view setBackgroundColor:[UIColor whiteColor]];
                [pdfOrDocController.view addSubview:docView];
                
                UIImageView* topBgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 800, topBarHeight)];
                topBgView.image = [UIImage imageNamed:@"topBar.png"];
                [pdfOrDocController.view addSubview:topBgView];
                [topBgView release];
                
                UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
                [btn setFrame:CGRectMake(5, 5, 25, 25)];
                [btn addTarget:self action:@selector(closePopup) forControlEvents:UIControlEventTouchUpInside];
                [btn setBackgroundImage:[UIImage imageNamed:@"cross.png"] forState:UIControlStateNormal];
                [pdfOrDocController.view addSubview:btn];
                
                UIButton* btnEdit = [UIButton buttonWithType:UIButtonTypeCustom];
                [btnEdit setFrame:CGRectMake(760, 5, 25, 25)];
                [btnEdit addTarget:self action:@selector(pdfOrDocEdit) forControlEvents:UIControlEventTouchUpInside];
                [btnEdit setBackgroundImage:[UIImage imageNamed:@"pen.png"] forState:UIControlStateNormal];
                [pdfOrDocController.view addSubview:btnEdit];
                [btnEdit release];
                
                UILabel* label1 = [[UILabel alloc] initWithFrame:CGRectMake(46, 0, 230, topBarHeight/numRows)];
                label1.text = [NSString stringWithFormat:@"Patient: %@",pat.patName];
                label1.textAlignment = UITextAlignmentLeft;
                label1.backgroundColor = [UIColor clearColor];
                [pdfOrDocController.view addSubview:label1];
                UILabel* label11 = [[UILabel alloc] initWithFrame:CGRectMake(46, topBarHeight/numRows, 230, topBarHeight/numRows)];
                label11.text = [NSString stringWithFormat:@"City: %@",self.patientCityString];
                label11.textAlignment = UITextAlignmentLeft;
                label11.backgroundColor = [UIColor clearColor];
                [pdfOrDocController.view addSubview:label11];
                NSDateFormatter *df = [[[NSDateFormatter alloc] init] autorelease];
                [df setDateFormat:@"dd-MM-yyyy"];
                NSString* dob = [df stringFromDate:[PharmacyViewController mfDateFromDotNetJSONString:pat.patDOB]];
                UILabel* label2 = [[UILabel alloc] initWithFrame:CGRectMake(46, (2*topBarHeight)/numRows, 230, topBarHeight/numRows)];
                label2.text = [NSString stringWithFormat:@"Age.: %@",[CurrentVisitDetailViewController AgeFromString:dob]];
                label2.textAlignment = UITextAlignmentLeft;
                label2.backgroundColor = [UIColor clearColor];
                [pdfOrDocController.view addSubview:label2];
                UILabel* label3 = [[UILabel alloc] initWithFrame:CGRectMake(46, (3*topBarHeight)/numRows, 230, topBarHeight/numRows)];
                label3.text = [NSString stringWithFormat:@"Mobile No.: %@",lblNumber.text];
                label3.textAlignment = UITextAlignmentLeft;
                label3.backgroundColor = [UIColor clearColor];
                [pdfOrDocController.view addSubview:label3];
                
                UILabel* label4 = [[UILabel alloc] initWithFrame:CGRectMake(524, 0, 230, topBarHeight/numRows)];//doctor name
                label4.text = [NSString stringWithFormat:@"%@",([[DataExchange getDocDisplayData] count]==0?@"":[[DataExchange getDocDisplayData] objectAtIndex:0])];
                label4.textAlignment = UITextAlignmentCenter;
                label4.backgroundColor = [UIColor clearColor];
                [pdfOrDocController.view addSubview:label4];
                UILabel* label5 = [[UILabel alloc] initWithFrame:CGRectMake(524, topBarHeight/numRows, 230, topBarHeight/numRows)];//doctor address
                label5.text = [NSString stringWithFormat:@"%@",([[DataExchange getDocDisplayData] count]==0?@"":[[DataExchange getDocDisplayData] objectAtIndex:1])];
                label5.textAlignment = UITextAlignmentCenter;
                label5.backgroundColor = [UIColor clearColor];
                [pdfOrDocController.view addSubview:label5];
                UILabel* label6 = [[UILabel alloc] initWithFrame:CGRectMake(524, (2*topBarHeight)/numRows, 230, topBarHeight/numRows)];//doctor address2
                label6.text = [NSString stringWithFormat:@"%@",([[DataExchange getDocDisplayData] count]==0?@"":[[DataExchange getDocDisplayData] objectAtIndex:2])];
                label6.textAlignment = UITextAlignmentCenter;
                label6.backgroundColor = [UIColor clearColor];
                [pdfOrDocController.view addSubview:label6];
                UILabel* label7 = [[UILabel alloc] initWithFrame:CGRectMake(524, (3*topBarHeight)/numRows, 230, topBarHeight/numRows)];//doctor mobile
                label7.text = [NSString stringWithFormat:@"%@",([[DataExchange getDocDisplayData] count]==0?@"":[[DataExchange getDocDisplayData] objectAtIndex:3])];
                label7.textAlignment = UITextAlignmentCenter;
                label7.backgroundColor = [UIColor clearColor];
                [pdfOrDocController.view addSubview:label7];
                
                UIView* border = [[UIView alloc] initWithFrame:CGRectMake(0, topBarHeight-3, 800, 3)];
                border.backgroundColor = [UIColor grayColor];
                [pdfOrDocController.view addSubview:border];
                [border release];
                [label1 release];
                [label2 release];
                [label3 release];
                [label4 release];
                [label5 release];
                [label6 release];
                [label7 release];
                
                self.popover = [[UIPopoverController alloc] initWithContentViewController:pdfOrDocController];
                self.popover.popoverContentSize = CGSizeMake(800, 513+topBarHeight);
                self.popover.delegate = self;
                [self.popover presentPopoverFromRect:CGRectMake(0, 0, 20, 20) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            }
            else if([[notesArray objectAtIndex:i] isKindOfClass:[NSURL class]]){
                MPMoviePlayerController *moviePlayerController = [[MPMoviePlayerController alloc] initWithContentURL:(NSURL*)[notesArray objectAtIndex:i]];
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlaybackComplete:) name:MPMoviePlayerPlaybackDidFinishNotification object:moviePlayerController];
                [self.view addSubview:moviePlayerController.view];
                moviePlayerController.useApplicationAudioSession = NO;
                moviePlayerController.fullscreen = YES;
                [moviePlayerController play];
            }
        }
    }
    else{
        proAlertView *message = [[proAlertView alloc] initWithTitle:@"" message:@"No data available for this record" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [message setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
        [message show];
        [message release];
    }
    if (self.activityController) {
        [self.activityController dismissActivity];
        self.activityController = nil;
    }
}

-(BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController{
    
    _GMDocAppDelegate *appdel=(_GMDocAppDelegate*)[[UIApplication sharedApplication]delegate];
    appdel.profileimagevalue = 0;
    return YES;
}

-(void)pdfOrDocEdit{
    [self closePopup];
    shouldReopenPdfPopover = TRUE;
    
    UIGraphicsBeginImageContext(docView.frame.size);
    [docView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage* snapshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    LabOrderEditViewController* controller = [[LabOrderEditViewController alloc] initWithNibName:@"LabOrderEditViewController" bundle:nil];
    controller.userRoleId = [self.res.userRoleID stringValue];
    controller.mrno = self.mrno;
    controller.firstImage = snapshot;
    controller.mParent = self;
    [self presentModalViewController:controller animated:YES];
    [controller release];
}

-(void)closeCurrImagery{
    [self dismissModalViewControllerAnimated:YES];
    if(shouldReopenPdfPopover){
        shouldReopenPdfPopover = FALSE;
        self.popover = [[UIPopoverController alloc] initWithContentViewController:pdfOrDocController];
        self.popover.popoverContentSize = CGSizeMake(800, 513+topBarHeight);
        self.popover.delegate = self;
        [self.popover presentPopoverFromRect:CGRectMake(0, 0, 20, 20) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}

-(void)showHelpView{
    HelpViewController* controller = [[HelpViewController alloc] initWithNibName:@"HelpViewController" bundle:nil];
    self.popover = [[UIPopoverController alloc] initWithContentViewController:controller];
    [self.popover setPopoverContentSize:CGSizeMake(320, 490)];
    [self.popover presentPopoverFromRect:CGRectMake(870, 0, 20, 20) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    [controller release];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    UIImageView* imgvw = (UIImageView*)[scrollView viewWithTag:999];
    return imgvw;
}

- (void)moviePlaybackComplete:(NSNotification *)notification{
    MPMoviePlayerController *moviePlayerController = [notification object];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:moviePlayerController];
    [moviePlayerController.view removeFromSuperview];
}

-(void)showPharmacyOrder{
    int lblHt = 80;
    if(isTemplateNotPrescription){
        prescriptionOrTemplateLbl.text = @"Template";
        isTemplateNotPrescription = FALSE;
    }
    else{
        prescriptionOrTemplateLbl.text = @"Prescription";
    }
    if(currPharmacyOrderArray.count<=2)
        [pharmacyOrderScrollView setFrame:CGRectMake(0,166,660,currPharmacyOrderArray.count*(lblHt+20))];
    else
        [pharmacyOrderScrollView setFrame:CGRectMake(0,166,660,240)];
    [pharmacyOrderScrollView setContentSize:CGSizeMake(660,currPharmacyOrderArray.count*(lblHt+20))];
    for(UIView *v in [pharmacyOrderScrollView subviews])
    {
        [v removeFromSuperview];
    }
    for (int i = 0; i<currPharmacyOrderArray.count; i++) {
        UILabel* label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 10+(lblHt+20)*i, 110, lblHt)];
        label1.text = [(PharmacyOrder*)[currPharmacyOrderArray objectAtIndex:i] Generic];
        label1.textAlignment = UITextAlignmentCenter;
        label1.numberOfLines = 0;
        label1.lineBreakMode = UILineBreakModeWordWrap;
        [pharmacyOrderScrollView addSubview:label1];
        UILabel* label2 = [[UILabel alloc] initWithFrame:CGRectMake(110*1, 10+(lblHt+20)*i, 110, lblHt)];
        label2.text = [(PharmacyOrder*)[currPharmacyOrderArray objectAtIndex:i] brand_name];
        label2.textAlignment = UITextAlignmentCenter;
        label2.numberOfLines = 0;
        label2.lineBreakMode = UILineBreakModeWordWrap;
        [pharmacyOrderScrollView addSubview:label2];
        UILabel* label3 = [[UILabel alloc] initWithFrame:CGRectMake(110*2, 10+(lblHt+20)*i, 110, lblHt)];
        label3.text = [(PharmacyOrder*)[currPharmacyOrderArray objectAtIndex:i] dosage_form];
        label3.textAlignment = UITextAlignmentCenter;
        label3.numberOfLines = 0;
        label3.lineBreakMode = UILineBreakModeWordWrap;
        [pharmacyOrderScrollView addSubview:label3];
        UILabel* label4 = [[UILabel alloc] initWithFrame:CGRectMake(110*3, 10+(lblHt+20)*i, 110, lblHt)];
        label4.text = [(PharmacyOrder*)[currPharmacyOrderArray objectAtIndex:i] dosage];
        label4.textAlignment = UITextAlignmentCenter;
        label4.numberOfLines = 0;
        label4.lineBreakMode = UILineBreakModeWordWrap;
        [pharmacyOrderScrollView addSubview:label4];
        UILabel* label5 = [[UILabel alloc] initWithFrame:CGRectMake(110*4, 10+(lblHt+20)*i, 110, lblHt)];
        label5.text = [(PharmacyOrder*)[currPharmacyOrderArray objectAtIndex:i] instruction];
        label5.textAlignment = UITextAlignmentCenter;
        label5.numberOfLines = 0;
        label5.lineBreakMode = UILineBreakModeWordWrap;
        [pharmacyOrderScrollView addSubview:label5];
        UILabel* label6 = [[UILabel alloc] initWithFrame:CGRectMake(110*5, 10+(lblHt+20)*i, 110, lblHt)];
        label6.text = [NSString stringWithFormat:@"%d %@",[[(PharmacyOrder*)[currPharmacyOrderArray objectAtIndex:i] durationno] integerValue],[(PharmacyOrder*)[currPharmacyOrderArray objectAtIndex:i] durationunits]];
        label6.textAlignment = UITextAlignmentCenter;
        label6.numberOfLines = 0;
        label6.lineBreakMode = UILineBreakModeWordWrap;
        [pharmacyOrderScrollView addSubview:label6];
        [label1 release];
        [label2 release];
        [label3 release];
        [label4 release];
        [label5 release];
        [label6 release];
        UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, (lblHt+20)*(i+1), 660, 2)];
        view.backgroundColor = [UIColor lightGrayColor];
        [pharmacyOrderScrollView addSubview:view];
        [view release];
    }
    labOrderView.hidden = true;
    pharmacyOrderView.hidden = false;
}

-(void)back:(id)sender{
    UITabBarController *tabBar = [self tabBarController];
    [tabBar setSelectedIndex:0];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)logoutUser{
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

-(void)selectLogout:(id)sender{
    self.activityController = [ISActivityOverlayController presentActivityOverViewController:self withLabel:@"Loading..."];
    [self.service getPatientVitalsInvocation:[self.res.userRoleID stringValue] Mrno:self.mrno delegate:self];
    [self.service getPatMedRecordsInvocation:[self.res.userRoleID stringValue] mrNo:self.mrno subTenantId:self.sec.sub_tenant_id delegate:self];
}

-(void) closePopup{
    if(popover)
        if([self.popover isPopoverVisible])
            [self.popover dismissPopoverAnimated:YES];
    [self dismissModalViewControllerAnimated:YES];
}

- (void) labOrderDidSubmit{
    if(popover)
        if([self.popover isPopoverVisible])
            [self.popover dismissPopoverAnimated:YES];
    if (self.activityController) {
        [self.activityController dismissActivity];
        self.activityController = nil;
    }
}

- (IBAction)didOpenLabRecord:(id)sender{
    LabOrderViewController *addController = [[LabOrderViewController alloc] initWithNibName:@"LabOrderViewController" bundle:nil];
    addController.delegate = self;
    addController.mrNo = self.mrno;
    addController.patCity = patientCityString;
    addController.patient = pat;
    addController.patientNumber = lblNumber.text;
    addController.docAddress = [currDocAddress Address1];
    addController.docName = [currLoggedInDoctor u_name];
    addController.docNumber = [currDocContact Mobile];
    addController.userRoleId = [self.res.userRoleID stringValue];
    addController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentModalViewController:addController animated:YES];
    [addController release];
}

- (void)didOpenPharmacyOrder{
    PharmacyViewController *addController = [[PharmacyViewController alloc] initWithNibName:@"PharmacyViewController" bundle:nil];
    addController.delegate = self;
    addController.mrNo = [self.mrno integerValue];
    addController.patient = pat;
    addController.mParentController = self;
    addController.pharmacyReportRecNatureIndex = pharmacyOrderRecNatureId;
    addController.patCity = patientCityString;
    addController.patientNumber = lblNumber.text;
    addController.docAddress = [currDocAddress Address1];
    addController.docName = [currLoggedInDoctor u_name];
    addController.docNumber = [currDocContact Mobile];
    addController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentModalViewController:addController animated:YES];
    [addController release];
}

-(IBAction)viewUserReportOpen:(id)sender{
    NotesViewController *addController = [[NotesViewController alloc] initWithNibName:@"NotesViewController" bundle:nil];
    addController.mrNo = self.mrno;
    addController.patient = pat;
    addController.patCity = patientCityString;
    addController.patientNumber = lblNumber.text;
    addController.docAddress = [currDocAddress Address1];
    addController.docName = [currLoggedInDoctor u_name];
    addController.docNumber = [currDocContact Mobile];
    addController.viewIndex = 0;
    addController.currentRecNatureId = doctorNoteRecNatureId;
    addController.userRoleId = [self.res.userRoleID stringValue];
    addController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentModalViewController:addController animated:YES];
    [addController release];
}

-(IBAction)addMoreComplaintBtnPrsd{
    addComplaintBtn.hidden = false;
    addMoreComplaintBtn.hidden = true;
    labOrderView.hidden = true;
    pharmacyOrderView.hidden = true;
    NotesViewController *addController = [[NotesViewController alloc] initWithNibName:@"NotesViewController" bundle:nil];
    addController.mrNo = self.mrno;
    addController.patCity = patientCityString;
    addController.patient = pat;
    addController.patientNumber = lblNumber.text;
    addController.docAddress = [currDocAddress Address1];
    addController.docName = [currLoggedInDoctor u_name];
    addController.docNumber = [currDocContact Mobile];
    addController.viewIndex = 2;
    addController.currentRecNatureId = complaintsRecNatureId;
    addController.userRoleId = [self.res.userRoleID stringValue];
    addController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentModalViewController:addController animated:YES];
    [addController release];
}

-(IBAction)addHealthCondition:(id)sender{
    UIButton* btn = (UIButton*)sender;
    AddHAViewController* controller = [[AddHAViewController alloc]  initWithNibName:@"AddHAViewController" bundle:nil];
    controller.healthAllergyOrVital = 0;
    controller.delegate = self;
    controller.userRoleId = [self.res.userRoleID stringValue];
    controller.mrNo = self.mrno;
    controller.subTenId = self.sec.sub_tenant_id;
    self.popover = [[UIPopoverController alloc] initWithContentViewController:controller];
    self.popover.popoverContentSize = controller.view.frame.size;
    [self.popover presentPopoverFromRect:btn.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
    [controller release];
}

-(IBAction)addAllergy:(id)sender{
    UIButton* btn = (UIButton*)sender;
    AddHAViewController* controller = [[AddHAViewController alloc]  initWithNibName:@"AddHAViewController" bundle:nil];
    controller.healthAllergyOrVital = 1;
    controller.delegate = self;
    controller.userRoleId = [self.res.userRoleID stringValue];
    controller.mrNo = self.mrno;
    controller.subTenId = self.sec.sub_tenant_id;
    self.popover = [[UIPopoverController alloc] initWithContentViewController:controller];
    self.popover.popoverContentSize = controller.view.frame.size;
    [self.popover presentPopoverFromRect:btn.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
    [controller release];
}

-(IBAction)addVital:(id)sender{
    UIButton* btn = (UIButton*)sender;
    AddHAViewController* controller = [[AddHAViewController alloc]  initWithNibName:@"AddHAViewController" bundle:nil];
    controller.healthAllergyOrVital = 2;
    controller.delegate = self;
    controller.userRoleId = [self.res.userRoleID stringValue];
    controller.mrNo = self.mrno;
    controller.subTenId = self.sec.sub_tenant_id;
    controller.vitalsArray = [[NSMutableArray alloc] initWithArray:vitalsValuesArray];
    self.popover = [[UIPopoverController alloc] initWithContentViewController:controller];
    self.popover.popoverContentSize = controller.view.frame.size;
    [self.popover presentPopoverFromRect:btn.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
    [controller release];
}

#pragma mark -
#pragma mark Table view data source

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(tableView == healthConditionTblView)
        return healthArray.count;
    else if(tableView == allergiesTblView)
        return allergiesArray.count;
    else if(tableView == vitalsTblView){
        if([currentVitalsSortString isEqualToString:@"--Select All--"])
            return vitalsArray.count;
        else{
            int count=0;
            for (int i=0; i<vitalsArray.count; i++)
                if([[(PatVital*)[vitalsArray objectAtIndex:i] VitalName] isEqualToString:currentVitalsSortString])
                    count++;
            return count;
        }
    }
    else if(tableView == natureTblView){
        if(complaintLabOrPharmacyIndex>0){
            int count=0;
            for (int i=0; i<patMedRecordsArray.count; i++)
                if([[NSString stringWithFormat:@"%@",[(PatMedRecords*)[self.patMedRecordsArray objectAtIndex:i] RecNatureId]] isEqualToString:[NSString stringWithFormat:@"%d",complaintLabOrPharmacyIndex]])
                    count++;
            return count;
        }
        else
            return self.patMedRecordsArray.count;
    }
    else//severities table
        return severitiesArray.count;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDateFormatter *df = [[[NSDateFormatter alloc] init] autorelease];
    [df setDateFormat:@"dd-MM-yyyy"];
    if(tableView == natureTblView){
        static NSString* sRowCell = @"RowCell";
        cell = (NatureTblCell*)[self.natureTblView dequeueReusableCellWithIdentifier:sRowCell];
        if (Nil == cell) {
            cell = [NatureTblCell createTextRowWithOwner:self];
        }
        if(complaintLabOrPharmacyIndex>0){
            int count=0;
            int i=0;
            for (; i<patMedRecordsArray.count; i++){
                if([[NSString stringWithFormat:@"%@",[(PatMedRecords*)[self.patMedRecordsArray objectAtIndex:i] RecNatureId]] isEqualToString:[NSString stringWithFormat:@"%d",complaintLabOrPharmacyIndex]])
                    count++;
                if(count==indexPath.row+1)
                    break;
            }
            cell.lblAppTime.text = [NSString stringWithFormat:@"%@",[df stringFromDate:[self.dateDtls objectAtIndex:i]]];
            if([doctorNamesArray count]>indexPath.row)
                cell.lblName.text = [doctorNamesArray objectAtIndex:i];
            else
                cell.lblName.text = @"Doctor Name";
            cell.imgView.image = [UIImage imageNamed:[self.imageDtls objectAtIndex:i]];
            return cell;
        }
        else{
            cell.lblAppTime.text = [NSString stringWithFormat:@"%@",[df stringFromDate:[self.dateDtls objectAtIndex:(indexPath.row)]]];
            if([doctorNamesArray count]>indexPath.row)
                cell.lblName.text = [doctorNamesArray objectAtIndex:(indexPath.row)];
            else
                cell.lblName.text = @"Doctor Name";
            cell.imgView.image = [UIImage imageNamed:[self.imageDtls objectAtIndex:(indexPath.row)]];
            return cell;
        }
    }
    else if(tableView == allergiesTblView){
        static NSString* sRowCell1 = @"RowCell1";
        cell1 = (PatientDetailTblCell*)[self.allergiesTblView dequeueReusableCellWithIdentifier:sRowCell1];
        if (Nil == cell1) {
            cell1 = [PatientDetailTblCell createTextRowWithOwner:self];
        }
        cell1.lblName.text = [(PatAllergy*)[allergiesArray objectAtIndex:indexPath.row] AllergyName];
        cell1.lblType.text = [(PatAllergy*)[allergiesArray objectAtIndex:indexPath.row] AllergyTypeProperty];
        cell1.lblExistsFrom.text = [self editExistsFrom:[(PatAllergy*)[allergiesArray objectAtIndex:indexPath.row] Existsfrom]];
        return cell1;
    }
    else if(tableView == healthConditionTblView){
        static NSString* sRowCell2 = @"RowCell2";
        cell1 = (PatientDetailTblCell*)[self.healthConditionTblView dequeueReusableCellWithIdentifier:sRowCell2];
        if (Nil == cell1) {
            cell1 = [PatientDetailTblCell createTextRowWithOwner:self];
        }
        cell1.lblName.text = [(PatHealth*)[healthArray objectAtIndex:indexPath.row] HCondition];
        cell1.lblType.text = [(PatHealth*)[healthArray objectAtIndex:indexPath.row] HConTypeProperty];
        cell1.lblExistsFrom.text = [self editExistsFrom:[(PatHealth*)[healthArray objectAtIndex:indexPath.row] Existsfrom]];
        return cell1;
    }
    else if(tableView == vitalsTblView){
        static NSString* sRowCell3 = @"RowCell3";
        cell1 = (PatientDetailTblCell*)[self.vitalsTblView dequeueReusableCellWithIdentifier:sRowCell3];
        if (Nil == cell1) {
            cell1 = [PatientDetailTblCell createTextRowWithOwner:self];
        }
        int index=0;
        int count=0;
        if([currentVitalsSortString isEqualToString:@"--Select All--"])
            index = indexPath.row;
        else
            for (; index<vitalsArray.count; index++) {
                if([[(PatVital*)[vitalsArray objectAtIndex:index] VitalName] isEqualToString:currentVitalsSortString])
                    count++;
                if(count==indexPath.row+1)
                    break;
            }
        cell1.lblName.text = [df stringFromDate:[CurrentVisitDetailViewController mfDateFromDotNetJSONString:[(PatVital*)[vitalsArray objectAtIndex:index] Date_]]];
        cell1.lblType.text = [(PatVital*)[vitalsArray objectAtIndex:index] VitalName];
        cell1.lblExistsFrom.text = [NSString stringWithFormat:@"%.2f",[[(PatVital*)[vitalsArray objectAtIndex:index] Reading] doubleValue]];
        return cell1;
    }
    else{//severities table
        static NSString* sRowCell3 = @"RowCell3";
        UITableViewCell* cellS = [severitiesTblView dequeueReusableCellWithIdentifier:sRowCell3];
        if (Nil == cellS) {
            cellS = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:sRowCell3] autorelease];
        }
        cellS.textLabel.text = [(Severity*)[severitiesArray objectAtIndex:indexPath.row] SeverityProperty];
        return cellS;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if(tableView == healthConditionTblView){ }
    else if(tableView == allergiesTblView){ }
    else if(tableView == vitalsTblView){
        PostVitalCommentsVC* controller = [[[PostVitalCommentsVC alloc] initWithNibName:@"PostVitalCommentsVC" bundle:nil] autorelease];
        int index=0;
        int count=0;
        if([currentVitalsSortString isEqualToString:@"--Select All--"])
            index = indexPath.row;
        else
            for (; index<vitalsArray.count; index++) {
                if([[(PatVital*)[vitalsArray objectAtIndex:index] VitalName] isEqualToString:currentVitalsSortString])
                    count++;
                if(count==indexPath.row+1)
                    break;
            }
        controller.vitalsId = [[(PatVital*)[vitalsArray objectAtIndex:index] PatVitalId] integerValue];
        controller.delegate = self;
        self.popover = [[UIPopoverController alloc] initWithContentViewController:controller];
        [self.popover setPopoverContentSize:CGSizeMake(400, 400)];
        [self.popover presentPopoverFromRect:vitalsBtn.frame
                                      inView:self.view
                    permittedArrowDirections:UIPopoverArrowDirectionDown
                                    animated:YES];
    }
    else if(tableView == natureTblView){
        NSInteger recNatID=0;
        if(sortingOfArraysIsNotDone)
            recNatID = [[(PatMedRecords*)[self.patMedRecordsArray objectAtIndex:(indexPath.row)] RecNatureId] integerValue];
        else
            recNatID = complaintLabOrPharmacyIndex;
        
        if(recNatID==complaintsRecNatureId){//complaints
            complaintLabOrPharmacyIndex=complaintsRecNatureId;
            addComplaintBtn.hidden = false;
            addMoreComplaintBtn.hidden = true;
            labOrderView.hidden = true;
            pharmacyOrderView.hidden = true;
            int count=0;
            int i=0;
            if(sortingOfArraysIsNotDone){
                i=indexPath.row;
            }
            else
                for (; i<patMedRecordsArray.count; i++){
                    if([[(PatMedRecords*)[self.patMedRecordsArray objectAtIndex:i] RecNatureId] integerValue]==complaintsRecNatureId)
                        count++;
                    if(count==indexPath.row+1)
                        break;
                }
            sortingOfArraysIsNotDone = false;
            self.activityController = [ISActivityOverlayController presentActivityOverViewController:self withLabel:@"Loading..."];
            NSDate *dt = [self.dateDtls objectAtIndex:i];
            NSCalendar *cal = [NSCalendar currentCalendar];
            NSDate *date = [NSDate date];
            NSDateComponents *comps = [cal components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:date];
            NSDateComponents* comp1 = [cal components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:dt];
            if([[[(PatMedRecords*)[self.patMedRecordsArray objectAtIndex:i] EntryTypeId] stringValue] isEqualToString:@"1"]){
                [self.service getPatientComplaintsInvocation:[self.res.userRoleID stringValue] RecordId:[(PatMedRecords*)[self.patMedRecordsArray objectAtIndex:i] RecordId] delegate:self];
            }else{
                [self.service getUserInvocation:[self.res.userRoleID stringValue] Async:true delegate:self];
                [self.service getNotesInvocation:[self.res.userRoleID stringValue] RecordId:[(PatMedRecords*)[self.patMedRecordsArray objectAtIndex:i] RecordId] delegate:self];
            }
            if(comp1.day==comps.day && comp1.year==comps.year && comp1.month==comps.month){
                [saveBtn.titleLabel setText:@"Edit"];
                saveBtn.hidden = false;
                cancelBtn.hidden = false;
                editCompliance = true;
            }
            else{
                saveBtn.hidden = true;
                cancelBtn.hidden = true;
            }
        }
        else if(recNatID==labReportRecNatureId){//lab report
            complaintLabOrPharmacyIndex=labReportRecNatureId;
            int count=0;
            int i=0;
            if(sortingOfArraysIsNotDone){
                i=indexPath.row;
            }
            else
                for (; i<patMedRecordsArray.count; i++){
                    if([[(PatMedRecords*)[self.patMedRecordsArray objectAtIndex:i] RecNatureId] integerValue]==labReportRecNatureId)
                        count++;
                    if(count==indexPath.row+1)
                        break;
                }
            sortingOfArraysIsNotDone = false;
            self.activityController = [ISActivityOverlayController presentActivityOverViewController:self withLabel:@"Fetching..."];
            [self.service getLabReportInvocation:[self.res.userRoleID stringValue] RecordId:[(PatMedRecords*)[self.patMedRecordsArray objectAtIndex:i] RecordId] delegate:self];
        }
        else if(recNatID==labOrderRecNatureId){//lab order
            complaintLabOrPharmacyIndex=labOrderRecNatureId;
            int count=0;
            int i=0;
            labOrderView.hidden = false;
            pharmacyOrderView.hidden = true;
            if(sortingOfArraysIsNotDone){
                i=indexPath.row;
            }
            else
                for (; i<patMedRecordsArray.count; i++){
                    if([[(PatMedRecords*)[self.patMedRecordsArray objectAtIndex:i] RecNatureId] integerValue]==labOrderRecNatureId)
                        count++;
                    if(count==indexPath.row+1)
                        break;
                }
            sortingOfArraysIsNotDone = false;
            self.activityController = [ISActivityOverlayController presentActivityOverViewController:self withLabel:@"Loading..."];
            [self.service getLabOrPharmacyInvocation:[self.res.userRoleID stringValue] RecordId:[(PatMedRecords*)[self.patMedRecordsArray objectAtIndex:i] RecordId] LabOrPharmacy:true delegate:self];
        }
        else if(recNatID==pharmacyOrderRecNatureId){//pharmacy
            complaintLabOrPharmacyIndex = pharmacyOrderRecNatureId;
            int count=0;
            int i=0;
            labOrderView.hidden = true;
            if(sortingOfArraysIsNotDone){
                i=indexPath.row;
            }
            else
                for (; i<patMedRecordsArray.count; i++){
                    if([[(PatMedRecords*)[self.patMedRecordsArray objectAtIndex:i] RecNatureId] integerValue]==pharmacyOrderRecNatureId)
                        count++;
                    if(count==indexPath.row+1)
                        break;
                }
            sortingOfArraysIsNotDone = false;
            self.activityController = [ISActivityOverlayController presentActivityOverViewController:self withLabel:@"Loading..."];
            if([[[(PatMedRecords*)[self.patMedRecordsArray objectAtIndex:i] EntryTypeId] stringValue] isEqualToString:@"1"]){
                [self.service getLabOrPharmacyInvocation:[self.res.userRoleID stringValue] RecordId:[(PatMedRecords*)[self.patMedRecordsArray objectAtIndex:i] RecordId] LabOrPharmacy:false delegate:self];
                pharmacyOrderView.hidden = false;
            }
            else{
                [self.service getUserInvocation:[self.res.userRoleID stringValue] Async:true delegate:self];
                [self.service getNotesInvocation:[self.res.userRoleID stringValue] RecordId:[(PatMedRecords*)[self.patMedRecordsArray objectAtIndex:i] RecordId] delegate:self];
            }
        }
        else if(recNatID==doctorNoteRecNatureId){//notes
            complaintLabOrPharmacyIndex = doctorNoteRecNatureId;
            int count=0;
            int i=0;
            labOrderView.hidden = true;
            pharmacyOrderView.hidden = true;
            if(sortingOfArraysIsNotDone){
                i=indexPath.row;
            }
            else
                for (; i<patMedRecordsArray.count; i++){
                    if([[(PatMedRecords*)[self.patMedRecordsArray objectAtIndex:i] RecNatureId] integerValue]==doctorNoteRecNatureId)
                        count++;
                    if(count==indexPath.row+1)
                        break;
                }
            sortingOfArraysIsNotDone = false;
            self.activityController = [ISActivityOverlayController presentActivityOverViewController:self withLabel:@"Loading..."];
            [self.service getUserInvocation:[self.res.userRoleID stringValue] Async:true delegate:self];
            [self.service getNotesInvocation:[self.res.userRoleID stringValue] RecordId:[(PatMedRecords*)[self.patMedRecordsArray objectAtIndex:i] RecordId] delegate:self];
        }
        else if(recNatID==doctorCommentsRecNatureId){//doctor comments
            complaintLabOrPharmacyIndex = doctorCommentsRecNatureId;
            int count=0;
            int i=0;
            labOrderView.hidden = true;
            pharmacyOrderView.hidden = true;
            if(sortingOfArraysIsNotDone){
                i=indexPath.row;
            }
            else
                for (; i<patMedRecordsArray.count; i++){
                    if([[(PatMedRecords*)[self.patMedRecordsArray objectAtIndex:i] RecNatureId] integerValue]==doctorCommentsRecNatureId)
                        count++;
                    if(count==indexPath.row+1)
                        break;
                }
            sortingOfArraysIsNotDone = false;
            self.activityController = [ISActivityOverlayController presentActivityOverViewController:self withLabel:@"Loading..."];
            [self.service getUserInvocation:[self.res.userRoleID stringValue] Async:true delegate:self];
            [self.service getNotesInvocation:[self.res.userRoleID stringValue] RecordId:[(PatMedRecords*)[self.patMedRecordsArray objectAtIndex:i] RecordId] delegate:self];
        }
        else if(recNatID==currentVisitImageRecNatureId){//current visit image
            complaintLabOrPharmacyIndex = currentVisitImageRecNatureId;
            int count=0;
            int i=0;
            labOrderView.hidden = true;
            pharmacyOrderView.hidden = true;
            if(sortingOfArraysIsNotDone){
                i=indexPath.row;
            }
            else
                for (; i<patMedRecordsArray.count; i++){
                    if([[(PatMedRecords*)[self.patMedRecordsArray objectAtIndex:i] RecNatureId] integerValue]==currentVisitImageRecNatureId)
                        count++;
                    if(count==indexPath.row+1)
                        break;
                }
            sortingOfArraysIsNotDone = false;
            isCurrentVisitImage = TRUE;
            self.activityController = [ISActivityOverlayController presentActivityOverViewController:self withLabel:@"Loading..."];
            [self.service getNotesInvocation:[self.res.userRoleID stringValue] RecordId:[(PatMedRecords*)[self.patMedRecordsArray objectAtIndex:i] RecordId] delegate:self];
        }
        else if(recNatID==referralsRecNatureId){//referrals
            complaintLabOrPharmacyIndex = referralsRecNatureId;
            int count=0;
            int i=0;
            labOrderView.hidden = true;
            pharmacyOrderView.hidden = true;
            if(sortingOfArraysIsNotDone){
                i=indexPath.row;
            }
            else
                for (; i<patMedRecordsArray.count; i++){
                    if([[(PatMedRecords*)[self.patMedRecordsArray objectAtIndex:i] RecNatureId] integerValue]==referralsRecNatureId)
                        count++;
                    if(count==indexPath.row+1)
                        break;
                }
            sortingOfArraysIsNotDone = false;
            self.activityController = [ISActivityOverlayController presentActivityOverViewController:self withLabel:@"Loading..."];
            [self.service getUserInvocation:[self.res.userRoleID stringValue] Async:true delegate:self];
            [self.service getNotesInvocation:[self.res.userRoleID stringValue] RecordId:[(PatMedRecords*)[self.patMedRecordsArray objectAtIndex:i] RecordId] delegate:self];
        }
        else if(recNatID==templateRecNatureId){//templates
            complaintLabOrPharmacyIndex = templateRecNatureId;
            int count=0;
            int i=0;
            labOrderView.hidden = true;
            pharmacyOrderView.hidden = true;
            if(sortingOfArraysIsNotDone){
                i=indexPath.row;
            }
            else
                for (; i<patMedRecordsArray.count; i++){
                    if([[(PatMedRecords*)[self.patMedRecordsArray objectAtIndex:i] RecNatureId] integerValue]==templateRecNatureId)
                        count++;
                    if(count==indexPath.row+1)
                        break;
                }
            isTemplateNotPrescription = TRUE;
            sortingOfArraysIsNotDone = false;
            self.activityController = [ISActivityOverlayController presentActivityOverViewController:self withLabel:@"Loading..."];
            if([[[(PatMedRecords*)[self.patMedRecordsArray objectAtIndex:i] EntryTypeId] stringValue] isEqualToString:@"1"]){
                [self.service getLabOrPharmacyInvocation:[self.res.userRoleID stringValue] RecordId:[(PatMedRecords*)[self.patMedRecordsArray objectAtIndex:i] RecordId] LabOrPharmacy:false delegate:self];
                pharmacyOrderView.hidden = false;
            }
            else{
                [self.service getUserInvocation:[self.res.userRoleID stringValue] Async:true delegate:self];
                [self.service getNotesInvocation:[self.res.userRoleID stringValue] RecordId:[(PatMedRecords*)[self.patMedRecordsArray objectAtIndex:i] RecordId] delegate:self];
            }
        }
        else if(recNatID==planRecNatureId){//plan
            complaintLabOrPharmacyIndex = planRecNatureId;
            int count=0;
            int i=0;
            labOrderView.hidden = true;
            pharmacyOrderView.hidden = true;
            if(sortingOfArraysIsNotDone){
                i=indexPath.row;
            }
            else
                for (; i<patMedRecordsArray.count; i++){
                    if([[(PatMedRecords*)[self.patMedRecordsArray objectAtIndex:i] RecNatureId] integerValue]==planRecNatureId)
                        count++;
                    if(count==indexPath.row+1)
                        break;
                }
            sortingOfArraysIsNotDone = false;
            self.activityController = [ISActivityOverlayController presentActivityOverViewController:self withLabel:@"Loading..."];
            [self.service getUserInvocation:[self.res.userRoleID stringValue] Async:true delegate:self];
            [self.service getNotesInvocation:[self.res.userRoleID stringValue] RecordId:[(PatMedRecords*)[self.patMedRecordsArray objectAtIndex:i] RecordId] delegate:self];
        }
        [natureTblView deselectRowAtIndexPath:indexPath animated:YES];
        [natureTblView reloadData];
    }
    else{/*severities table*/
        severitiesTblView.hidden = true;
        severityBtn.titleLabel.text = [(Severity*)[severitiesArray objectAtIndex:indexPath.row] SeverityProperty];
        currentSeverity = indexPath.row;
    }
}

#pragma mark others

-(void)closePostVitalsPopup{
    if([self.popover isPopoverVisible]){
        [self.popover dismissPopoverAnimated:NO];
    }
}

-(void) addRecord:(PatMedRecords*)record{
    [doctorNamesArray insertObject:[(UserDetail*)[[DataExchange getUserResult] objectAtIndex:0] u_name] atIndex:0];
    [self.dateDtls insertObject:[NSDate date] atIndex:0];
    [self.patMedRecordsArray insertObject:record atIndex:0];
    if([[record RecNatureId] integerValue]==complaintsRecNatureId)
        [self.imageDtls insertObject:@"report.png" atIndex:0];
    else if([[record RecNatureId] integerValue]==labReportRecNatureId)
        [self.imageDtls insertObject:@"laboratory.png" atIndex:0];
    else if([[record RecNatureId] integerValue]==pharmacyOrderRecNatureId)
        [self.imageDtls insertObject:@"pripcrition.png" atIndex:0];
    else if([[record RecNatureId] integerValue]==labOrderRecNatureId)
        [self.imageDtls insertObject:@"lab.png" atIndex:0];
    else if([[record RecNatureId] integerValue]==doctorNoteRecNatureId)
        [self.imageDtls insertObject:@"notes.png" atIndex:0];
    else if([[record RecNatureId] integerValue]==currentVisitImageRecNatureId)
        [self.imageDtls insertObject:@"current-visit.png" atIndex:0];
    else if([[record RecNatureId] integerValue]==doctorCommentsRecNatureId)
        [self.imageDtls insertObject:@"doctor_comment.png" atIndex:0];
    else if([[record RecNatureId] integerValue]==referralsRecNatureId)
        [self.imageDtls insertObject:@"doctor_referrals.png" atIndex:0];
    else if([[record RecNatureId] integerValue]==templateRecNatureId)
        [self.imageDtls insertObject:@"doctor_template.png" atIndex:0];
    else if([[record RecNatureId] integerValue]==planRecNatureId)
        [self.imageDtls insertObject:@"plan.png" atIndex:0];
    else
        [self.imageDtls insertObject:@"cross.png" atIndex:0];
    [natureTblView reloadData];
}

-(IBAction)addComplaintBtnPrsd{
    [self cancelComplianceEntry];
    complaintLabOrPharmacyIndex = 0;
    sortingOfArraysIsNotDone = true;
    editCompliance = false;
    saveBtn.hidden = false;
    cancelBtn.hidden = false;
    addComplaintBtn.hidden = true;
    addMoreComplaintBtn.hidden = false;
    [saveBtn.titleLabel setText:@"Save"];
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

-(IBAction)closePharmacyOrderView{
    pharmacyOrderView.hidden = true;
}

-(IBAction)sortLabOrder{
    [self didOpenLabRecord:daysBtn];//doesn't matter which button's reference is passed
}

-(IBAction)sortPharmacyOrder{
    [self didOpenPharmacyOrder];
}

-(IBAction)showDrugView{
    NotesViewController *addController = [[NotesViewController alloc] initWithNibName:@"NotesViewController" bundle:nil];
    addController.mrNo = self.mrno;
    addController.patient = pat;
    addController.patCity = patientCityString;
    addController.patientNumber = lblNumber.text;
    addController.docAddress = [currDocAddress Address1];
    addController.docName = [currLoggedInDoctor u_name];
    addController.docNumber = [currDocContact Mobile];
    addController.viewIndex = 1;
    addController.currentRecNatureId = planRecNatureId;
    addController.userRoleId = [self.res.userRoleID stringValue];
    addController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentModalViewController:addController animated:YES];
    [addController release];
}

-(IBAction)showCurrentVisitsView{
    if(!self.activityController)
        self.activityController = [ISActivityOverlayController presentActivityOverViewController:self withLabel:@"Opening..."];
    [NSThread detachNewThreadSelector:@selector(removeNonImageEntries) toTarget:self withObject:nil];
}

-(void)removeNonImageEntries{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSMutableArray* list = [[NSMutableArray alloc] init];
    NSMutableArray* dateDtlsTemp = [[NSMutableArray alloc] init];
    NSMutableArray* imageDtlsTemp = [[NSMutableArray alloc] init];
    NSMutableArray* doctorNamesArrayTemp = [[NSMutableArray alloc] init];
    for (int i=0; i<self.patMedRecordsArray.count; i++) {
        if(([[(PatMedRecords*)[self.patMedRecordsArray objectAtIndex:i] RecNatureId] integerValue]==currentVisitImageRecNatureId && [[(PatMedRecords*)[self.patMedRecordsArray objectAtIndex:i] EntryTypeId] integerValue]==7) || [[(PatMedRecords*)[self.patMedRecordsArray objectAtIndex:i] RecNatureId] integerValue]==labReportRecNatureId){
            NSString *response = @"";
            if([[(PatMedRecords*)[self.patMedRecordsArray objectAtIndex:i] RecNatureId] integerValue]==labReportRecNatureId){
                NSString *urlString = [NSString stringWithFormat:@"http://%@GetLabReport?UserRoleID=%@&RecordId=%@",[DataExchange getbaseUrl],[DataExchange getUserRoleId],[(PatMedRecords*)[self.patMedRecordsArray objectAtIndex:i] RecordId]];
                // setting up the request object now
                NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
                [request setURL:[NSURL URLWithString:urlString]];
                [request setHTTPMethod:@"GET"];
                NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
                response= [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding];
            }
            if(response.length>0)
                if(!([response rangeOfString:@".jpg"].location!=NSNotFound || [response rangeOfString:@".png"].location!=NSNotFound))
                    continue;
            [list addObject:[self.patMedRecordsArray objectAtIndex:i]];
            [dateDtlsTemp addObject:[self.dateDtls objectAtIndex:i]];
            [imageDtlsTemp addObject:[self.imageDtls objectAtIndex:i]];
            [doctorNamesArrayTemp addObject:[self.doctorNamesArray objectAtIndex:i]];
        }
    }
    NSMutableArray* arrayOfObjects = [[NSMutableArray alloc] initWithObjects:list,dateDtlsTemp,imageDtlsTemp,doctorNamesArrayTemp, nil];
    [pool release];
    [self performSelectorOnMainThread:@selector(openCurrentVisitsModalView:) withObject:arrayOfObjects waitUntilDone:NO];
}

-(void)openCurrentVisitsModalView:(NSMutableArray*)arrObjects{
    DocCurrVisitViewController* addController = [[DocCurrVisitViewController alloc] initWithNibName:@"DocCurrVisitViewController" bundle:nil];
    addController.listOfRecords = [arrObjects objectAtIndex:0];
    addController.mParentController = self;
    addController.dateDtls = [arrObjects objectAtIndex:1];
    addController.doctorNamesArray = [arrObjects objectAtIndex:3];
    addController.currVisitRecNatureIndex = currentVisitImageRecNatureId;
    addController.imageDtls = [arrObjects objectAtIndex:2];
    addController.mrNo = self.mrno;
    addController.patient = pat;
    addController.patCity = patientCityString;
    addController.patientNumber = lblNumber.text;
    addController.docAddress = [currDocAddress Address1];
    addController.docName = [currLoggedInDoctor u_name];
    addController.docNumber = [currDocContact Mobile];
    addController.userRoleId = [self.res.userRoleID stringValue];
    if (self.activityController) {
        [self.activityController dismissActivity];
        self.activityController = nil;
    }
    [self presentModalViewController:addController animated:YES];
    [addController release];
}

-(IBAction)showAllElementsOfNatureTable{
    complaintLabOrPharmacyIndex = 0;
    sortingOfArraysIsNotDone = true;
    [natureTblView reloadData];
}

-(IBAction)severitiesBtnPrssd{
    severitiesTblView.hidden = false;
}

-(IBAction)addUserImageFromLibrary:(id)sender{
    profileOptionsAlert = [[proAlertView alloc] initWithTitle:@"" message:@"Change Profile Pic!" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
    [profileOptionsAlert setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
    [profileOptionsAlert addButtonWithTitle:@"Take Photo"];
    [profileOptionsAlert addButtonWithTitle:@"Choose Existing"];
    [profileOptionsAlert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    self.imagePicker = [[[UIImagePickerController alloc] init] autorelease];
	if(alertView==profileOptionsAlert){
        if(buttonIndex == 1){
            self.imagePicker = [[[UIImagePickerController alloc] init] autorelease];
            self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            self.imagePicker.mediaTypes =[[NSArray alloc] initWithObjects:(NSString*)kUTTypeImage, nil];
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
            [self.popover presentPopoverFromRect:CGRectMake(0.0, 0.0, 160, 160)
                                          inView:self.view
                        permittedArrowDirections:UIPopoverArrowDirectionRight
                                        animated:YES];
            self.popover.delegate=self;
            
            //   [self.popover presentPopoverFromRect:[self.profileImage bounds] inView:self.profileImage permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }
    }else if(alertView==labOrderOptionsAlert && buttonIndex==1){
        labOrderImgView.layer.borderWidth = 0;
        labOrderTopLbl.frame = CGRectMake(142, 21, 118, 40);
        labOrderBottomLbl.hidden = false;
        drawImage.image = nil;
        labOrderExpanded = FALSE;
        [labOrderView setBackgroundColor:[UIColor whiteColor]];
        addLabOrderButton.hidden = FALSE;
        [UIView beginAnimations:nil context:NULL];
        [labOrderView setFrame:CGRectMake(283, 164, 409, 477)];
        [labOrderImgView setFrame:CGRectMake(43, 77, 306, 370)];
        [UIView commitAnimations];
    }
    else if(alertView==saveLabReportChangesAlert && buttonIndex==1){
        self.activityController = [ISActivityOverlayController presentActivityOverViewController:self withLabel:@"Uploading Image..."];
        CGSize newSize = CGSizeMake(944, 500);
        UIGraphicsBeginImageContext(newSize);
        [[self imageWithColor:[UIColor whiteColor]] drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
        [labOrderImgView.image drawInRect:CGRectMake((newSize.width-(labOrderImgView.image.size.width*newSize.height)/labOrderImgView.image.size.height)/2,0,(labOrderImgView.image.size.width*newSize.height)/labOrderImgView.image.size.height ,newSize.height)];
        [drawImage.image drawInRect:CGRectMake(0,0,newSize.width,newSize.height) blendMode:kCGBlendModeNormal alpha:1.0];
        self.finalImageToBeSaved = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [NSThread detachNewThreadSelector:@selector(PostUploadImage:) toTarget:self withObject:UIImageJPEGRepresentation(self.finalImageToBeSaved,1.0)];
    }
    else if(alertView==compareImagesAlert){
        CompareImagesViewController* controller = [[CompareImagesViewController alloc] initWithNibName:@"CompareImagesViewController" bundle:nil];
        switch (buttonIndex) {
            case 1:
                controller.firstImage = previousNotesImageClicked;
                controller.secondImage = labOrderImgView.image;
                [self presentModalViewController:controller animated:YES];
                break;
            case 0:
                if(alertView.tag==-99){// notes case. The lab report case is handled in the invocation itself
                    UIViewController* controller = [[UIViewController alloc] init];
                    UIImage* temp = labOrderImgView.image;
                    UIImageView* imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, temp.size.width, temp.size.height)];
                    imgView.image = labOrderImgView.image;
                    [controller.view setBackgroundColor:[UIColor whiteColor]];
                    [controller.view addSubview:imgView];
                    self.popover = [[UIPopoverController alloc] initWithContentViewController:controller];
                    self.popover.popoverContentSize = imgView.frame.size;
                    [self.popover presentPopoverFromRect:CGRectMake(0, 0, 20, 20) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
                    [imgView release];
                    [controller release];
                }
                break;
            default:
                break;
        }
    }
    else if(alertView==sendSmsAlert){
        Appointment *appoint = [self.sec.appointments objectAtIndex:currentSmsIndex];
        NSString* dataToPost;
        NSURL* myUrl;
        NSMutableURLRequest *request;
        if(buttonIndex==1){
            dataToPost = [NSString stringWithFormat:@"{\"AppId\":%d,\"ScheduleID\":%@,\"UserRoleId\":\"%@\",\"DoctorName\":\"%@\"}",appoint.AppId.integerValue,self.sec.schedule_id,[DataExchange getUserRoleId],[(UserDetail*)[[DataExchange getUserResult] objectAtIndex:0] u_name]];
            myUrl = [[[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://%@Posttoken",[DataExchange getbaseUrl]]] autorelease];
            request = [[[NSMutableURLRequest alloc] init] autorelease];
            [request setURL:myUrl];
            [request setHTTPMethod:@"POST"];
            [request setAllHTTPHeaderFields:[[[NSDictionary alloc] initWithObjects:[[[NSArray alloc] initWithObjects:@"application/json",@"utf-8",[DataExchange getDomainUrl],[NSString stringWithFormat:@"%d",dataToPost.length], nil] autorelease] forKeys:[[[NSArray alloc] initWithObjects:@"Content-Type",@"charset",@"Host",@"Content-Length", nil] autorelease]]autorelease]];
            [request setHTTPBody:[NSData dataWithBytes:[dataToPost UTF8String] length:[dataToPost lengthOfBytesUsingEncoding:NSUTF8StringEncoding]]];
            [[[NSURLConnection alloc] initWithRequest:request delegate:nil] autorelease];
            
            dataToPost = [NSString stringWithFormat:@"{\"Hospitalname\":\"%@\",\"MobileNumber\":\"%@\",\"DoctorName\":\"%@\",\"email\":\"%@\"}",[DataExchange getHospitalName],self.previousPatMob,[(UserDetail*)[[DataExchange getUserResult] objectAtIndex:0] u_name],self.previousPatEmail];
            NSLog(@"%@",dataToPost);
            myUrl = [[[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://%@ThanksMessage",[DataExchange getbaseUrl]]] autorelease];
            request = [[[NSMutableURLRequest alloc] init] autorelease];
            [request setURL:myUrl];
            [request setHTTPMethod:@"POST"];
            [request setAllHTTPHeaderFields:[[[NSDictionary alloc] initWithObjects:[[[NSArray alloc] initWithObjects:@"application/json",@"utf-8",[DataExchange getDomainUrl],[NSString stringWithFormat:@"%d",dataToPost.length], nil] autorelease] forKeys:[[[NSArray alloc] initWithObjects:@"Content-Type",@"charset",@"Host",@"Content-Length", nil] autorelease]]autorelease]];
            [request setHTTPBody:[NSData dataWithBytes:[dataToPost UTF8String] length:[dataToPost lengthOfBytesUsingEncoding:NSUTF8StringEncoding]]];
            [[[NSURLConnection alloc] initWithRequest:request delegate:nil] autorelease];
        }
        currentSmsIndex=currentIndex;
    }
    else if(alertView==sendThanksAlert && buttonIndex==1){
        NSString* dataToPost = [NSString stringWithFormat:@"{\"Hospitalname\":\"%@\",\"MobileNumber\":\"%@\",\"DoctorName\":\"%@\",\"email\":\"%@\"}",[DataExchange getHospitalName],self.previousPatMob,[(UserDetail*)[[DataExchange getUserResult] objectAtIndex:0] u_name],self.previousPatEmail];
        NSLog(@"%@",dataToPost);
        NSURL* myUrl = [[[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://%@ThanksMessage",[DataExchange getbaseUrl]]] autorelease];
        NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
        [request setURL:myUrl];
        [request setHTTPMethod:@"POST"];
        [request setAllHTTPHeaderFields:[[[NSDictionary alloc] initWithObjects:[[[NSArray alloc] initWithObjects:@"application/json",@"utf-8",[DataExchange getDomainUrl],[NSString stringWithFormat:@"%d",dataToPost.length], nil] autorelease] forKeys:[[[NSArray alloc] initWithObjects:@"Content-Type",@"charset",@"Host",@"Content-Length", nil]autorelease]]autorelease]];
        [request setHTTPBody:[NSData dataWithBytes:[dataToPost UTF8String] length:[dataToPost lengthOfBytesUsingEncoding:NSUTF8StringEncoding]]];
        [[[NSURLConnection alloc] initWithRequest:request delegate:nil] autorelease];
    }
}

#pragma mark
#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)info {
    [self didTakePicture:image];
	[self didFinishWithCamera];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    self.activityController = [ISActivityOverlayController presentActivityOverViewController:self withLabel:@"Uploading profile pic..."];
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if([mediaType isEqualToString:@"public.image"]){
        UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
        [self didTakePicture:image];
        [self didFinishWithCamera];
        _GMDocAppDelegate *appdel=(_GMDocAppDelegate*)[[UIApplication sharedApplication]delegate];
        appdel.profileimagevalue =0;
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

-(IBAction)takeVideo{
    self.imagePicker = [[[UIImagePickerController alloc] init] autorelease];
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    self.imagePicker.mediaTypes =[[NSArray alloc] initWithObjects:(NSString*)kUTTypeImage, nil];
    self.imagePicker.delegate = self;
    self.imagePicker.allowsEditing = NO;
    [self presentModalViewController:self.imagePicker animated:YES];
}

- (void)didTakePicture:(UIImage *)picture{
    [self.capturedImages removeAllObjects];
    [self.capturedImages addObject:picture];
}

- (void)didFinishWithCamera {
    if([self.popover isPopoverVisible]){
        [self.popover dismissPopoverAnimated:NO];
        [self.popover release];
    }
    [self dismissModalViewControllerAnimated:YES];
    [NSThread detachNewThreadSelector:@selector(setImageView) toTarget:self withObject:nil];
}

-(UIImage*) resizeImage:(UIImage*) image size:(CGSize) size {
	if (image.size.width != size.width || image.size.height != size.height) {
		UIGraphicsBeginImageContext(size);
		CGRect imageRect = CGRectMake(0.0, 0.0, size.width, size.height);
		[image drawInRect:imageRect];
		image = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
	}
	return image;
}

#pragma mark -
#pragma mark remaining

- (void) setImageView {
	if ([self.capturedImages count] > 0) {
		UIImage* last = [self.capturedImages objectAtIndex:([self.capturedImages count] - 1)];
        if(labOrderExpanded){
            //            [labOrderImgView setImage:last];
        }
        else{
            [DataExchange setPatImage:UIImageJPEGRepresentation(last,1.0)];
            postImageCase = true;
            NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
            NSString *urlString = [NSString stringWithFormat:@"http://%@FileUploadImage",[DataExchange getbaseUrl]];
            //set up the request body
            NSMutableData *body = [[[NSMutableData alloc] init] autorelease];
            NSString* firstStr = @"{\"fileStream\":\"";
            NSString* lastStr = @"\"}";
            // add image data
            [body appendData:[firstStr dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[Base64 encode:UIImageJPEGRepresentation(last,1.0)] dataUsingEncoding:NSUTF8StringEncoding]];
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
	}
}

-(void)SuccessToPostImage:(NSString*)response{
    NSString* dataToPost = [NSString stringWithFormat:@"{\"PatDemoid\":%d,\"UserRoleID\":%@,\"ImagePathId\":%@}",[self.pat.patDemoID integerValue],[DataExchange getUserRoleId],response];
    NSURL* myUrl = [[[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://%@UpdatePatientImage",[DataExchange getbaseUrl]]] autorelease];
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
    [request setURL:myUrl];
    [request setHTTPMethod:@"POST"];
    [request setAllHTTPHeaderFields:[[[NSDictionary alloc] initWithObjects:[[[NSArray alloc] initWithObjects:@"application/json",@"utf-8",[DataExchange getDomainUrl],[NSString stringWithFormat:@"%d",dataToPost.length], nil] autorelease] forKeys:[[[NSArray alloc] initWithObjects:@"Content-Type",@"charset",@"Host",@"Content-Length", nil]autorelease]]autorelease]];
    [request setHTTPBody:[NSData dataWithBytes:[dataToPost UTF8String] length:[dataToPost lengthOfBytesUsingEncoding:NSUTF8StringEncoding]]];
    NSURLConnection *theConnection=[[[NSURLConnection alloc] initWithRequest:request delegate:self] autorelease];
    if (!theConnection) {
        proAlertView *alert = [[proAlertView alloc] initWithTitle:@"No Internet Connection" message:@"Please Try Again Later" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
        [alert setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
        [alert show];
        [alert release];
    }
    [profileImage setBackgroundImage:[self resizeImage:[self.capturedImages objectAtIndex:([self.capturedImages count] - 1)] size:profileImage.frame.size] forState:UIControlStateNormal];
    if (self.activityController) {
        [self.activityController dismissActivity];
        self.activityController = nil;
    }
}

-(IBAction)selectColor1{
    currentColor = 0;
}

-(IBAction)selectColor2{
    currentColor = 1;
}

-(IBAction)selectColor3{
    currentColor = 2;
}

-(IBAction)selectColor4{
    currentColor = 3;
}

-(IBAction)selectErase{
    currentColor = 4;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSArray *allTouches = [touches allObjects];
    int count = [allTouches count];
	if(count==1&&labOrderExpanded){
        UITouch *touch = [touches anyObject];
        lastPoint = [touch locationInView:labOrderImgView];
        secondLastPoint = lastPoint;
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    NSArray *allTouches = [touches allObjects];
    int count = [allTouches count];
	if(count==1 && labOrderExpanded){
        UITouch *touch = [touches anyObject];
        CGPoint currentPoint = [touch locationInView:labOrderImgView];
        UIGraphicsBeginImageContext(drawImage.frame.size);
        [drawImage.image drawInRect:CGRectMake(0, 0, drawImage.frame.size.width, drawImage.frame.size.height)];
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 2.0*(labOrderImgView.frame.size.height/350));
        switch (currentColor) {
            case 0:
                CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 1.0, 0.0, 0.0, 1.0);
                break;
            case 3:
                CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 0.5, 0.2, 0.3, 1.0);
                break;
            case 1:
                CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 0.0, 1.0, 0.0, 1.0);
                break;
            case 2:
                CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 0.0, 0.0, 1.0, 1.0);
                break;
            case 4:
                CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 6.0*(labOrderImgView.frame.size.height/350));
                CGContextSetBlendMode(UIGraphicsGetCurrentContext(),kCGBlendModeClear);
                CGContextSetStrokeColorWithColor(UIGraphicsGetCurrentContext(),[UIColor clearColor].CGColor);
                break;
            default:
                break;
        }
        CGPoint mid1 = CGPointMake((lastPoint.x+secondLastPoint.x)/2, (lastPoint.y+secondLastPoint.y)/2);
        CGPoint mid2 = CGPointMake((lastPoint.x+currentPoint.x)/2, (lastPoint.y+currentPoint.y)/2);
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), mid1.x, mid1.y);
        CGContextAddQuadCurveToPoint(UIGraphicsGetCurrentContext(),lastPoint.x, lastPoint.y,mid2.x,mid2.y);
        CGContextStrokePath(UIGraphicsGetCurrentContext());
        drawImage.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        secondLastPoint = lastPoint;
        lastPoint = currentPoint;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    self.severitiesTblView.hidden = true;
    UITouch *theTouch = [touches anyObject];
    if (theTouch.tapCount == 1) {
        
    }else if (theTouch.tapCount == 2) {
        UITouch *touch1 = [[touches allObjects] objectAtIndex:0];
        if([self arePoints:[touch1 locationInView:labOrderImgView] And:[touch1 locationInView:labOrderImgView] InsideViewFrame:labOrderImgView.frame]){
            LabOrderEditViewController* controller = [[LabOrderEditViewController alloc] initWithNibName:@"LabOrderEditViewController" bundle:nil];
            controller.userRoleId = [self.res.userRoleID stringValue];
            controller.mrno = self.mrno;
            controller.mParent = self;
            controller.firstImage = labOrderImgView.image;
            [self presentModalViewController:controller animated:YES];
            [controller release];
        }
    }
}

-(bool)arePoints:(CGPoint)pointA And:(CGPoint)pointB InsideViewFrame:(CGRect)frame{
    if(CGRectContainsPoint(frame, pointA))
        if (CGRectContainsPoint(frame, pointB))
            return YES;
    return NO;
}

-(IBAction)cancelChanges{
    if(drawImage.image != nil){
        labOrderOptionsAlert = [[proAlertView alloc] initWithTitle:@"Delete?" message:@"Proceed?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"YES",nil];
        [labOrderOptionsAlert setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
        [labOrderOptionsAlert show];
    }
    else{
        labOrderTopLbl.frame = CGRectMake(142, 21, 118, 40);
        labOrderBottomLbl.hidden = false;
        labOrderImgView.layer.borderWidth = 0;
        labOrderExpanded = false;
        [labOrderView setBackgroundColor:[UIColor whiteColor]];
        addLabOrderButton.hidden = FALSE;
        [UIView beginAnimations:nil context:NULL];
        [labOrderView setFrame:CGRectMake(283, 164, 409, 477)];
        [labOrderImgView setFrame:CGRectMake(43, 77, 306, 370)];
        [UIView commitAnimations];
    }
}

-(IBAction)saveChanges{
    saveLabReportChangesAlert = [[proAlertView alloc] initWithTitle:nil message:@"Are you sure you want to submit changes?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes",nil];
    [saveLabReportChangesAlert setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
    [saveLabReportChangesAlert show];
}

-(void)PostUploadImage:(NSData*)_imgData{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSString *urlString = [NSString stringWithFormat:@"http://%@UploadOrderImage",[DataExchange getbaseUrl]];
    //set up the request body
    NSMutableData *body = [[[NSMutableData alloc] init] autorelease];
    NSString* firstStr = @"{\"fileStream\":\"";
    NSString* lastStr = @"\"}";
    // add image data
    [body appendData:[firstStr dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[Base64 encode:_imgData] dataUsingEncoding:NSUTF8StringEncoding]];
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
        [self performSelectorOnMainThread:@selector(SuccessToLoadTable:) withObject:response waitUntilDone:NO];
}

-(void)SuccessToLoadTable:(NSString*)response{
    NSString* dataToPost = [NSString stringWithFormat:@"{\"Mrno\":%@,\"UserRoleID\":%@,\"filename\":%@}",self.mrno,[self.res.userRoleID stringValue],response];
    NSURL* myUrl = [[[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://%@PostDoctorComments_file",[DataExchange getbaseUrl]]] autorelease];
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
    [request setURL:myUrl];
    [request setHTTPMethod:@"POST"];
    [request setAllHTTPHeaderFields:[[[NSDictionary alloc] initWithObjects:[[[NSArray alloc] initWithObjects:@"application/json",@"utf-8",[DataExchange getDomainUrl],[NSString stringWithFormat:@"%d",dataToPost.length], nil] autorelease] forKeys:[[[NSArray alloc] initWithObjects:@"Content-Type",@"charset",@"Host",@"Content-Length", nil]autorelease]]autorelease]];
    [request setHTTPBody:[NSData dataWithBytes:[dataToPost UTF8String] length:[dataToPost lengthOfBytesUsingEncoding:NSUTF8StringEncoding]]];
    NSURLConnection *theConnection=[[[NSURLConnection alloc] initWithRequest:request delegate:self] autorelease];
    if (!theConnection) {
        proAlertView *alert = [[proAlertView alloc] initWithTitle:@"No Internet Connection"
                                                          message:@"Please Try Again Later" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
        [alert show];
        [alert release];
    }
    if (self.activityController) {
        [self.activityController dismissActivity];
        self.activityController = nil;
    }
}

-(IBAction)submitComplianceEntry{
    
    int countEmpty=0;
    for (int i =0; i<6; i++) {
        switch (i) {
            case 0:
                if(![chiefComplaintTxtVw.text isEqualToString:@""])
                    countEmpty++;
                break;
            case 1:
                if(![associatedSymptomsTxtVw.text isEqualToString:@""])
                    countEmpty++;
                break;
            case 2:
                if(![onsetTxtVw.text isEqualToString:@""])
                    countEmpty++;
                break;
            case 3:
                if(![durationTxtVw.text isEqualToString:@""])
                    countEmpty++;
                break;
            case 4:
                if(![otherSymptomsTxtVw.text isEqualToString:@""])
                    countEmpty++;
                break;
            case 5:
                if(![pastEpisodesTxtVw.text isEqualToString:@""])
                    countEmpty++;
                break;
            default:
                break;
        }
    }
    if(countEmpty!=6){
        proAlertView *alert = [[proAlertView alloc] initWithTitle:@"Fields Missing"
                                                          message:@"Please fill all fields to continue" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
        [alert show];
        [alert release];
    }
    else if(currentSeverity==-1){
        proAlertView *alert = [[proAlertView alloc] initWithTitle:@"Field Missing"
                                                          message:@"Please select severity" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
        [alert show];
        [alert release];
    }
    else{
        if (!self.activityController && editCompliance) {
            self.activityController = [ISActivityOverlayController presentActivityOverViewController:self withLabel:@"Submitting Changed Complaint..."];
        }
        else if(!self.activityController && !editCompliance){
            self.activityController = [ISActivityOverlayController presentActivityOverViewController:self withLabel:@"Submitting Current Complaint..."];
        }
        
        NSString* chiefComplaintTxt = [NSString stringWithFormat:@"\",\"CheifComp\":\"%@",chiefComplaintTxtVw.text];
        NSString* onsetTxt = [NSString stringWithFormat:@"\",\"Onset\":\"%@",onsetTxtVw.text];
        NSString* time;
        switch (hrsDaysMonYrsIndex) {
            case 1:
                time = @"Hrs";
                break;
            case 2:
                time = @"Days";
                break;
            case 3:
                time = @"Mnths";
                break;
            case 4:
                time = @"Yrs";
                break;
            default:
                break;
        }
        NSString* durationTxt = [NSString stringWithFormat:@"\",\"Duration\":\"%@%@",durationTxtVw.text,time];
        NSString* otherSymptomsTxt = [NSString stringWithFormat:@"\",\"Othersymptoms\":\"%@",otherSymptomsTxtVw.text];
        NSString* associatedSymptomsTxt = [NSString stringWithFormat:@"{\"Compliants\":{\"Associatedsymptoms\":\"%@",associatedSymptomsTxtVw.text];
        NSString* pastEpisodesTxt = [NSString stringWithFormat:@"\",\"Episodesinpast\":\"%@",pastEpisodesTxtVw.text];
        NSString* regressionTxt = [NSString stringWithFormat:@"\",\"Progression\":\"%@\",\"Regression\":\"%@\"",(progressionNotRegression?@"true":@"false"),(progressionNotRegression?@"false":@"true")];
        NSString* severityTxt = [NSString stringWithFormat:@",\"SeverityId\":%d",currentSeverity+1];
        NSString* finalString;
        if(editCompliance)
            finalString = [NSString stringWithFormat:@",\"CompliantId\":%d},\"Mrno\":\"%@\",\"UserRoleID\":%@}",currentComplaintId,self.mrno,[self.res.userRoleID stringValue]];
        else
            finalString = [NSString stringWithFormat:@"},\"Mrno\":\"%@\",\"UserRoleID\":%@}",self.mrno,[self.res.userRoleID stringValue]];
        NSString* dataToPost = [associatedSymptomsTxt stringByAppendingString:chiefComplaintTxt];
        dataToPost = [dataToPost stringByAppendingString:durationTxt];
        dataToPost = [dataToPost stringByAppendingString:pastEpisodesTxt];
        dataToPost = [dataToPost stringByAppendingString:onsetTxt];
        dataToPost = [dataToPost stringByAppendingString:otherSymptomsTxt];
        dataToPost = [dataToPost stringByAppendingString:regressionTxt];
        dataToPost = [dataToPost stringByAppendingString:severityTxt];
        dataToPost = [dataToPost stringByAppendingString:finalString];
        
        NSURL* myUrl;
        if(editCompliance)//url to post edited compliance
            myUrl = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://%@PostCompliantsEdit",[DataExchange getbaseUrl]]];
        else//to post new compliance
            myUrl = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://%@PostCompliants",[DataExchange getbaseUrl]]];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:myUrl];
        [request setHTTPMethod:@"POST"];
        [request setAllHTTPHeaderFields:[[NSDictionary alloc] initWithObjects:[[NSArray alloc] initWithObjects:@"application/json",@"utf-8",[DataExchange getDomainUrl],@"81", nil] forKeys:[[NSArray alloc] initWithObjects:@"Content-Type",@"charset",@"Host",@"Content-Length", nil]]];
        [request setHTTPBody:[NSData dataWithBytes:[dataToPost UTF8String] length:[dataToPost lengthOfBytesUsingEncoding:NSUTF8StringEncoding]]];
        NSURLConnection *theConnection=[[[NSURLConnection alloc] initWithRequest:request delegate:self] autorelease];
        if (!theConnection) {
            proAlertView *alert = [[proAlertView alloc] initWithTitle:@"No Internet Connection" message:@"Please Try Again Later" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
            [alert show];
            [alert release];
        }
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    if(postImageCase){
        postImageCase = false;
    }
    else{
        [self.service getPatMedRecordsInvocation:[self.res.userRoleID stringValue] mrNo:self.mrno subTenantId:self.sec.sub_tenant_id delegate:self];
        [self cancelComplianceEntry];
        drawImage.image = nil;
        [self cancelChanges];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    NSString *newStr = [[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    NSLog(@"%@",newStr);
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	proAlertView *alert = [[proAlertView alloc] initWithTitle:@"Something Went Wrong"
                                                      message:@"Please Try Again" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
    [alert show];
	[alert release];
	return;
}


-(IBAction)cancelComplianceEntry{
    chiefComplaintTxtVw.text = @"";
    onsetTxtVw.text = @"";
    durationTxtVw.text = @"";
    severityBtn.titleLabel.text = @"Select Severity";
    otherSymptomsTxtVw.text = @"";
    associatedSymptomsTxtVw.text = @"";
    pastEpisodesTxtVw.text = @"";
    [daysBtn setImage:[self imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
    [hrsBtn setImage:[self imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
    [progressionBtn setImage:[self imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
    [regressionBtn setImage:[self imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
}

-(IBAction)daysBtnPrsd{
    [daysBtn setImage:[self imageWithColor:[UIColor grayColor]] forState:UIControlStateNormal];
    [hrsBtn setImage:[self imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
    [yrsBtn setImage:[self imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
    [monthsBtn setImage:[self imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
    hrsDaysMonYrsIndex = 2;
}

-(IBAction)hrsBtnPrsd{
    [hrsBtn setImage:[self imageWithColor:[UIColor grayColor]] forState:UIControlStateNormal];
    [daysBtn setImage:[self imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
    [yrsBtn setImage:[self imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
    [monthsBtn setImage:[self imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
    hrsDaysMonYrsIndex = 1;
}

-(IBAction)monthsBtnPrsd{
    [hrsBtn setImage:[self imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
    [daysBtn setImage:[self imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
    [yrsBtn setImage:[self imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
    [monthsBtn setImage:[self imageWithColor:[UIColor grayColor]] forState:UIControlStateNormal];
    hrsDaysMonYrsIndex = 3;
}

-(IBAction)yrsBtnPrsd{
    [hrsBtn setImage:[self imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
    [daysBtn setImage:[self imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
    [yrsBtn setImage:[self imageWithColor:[UIColor grayColor]] forState:UIControlStateNormal];
    [monthsBtn setImage:[self imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
    hrsDaysMonYrsIndex = 4;
}

-(IBAction)progressionBtnPrsd{
    [progressionBtn setImage:[self imageWithColor:[UIColor grayColor]] forState:UIControlStateNormal];
    [regressionBtn setImage:[self imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
    progressionNotRegression = true;
}

-(IBAction)regressionBtnPrsd{
    [regressionBtn setImage:[self imageWithColor:[UIColor grayColor]] forState:UIControlStateNormal];
    [progressionBtn setImage:[self imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
    progressionNotRegression = false;
}

- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 100.0f, 100.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

-(void) setPatientDetailsLabels:(Patdemographics*)patD{
    lblAge.text = patD.patDOB;
    lblName.text = patD.patName;
}

-(IBAction)nextPatient{
    if(self.sec.appointments.count==1){
        proAlertView *alert = [[proAlertView alloc] initWithTitle:nil message:@"No more patients available" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
        [alert show];
        [alert release];
        nextPatientBtn.hidden = TRUE;
    }
    else{
        if(currentIndex == [self.sec.appointments count]-1){
            nextPatientBtn.hidden = TRUE;
            sendThanksAlert = [[proAlertView alloc] initWithTitle:@"Send SMS" message:@"Do you wish to broadcast token numbers?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes",nil];
            [sendThanksAlert setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
            [sendThanksAlert show];
            
            return;
        }
        else{
            currentIndex++;
        }
        
        Appointment *appoint = [self.sec.appointments objectAtIndex:currentIndex];
        self.pat = [appoint.patdemographics objectAtIndex:0];
        Booking *bk = [appoint.bookings objectAtIndex:0];
        self.mrno = [bk.mrno stringValue];
        currentCount = patMedRecordsArray.count;
        if(bk){
            [self setupPatientData];
            //[self checkOnlyPatient];
            sendSmsAlert = [[proAlertView alloc] initWithTitle:@"Send SMS" message:@"Do you wish to broadcast token numbers?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes",nil];
            [sendSmsAlert setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
            [sendSmsAlert show];
        }
        else {
            [self nextPatient];
        }
    }
}

-(void)checkOnlyPatient {
    int count = 0;
    for (int i=currentIndex; i<self.sec.appointments.count; i++) {
        Appointment *appoint = [self.sec.appointments objectAtIndex:i];
        Patdemographics* patD = [appoint.patdemographics objectAtIndex:0];
        if(patD){
            count++;
        }
        if (patD==self.pat) {
            currentSmsIndex=i;
            currentIndex=i;
        }
    }
}

- (void)closePatSelPopover{
    
    if(popover)
        if ([self.popover isPopoverVisible]) {
            [self.popover dismissPopoverAnimated:YES];
        }
}

-(IBAction)searchPatient{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)addPatient{
    STPNAddPatientViewController* controller = [[STPNAddPatientViewController alloc] initWithNibName:@"STPNAddPatientViewController" bundle:nil];
    controller.areaId = [DataExchange getAreaID];
    controller.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentModalViewController:controller animated:YES];
    controller.view.superview.frame = CGRectMake(242, 44, 540, 680);
    [controller release];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    BOOL isNumeric=FALSE;
	if ([string length] == 0)
	{
		isNumeric=TRUE;
	}
	else if(textField == durationTxtVw || textField==onsetTxtVw)
	{
		if ( [string compare:[NSString stringWithFormat:@"%d",0]]==0 || [string compare:[NSString stringWithFormat:@"%d",1]]==0
			|| [string compare:[NSString stringWithFormat:@"%d",2]]==0 || [string compare:[NSString stringWithFormat:@"%d",3]]==0
			|| [string compare:[NSString stringWithFormat:@"%d",4]]==0 || [string compare:[NSString stringWithFormat:@"%d",5]]==0
			|| [string compare:[NSString stringWithFormat:@"%d",6]]==0 || [string compare:[NSString stringWithFormat:@"%d",7]]==0
			|| [string compare:[NSString stringWithFormat:@"%d",8]]==0 || [string compare:[NSString stringWithFormat:@"%d",9]]==0)
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
	}
    else if(textField==pastEpisodesTxtVw){
        isNumeric = TRUE;
    }
	return isNumeric;
}

-(void) optionSelected:(NSString*)text{
    currentVitalsSortString = text;
    if([text isEqualToString:@"--Select All--"]){
        isVitalsSorted = false;
    }
    else{
        isVitalsSorted = true;
        int count=0, i=0;
        for (; i<vitalsArray.count; i++) {
            if([[(PatVital*)[vitalsArray objectAtIndex:i] VitalName] rangeOfString:currentVitalsSortString].location!=NSNotFound)
                count++;
        }
        currentVitalsCount = count;
    }
    
    
    [self.popover dismissPopoverAnimated:YES];
    [vitalsTblView reloadData];
}

-(IBAction)unitsBtnClicked{
    if(isVitalsSorted)
        [self showGraphInPopup];
    else{
        proAlertView *alert = [[proAlertView alloc] initWithTitle:nil message:@"Please select a vital before proceeding" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
        [alert show];
        [alert release];
    }
}

-(IBAction)vitalsBtnClicked{
    CustomPopoverViewController* controller = [[CustomPopoverViewController alloc] initWithNibName:@"CustomPopoverViewController" bundle:nil];
    controller.listOfOptions = vitalsNamesArray;
    controller.delegate = self;
    controller.type = 0;
    self.popover = [[UIPopoverController alloc] initWithContentViewController:controller];
    [controller release];
    [self.popover setPopoverContentSize:CGSizeMake(320, 20 + 50*(vitalsNamesArray.count>5?5:vitalsNamesArray.count))];
    [self.popover presentPopoverFromRect:CGRectMake(827, 441, 20, 20) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
}

-(void)showGraphInPopup{
    UIViewController* controller = [[UIViewController alloc] init];
    graph = nil;
    graph = [[CPTXYGraph alloc] initWithFrame: CGRectMake(0, 0, 900, 700)];
    CPTTheme *theme = [CPTTheme themeNamed:kCPTPlainWhiteTheme];
    [graph applyTheme:theme];
    
    CPTGraphHostingView *hostingView = [[CPTGraphHostingView alloc] initWithFrame:graph.frame];
    hostingView.hostedGraph = graph;
    graph.paddingLeft = 20.0;
    graph.paddingBottom = 20.0;
    
    NSInteger maxValue = 0;
    NSInteger minValue = [[(PatVital*)[vitalsArray objectAtIndex:0] Reading] integerValue];
    for (int i=0; i<vitalsArray.count; i++) {
        if (maxValue<[[(PatVital*)[vitalsArray objectAtIndex:i] Reading] integerValue]) {
            maxValue = [[(PatVital*)[vitalsArray objectAtIndex:i] Reading] integerValue];
        }
        if (minValue>[[(PatVital*)[vitalsArray objectAtIndex:i] Reading] integerValue]) {
            minValue = [[(PatVital*)[vitalsArray objectAtIndex:i] Reading] integerValue];
        }
    }
    if (maxValue==minValue) {
        minValue=10;
    }
    NSInteger yIntervalLength = 5;
    if (maxValue-minValue>50) {
        yIntervalLength = 10;
    }
    else if(maxValue-minValue<5)
        yIntervalLength = 1;
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)graph.defaultPlotSpace;
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(-1)
                                                    length:CPTDecimalFromFloat(currentVitalsCount+2)];
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(minValue - 20)
                                                    length:CPTDecimalFromFloat(maxValue*1.2)];
    
    CPTMutableLineStyle *lineStyle = [CPTMutableLineStyle lineStyle];
    lineStyle.lineColor = [CPTColor blackColor];
    lineStyle.lineWidth = 2.0f;
    
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)graph.axisSet;
    axisSet.xAxis.axisLineStyle	= lineStyle;
	axisSet.xAxis.majorTickLineStyle = lineStyle;
	axisSet.xAxis.minorTickLineStyle = lineStyle;
	axisSet.xAxis.majorIntervalLength = CPTDecimalFromString(@"5");
    axisSet.xAxis.majorTickLength = 7.0f;
    axisSet.xAxis.orthogonalCoordinateDecimal = CPTDecimalFromString([NSString stringWithFormat:@"%d",minValue - 2]);
	axisSet.xAxis.minorTicksPerInterval = 0;
	axisSet.xAxis.labelRotation = 0;
    axisSet.xAxis.labelingPolicy = CPTAxisLabelingPolicyNone;
    NSDateFormatter *df = [[[NSDateFormatter alloc] init] autorelease];
    [df setDateFormat:@"dd-MM-yyyy"];
    NSMutableArray *xAxisLabels = [[NSMutableArray alloc] init];
	for (NSInteger i = 0; i < vitalsArray.count; i++)
        if([[(PatVital*)[vitalsArray objectAtIndex:i] VitalName] isEqualToString:currentVitalsSortString])
            [xAxisLabels addObject:[df stringFromDate:[CurrentVisitDetailViewController mfDateFromDotNetJSONString:[(PatVital*)[vitalsArray objectAtIndex:i] Date_]]]];
    NSUInteger labelLocation = 0;
    NSMutableArray *customLabels = [NSMutableArray arrayWithCapacity:[xAxisLabels count]+1];
    for (NSInteger i = 0; i < xAxisLabels.count; i++) {
        CPTAxisLabel *newLabel = [[CPTAxisLabel alloc] initWithText: [xAxisLabels objectAtIndex:labelLocation++] textStyle:axisSet.xAxis.labelTextStyle];
        newLabel.tickLocation = [[NSNumber numberWithInt:i+1] decimalValue];
        newLabel.offset = axisSet.xAxis.labelOffset + axisSet.xAxis.majorTickLength;
        newLabel.rotation = 0;//M_PI/4;
        [customLabels addObject:newLabel];
        [newLabel release];
    }
    axisSet.xAxis.title = @"Date";
    axisSet.xAxis.axisLabels =  [NSSet setWithArray:customLabels];
    
    switch (yIntervalLength) {
        case 1:
            axisSet.yAxis.majorIntervalLength = CPTDecimalFromString(@"5");
            break;
        case 5:
            axisSet.yAxis.majorIntervalLength = CPTDecimalFromString(@"5");
            break;
        case 10:
            axisSet.yAxis.majorIntervalLength = CPTDecimalFromString(@"10");
            break;
        default:
            break;
    }
    axisSet.yAxis.labelingPolicy=CPTAxisLabelingPolicyAutomatic;
    axisSet.yAxis.minorTicksPerInterval = 0;
    axisSet.yAxis.majorTickLineStyle = lineStyle;
    axisSet.yAxis.minorTickLineStyle = lineStyle;
    axisSet.yAxis.axisLineStyle = lineStyle;
    axisSet.yAxis.minorTickLength = 5.0f;
    axisSet.yAxis.majorTickLength = 7.0f;
    axisSet.yAxis.labelOffset = 15.0f;
    axisSet.yAxis.title = @"Units";
    
    CPTScatterPlot *xSquaredPlot = [[[CPTScatterPlot alloc] initWithFrame:graph.bounds] autorelease];
    xSquaredPlot.identifier = @"X Squared Plot";
    CPTMutableLineStyle *plotLineStyle = [[xSquaredPlot.dataLineStyle mutableCopy] autorelease];
    plotLineStyle.lineWidth = 1.0f;
    plotLineStyle.lineColor = [CPTColor orangeColor];
    xSquaredPlot.dataLineStyle = plotLineStyle;
    xSquaredPlot.dataSource = self;
    
    CPTColor *areaColor = [CPTColor colorWithComponentRed:0.8 green:0.8 blue:0.8 alpha:0.0];
    CPTGradient *areaGradient = [CPTGradient gradientWithBeginningColor:areaColor endingColor:[CPTColor clearColor]];
    areaGradient.angle = -90.0f;
    CPTFill *areaGradientFill = [CPTFill fillWithGradient:areaGradient];
    xSquaredPlot.areaFill = areaGradientFill;
    xSquaredPlot.areaBaseValue = CPTDecimalFromString(@"1.75");
    
    CPTPlotSymbol *greenCirclePlotSymbol = [CPTPlotSymbol ellipsePlotSymbol];
    greenCirclePlotSymbol.fill = [CPTFill fillWithColor:[CPTColor redColor]];
    greenCirclePlotSymbol.size = CGSizeMake(10.0, 10.0);
    xSquaredPlot.plotSymbol = greenCirclePlotSymbol;
    [graph addPlot:xSquaredPlot];
    
    [controller.view setBackgroundColor:[UIColor whiteColor]];
    [controller.view addSubview:hostingView];
    self.popover = [[UIPopoverController alloc] initWithContentViewController:controller];
    self.popover.popoverContentSize = graph.frame.size;
    [self.popover presentPopoverFromRect:CGRectMake(905, 442, 110, 35) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
    [controller release];
    [hostingView release];
}

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot{
    return currentVitalsCount;
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index{
    double val = index;
    if(fieldEnum == CPTScatterPlotFieldX){
        return [NSNumber numberWithDouble:val+1];
    }
    else{
        int count=0, i=0;
        for (; i<vitalsArray.count; i++) {
            if([[(PatVital*)[vitalsArray objectAtIndex:i] VitalName] isEqualToString:currentVitalsSortString])
                count++;
            if(count==index+1)
                break;
        }
        return [NSNumber numberWithInteger:[[(PatVital*)[vitalsArray objectAtIndex:i] Reading] integerValue]];
    }
}

-(IBAction)openReferralView{
    ReferralViewController* addController = [[ReferralViewController alloc] initWithNibName:@"ReferralViewController" bundle:nil];
    addController.mCurrentVisitController = self;
    addController.userRoleId = [self.res.userRoleID stringValue];
    addController.subTenId = sec.sub_tenant_id;
    addController.patient = pat;
    addController.patCity = patientCityString;
    addController.mrNo = self.mrno;
    addController.patient = pat;
    addController.patientNumber = lblNumber.text;
    addController.docAddress = [currDocAddress Address1];
    addController.docName = [currLoggedInDoctor u_name];
    addController.docNumber = [currDocContact Mobile];
    [self.navigationController presentModalViewController:addController animated:YES];
    [addController release];
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

-(NSString*)editExistsFrom:(NSString*)existsFrom{
    NSDate* existsDate;
    NSArray* componentArr = [existsFrom componentsSeparatedByString:@"/"];
    NSInteger existsDays = [(NSString*)[componentArr objectAtIndex:0] integerValue];
    NSInteger existsMonth=1;
    NSInteger existsYears = [(NSString*)[componentArr objectAtIndex:2] integerValue];
    if([[componentArr objectAtIndex:1] caseInsensitiveCompare:@"jan"] == NSOrderedSame)
        existsMonth = 1;
    else if([[componentArr objectAtIndex:1] caseInsensitiveCompare:@"feb"] == NSOrderedSame)
        existsMonth = 2;
    else if([[componentArr objectAtIndex:1] caseInsensitiveCompare:@"mar"] == NSOrderedSame)
        existsMonth = 3;
    else if([[componentArr objectAtIndex:1] caseInsensitiveCompare:@"apr"] == NSOrderedSame)
        existsMonth = 4;
    else if([[componentArr objectAtIndex:1] caseInsensitiveCompare:@"may"] == NSOrderedSame)
        existsMonth = 5;
    else if([[componentArr objectAtIndex:1] caseInsensitiveCompare:@"jun"] == NSOrderedSame)
        existsMonth = 6;
    else if([[componentArr objectAtIndex:1] caseInsensitiveCompare:@"jul"] == NSOrderedSame)
        existsMonth = 7;
    else if([[componentArr objectAtIndex:1] caseInsensitiveCompare:@"aug"] == NSOrderedSame)
        existsMonth = 8;
    else if([[componentArr objectAtIndex:1] caseInsensitiveCompare:@"sep"] == NSOrderedSame)
        existsMonth = 9;
    else if([[componentArr objectAtIndex:1] caseInsensitiveCompare:@"oct"] == NSOrderedSame)
        existsMonth = 10;
    else if([[componentArr objectAtIndex:1] caseInsensitiveCompare:@"nov"] == NSOrderedSame)
        existsMonth = 11;
    else if([[componentArr objectAtIndex:1] caseInsensitiveCompare:@"dec"] == NSOrderedSame)
        existsMonth = 12;
    
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
    NSString* result = (diffInYears==0?@"":[NSString stringWithFormat:@"%d Years, ",diffInYears]);
    result = [result stringByAppendingString:(diffInMonths==0?@"":[NSString stringWithFormat:@"%d Months, ",diffInMonths])];
    result = [result stringByAppendingString:(diffInDays==0?@"":[NSString stringWithFormat:@"%d days",diffInDays])];
    if(result.length==0)
        result = @"Today";
    return result;
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

- (BOOL)shouldAutorotate
{
    return UIInterfaceOrientationMaskLandscape;
}

@end
