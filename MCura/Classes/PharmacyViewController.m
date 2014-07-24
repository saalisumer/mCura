//
//  PharmacyViewController.m
//  mCura
//
//  Created by Aakash Chaudhary on 02/04/12.
//  Copyright (c) 2012 aakash272@gmail.com. All rights reserved.
//

#import "PharmacyViewController.h"
#import "Utils.h"
#import "ISActivityOverlayController.h"
#import "_GMDocService.h"
#import "_GMDocAppDelegate.h"
#import "ImageCache.h"
#import "DataExchange.h"
#import "Schedule.h"
#import "Dosage.h"
#import "DosageFrm.h"
#import "Instruction.h"
#import "Pharmacy.h"
#import "Template.h"
#import <QuartzCore/QuartzCore.h>
#import <AVFoundation/AVFoundation.h>
#include <CoreMedia/CMBase.h>
#include <CoreMedia/CMTime.h>
#include <CoreFoundation/CoreFoundation.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import "Base64.h"
#import "DrugViewController.h"
#import "mCuraSqlite.h"
#import "PrescriptionDataRow.h"
#import "PriceObject.h"
#define min(X,Y) (X<Y?X:Y)
static int Gen_Brand=0;
@interface PharmacyViewController (private)<GetDosageInvocationDelegate, GetGenericInvocationDelegate,
GetFollowUpInvocationDelegate, GetDosageFrmInvocationDelegate, GetPharmacyInvocationDelegate, GetInstructionInvocationDelegate,GetBrandInvocationDelegate,GetTemplateInvocationDelegate,GetDrugIndexInvocationDelegate,GetStringInvocationDelegate,GetBrandIDDelegate>
@end

@implementation PharmacyViewController

@synthesize activityController, service,delegate,mParentController,tblTemplates,currPresFromTemplate;
@synthesize tblGeneric, tblDosage, tblBrand, tblDosageFrm, tblInstruction, tblFollowUp,mrNo,patient;
@synthesize btnGeneric, btnBrand,templatesArray,patientNumber,currPharmacyOrderArray,brandDtlsForDrugView,UniquebrandDtls,BrandURL;
@synthesize genericDtls, dosageDtls, brandDtls, dosageFrmDtls, instructionDtls, followUpDtls, pharmacyDtls;
@synthesize docAddress,docName,docNumber,patCity,arrDrugIndices,pharmacyReportRecNatureIndex;

- (void)textFieldDidBeginEditing:(UITextField *)textField{
	
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

- (void)textFieldDidEndEditing:(UITextField *)textField{
	
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
	return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    if(textField==txtGenerics){
        txtBrand.text = @"";
          Gen_Brand=0;
    }
    if(textField==txtBrand && [txtGenerics.text length]>0){
    
        Gen_Brand=0;
        self.UniquebrandDtls=nil;
    }
    return YES;
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
    res = [[DataExchange getLoginResponse] objectAtIndex:0];
    Schedule *sec = [[DataExchange getSchedulerReponse] objectAtIndex:([DataExchange getScheduleDayIndex]<[DataExchange getSchedulerReponse].count?0:[DataExchange getScheduleDayIndex])];
    [self.service getPharmacyInvocation:[DataExchange getUserRoleId] SchedulesId:sec.schedule_id forType:1 delegate:self];
    [self.service getInstructionInvocation:[DataExchange getUserRoleId] delegate:self];
    [self.service getFollowUpInvocation:[DataExchange getUserRoleId] delegate:self];
    [self.service getTemplateInvocation:[DataExchange getUserRoleId] TemplateId:nil TemplateOrMedicine:YES delegate:self];
    
    txtGenerics.autocorrectionType = UITextAutocorrectionTypeNo;
    txtBrand.autocorrectionType = UITextAutocorrectionTypeNo;

    self.tblDosage.backgroundColor = [UIColor clearColor];
    self.tblBrand.layer.cornerRadius = 10;
    self.tblDosage.layer.cornerRadius = 10;
    self.tblDosageFrm.layer.cornerRadius = 10;
    self.tblFollowUp.layer.cornerRadius = 10;
    self.tblGeneric.layer.cornerRadius = 10;
    self.tblInstruction.layer.cornerRadius = 10;
    self.tblTemplates.layer.cornerRadius = 10;
    tblMedicineGlobal.layer.cornerRadius = 10;
    tblPharmacyGlobal.layer.cornerRadius = 10;
    scrollBG.layer.cornerRadius = 5;
    scrollFG.layer.cornerRadius = 5;
    [scrollFG addTarget:self action:@selector(wasDragged:withEvent:) forControlEvents:UIControlEventTouchDragInside];
    
    currentBrandIdIndex = 0;
    currentGenericsIndex = 0;
    currentPharmacyGlobalIndex = 0;
    currentMedFollowUpGlobalIndex = 0;
    
    dataView.hidden = false;
    keyboardView.hidden = true;
    stylingView.hidden = true;
    videoView.hidden = true;
    stylusScrollView.layer.cornerRadius = 10;
    stylusScrollView.clipsToBounds = true;
    textInputView.layer.cornerRadius = 10;
    genericsArraySelected = [[NSMutableArray alloc] init];
    brandArraySelected = [[NSMutableArray alloc] init];
    dosageArraySelected = [[NSMutableArray alloc] init];
    followUpArraySelected = [[NSMutableArray alloc] init];
    drawImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, handwritingView.frame.size.width, handwritingView.frame.size.height)];
    [handwritingView addSubview:drawImage];
    patientNameLblT.text = self.patient.patName;
    if([DataExchange getDocDisplayData].count==4){
        lblDocAddress.text = [NSString stringWithFormat:@"%@",[[DataExchange getDocDisplayData] objectAtIndex:1]];
        lblDocName.text = [NSString stringWithFormat:@"%@",[[DataExchange getDocDisplayData] objectAtIndex:0]];
        lblDocNumber.text = [NSString stringWithFormat:@"%@",[[DataExchange getDocDisplayData] objectAtIndex:2]];
        lblDocRow4.text = [NSString stringWithFormat:@"%@",[[DataExchange getDocDisplayData] objectAtIndex:3]];
    }else{
        lblDocAddress.text = docAddress;
        lblDocName.text = docName;
        lblDocNumber.text = docNumber;
    }
    lblPatCity.text = self.patCity;
    NSDateFormatter *df = [[[NSDateFormatter alloc] init] autorelease];
    [df setDateFormat:@"dd-MM-yyyy"];
    patientAgeLblT.text = [PharmacyViewController AgeFromString:[df stringFromDate:[PharmacyViewController mfDateFromDotNetJSONString:(![self.patient.patDOB isKindOfClass:[NSNull class]]?self.patient.patDOB:@"")]]];
    patientMobileLblT.text = patientNumber;
    dataView.hidden = true;
    keyboardView.hidden = false;
    stylingView.hidden = true;
    videoView.hidden = true;
    currentViewIndex=0;
    orderAdded = false;
    self.currPharmacyOrderArray = [[NSMutableArray alloc] init];
    
    [topTabBar setImage:[UIImage imageNamed:@"dataD.png"] forSegmentAtIndex:3];
    [topTabBar setImage:[UIImage imageNamed:@"keyboardD.png"] forSegmentAtIndex:0];
    [topTabBar setImage:[UIImage imageNamed:@"penD.png"] forSegmentAtIndex:1];
    [topTabBar setImage:[UIImage imageNamed:@"videoD.png"] forSegmentAtIndex:2];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:self.view.window];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:self.view.window];
    
    currentStylistPageIndex=0;
    arrayOfStylistImages = [[NSMutableArray alloc] init];
    [arrayOfStylistImages addObject:[[UIImage alloc] init]];
    drawImage.image = (UIImage*)[arrayOfStylistImages lastObject];
}

-(void) offerChoices:(NSInteger)type{
    ChooseActionOptionsController* controller = [[ChooseActionOptionsController alloc] initWithNibName:@"ChooseActionOptionsController" bundle:nil];
    controller.delegate = self;
    controller.type = type;
    [self.view addSubview:controller.view];
    popover = [[UIPopoverController alloc] initWithContentViewController:controller];
    popover.popoverContentSize = CGSizeMake(320, 414);
    [popover presentPopoverFromRect:CGRectMake(775, 700, 20, 20) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
    [controller release];
}

-(void)choicesMade:(_Bool [])choices{
    [[self.view viewWithTag:911] removeFromSuperview];
    [popover dismissPopoverAnimated:YES];
}

-(void)closePopup{
    [popover dismissPopoverAnimated:YES];
}

- (void)keyboardDidHide:(NSNotification *)n{
    CGRect viewFrame = textInputView.frame;
    viewFrame.size.height += 320;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    //do some animation
    [textInputView setFrame:viewFrame];
    [UIView commitAnimations];
}

- (void)keyboardDidShow:(NSNotification *)n {
    CGRect viewFrame = textInputView.frame;
    viewFrame.size.height -= 320;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    //do some animation
    [textInputView setFrame:viewFrame];
    [UIView commitAnimations];
}

- (void)wasDragged:(UIButton *)button withEvent:(UIEvent *)event{
	// get the touch
	UITouch *touch = [[event touchesForView:button] anyObject];
	// get delta
	CGPoint previousLocation = [touch previousLocationInView:button];
	CGPoint location = [touch locationInView:button];
	CGFloat delta_y = location.y - previousLocation.y;
	// move button
    if(button.center.y + delta_y >= 80 && button.center.y + delta_y <= 404)
        button.center = CGPointMake(button.center.x, button.center.y + delta_y);
    [stylusScrollView setContentOffset:CGPointMake(0, 720.0*(button.center.y-80)/324) animated:NO];
}

#pragma mark textfield delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
       if(textField==txtBrand){
           if ([txtGenerics.text isEqualToString:@""]) {
            self.brandDtls = [[NSMutableArray alloc] initWithArray:[mCuraSqlite returnAllBrandRecords:[textField.text stringByReplacingCharactersInRange:range withString:string]]];
               
                     }
           else{
               
               self.brandDtls = [[NSMutableArray alloc] initWithArray:[mCuraSqlite returnAllValidBrandRecords:[textField.text stringByReplacingCharactersInRange:range withString:string]]];

           }
        
        
        [self.tblBrand reloadData];
        self.tblBrand.hidden = FALSE;
    }
    else if(textField==txtGenerics){
        self.genericDtls = [[NSMutableArray alloc] initWithArray:[mCuraSqlite returnAllValidGenericRecords:[textField.text stringByReplacingCharactersInRange:range withString:string]]];
        [self.tblGeneric reloadData];
        self.tblGeneric.hidden = FALSE;
    }
	return YES;
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if(tableView == self.tblGeneric)
        return self.genericDtls.count;
    else if(tableView == self.tblBrand)
        return self.brandDtls.count;
    else if(tableView == self.tblDosage)
        return self.dosageDtls.count;
    else if(tableView == self.tblDosageFrm)
        return self.dosageFrmDtls.count;
    else if(tableView == self.tblInstruction)
        return self.instructionDtls.count;
    else if(tableView == self.tblFollowUp)
        return self.followUpDtls.count;
    else if(tableView == tblMedicineGlobal)
        return self.followUpDtls.count;
    else if(tableView == tblPharmacyGlobal)
        return self.pharmacyDtls.count;
    else if(tableView == self.tblTemplates)
        return self.templatesArray.count;
    else
        return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    if(tableView == self.tblGeneric){
        UITableViewCell *cell = [self.tblGeneric dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        }
        Generic *nat = [self.genericDtls objectAtIndex:indexPath.row];
        cell.textLabel.text = nat.Generic;
        
        return cell;
    }
    else if(tableView == self.tblBrand){
        UITableViewCell *cell = [self.tblBrand dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        }
        Brand *nat = [self.brandDtls objectAtIndex:indexPath.row];
        cell.textLabel.text = nat.BrandName;
        
        return cell;
    }
    else if(tableView == self.tblDosage){
        UITableViewCell *cell = [self.tblDosage dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        }
        
        Dosage *nat = [self.dosageDtls objectAtIndex:indexPath.row];
        cell.textLabel.text = nat.DosageProperty;
        
        return cell;
    }
    else if(tableView == self.tblDosageFrm){
        UITableViewCell *cell = [self.tblDosageFrm dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        }
        
        DosageFrm *nat = [self.dosageFrmDtls objectAtIndex:indexPath.row];
        cell.textLabel.text = nat.DosageFormProperty;
        
        return cell;
    }
    else if(tableView == self.tblInstruction){
        UITableViewCell *cell = [self.tblInstruction dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        }
        
        Instruction *nat = [self.instructionDtls objectAtIndex:indexPath.row];
        cell.textLabel.text = nat.Instruction;
        
        return cell;
    }
    else if(tableView == self.tblFollowUp){
        UITableViewCell *cell = [self.tblFollowUp dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        }
        
        FollowUp *nat = [self.followUpDtls objectAtIndex:indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"%d %@",[nat.Durationno integerValue],nat.Durationunits];
        return cell;
    }
    else if(tableView == tblMedicineGlobal){
        UITableViewCell *cell = [tblMedicineGlobal dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        }
        
        FollowUp *nat = [self.followUpDtls objectAtIndex:indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"%d %@",[nat.Durationno integerValue],nat.Durationunits];
        
        return cell;
    }
    else if(tableView == tblPharmacyGlobal){
        UITableViewCell *cell = [tblPharmacyGlobal dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        }
        
        Pharmacy *nat = [self.pharmacyDtls objectAtIndex:indexPath.row];
        cell.textLabel.text = nat.SubTenantName;
        
        return cell;
    }  
    else if(tableView==self.tblTemplates){
        UITableViewCell *cell = [self.tblTemplates dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        }
        Template *template = (Template*)[self.templatesArray objectAtIndex:indexPath.row];
        cell.textLabel.text = template.TemplateName;
        currTemplateName = template.TemplateName;
        return cell;
    }
    else{
        return nil;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(tableView == self.tblGeneric){
        currentGeneric = [self.genericDtls objectAtIndex:indexPath.row];
        currentGenericsIndex = indexPath.row+1;
        currentBrandIdIndex = 0;
        if(!self.activityController){
            self.activityController = [ISActivityOverlayController presentActivityOverViewController:self withLabel:@"Loading..."];
        }
        [self.btnGeneric setTitle:cell.textLabel.text forState:UIControlStateNormal];
        [txtGenerics setText:cell.textLabel.text];
        [txtGenerics resignFirstResponder];
        [self.service getBrandsInvocation:[DataExchange getUserRoleId] GenericId:[NSString stringWithFormat:@"%d",[currentGeneric.GenericId integerValue]] delegate:self];
        [self.btnBrand setTitle:@"--Select--" forState:UIControlStateNormal];
        txtBrand.text = @"";
          currentBrand=nil;
        Gen_Brand=0;
        self.tblGeneric.hidden = YES;
    }
    else if(tableView == self.tblBrand){
        if(!self.activityController){
            self.activityController = [ISActivityOverlayController presentActivityOverViewController:self withLabel:@"Loading..."];
        }
        if ([txtGenerics.text isEqualToString:@""]){
            Gen_Brand=GenericfromBrand;
            currentGenericsIndex =1;
            UniquebrandDtls = [[NSMutableArray alloc] init];
           [UniquebrandDtls addObject:(Brand*)[self.brandDtls objectAtIndex:indexPath.row]];
        }
        else if([txtGenerics.text length]>0){
            Gen_Brand=0;
        }
              
        currentBrandIdIndex = indexPath.row+1;
         [txtBrand resignFirstResponder];
        currentBrand = (Brand*)[self.brandDtls objectAtIndex:indexPath.row];
        NSString* url = [NSMutableString stringWithFormat:@"%@DrugIndex_Brand?BrandID=%d",[DataExchange getbaseUrl],[[(Brand*)[self.brandDtls objectAtIndex:indexPath.row] BrandId] integerValue]];
        [self.service getBrandsIDInvocation:[DataExchange getUserRoleId] BrandId:[NSString stringWithFormat:@"%d",[[(Brand*)[self.brandDtls objectAtIndex:indexPath.row] BrandId] integerValue]] delegate:self];
        BrandURL=[[NSString alloc]initWithString:url];
        NSLog(@"BRand_rugs_URL is:-%@",url);
        if (Gen_Brand==GenericfromBrand&& [txtGenerics.text isEqualToString:@""]) {
            //   [self.service getStringResponseInvocation:url Identifier:@"Pricing" delegate:self];
            }
        else{
            
            [self.service getStringResponseInvocation:url Identifier:@"GetDosageData" delegate:self];
        }
        
        [self.btnBrand setTitle:cell.textLabel.text forState:UIControlStateNormal];
        [txtBrand setText:cell.textLabel.text];
        self.tblBrand.hidden = YES;
       
    }
    else if(tableView == self.tblDosage){
        ((PharmacyOrder*)[self.currPharmacyOrderArray objectAtIndex:currentBtnPressedTag/10]).dosage = [(Dosage*)[self.dosageDtls objectAtIndex:indexPath.row] DosageProperty];
        ((PharmacyOrder*)[self.currPharmacyOrderArray objectAtIndex:currentBtnPressedTag/10]).dosage_id = [(Dosage*)[self.dosageDtls objectAtIndex:indexPath.row] DosageId];
        for (UIButton*btn in [pharmacyOrderScrollView subviews]) {
            if(btn.tag==currentBtnPressedTag){
                [btn setTitle:cell.textLabel.text forState:UIControlStateNormal];
                PharmacyOrder* currentOrder = (PharmacyOrder*)[self.currPharmacyOrderArray objectAtIndex:btn.tag/10];
                currentOrder.dosage = cell.textLabel.text;
                break;
            }
        }
        self.tblDosage.hidden = YES;
    }
    else if(tableView == self.tblDosageFrm){
        ((PharmacyOrder*)[self.currPharmacyOrderArray objectAtIndex:currentBtnPressedTag/10]).dosage_form = [(DosageFrm*)[self.dosageFrmDtls objectAtIndex:indexPath.row] DosageFormProperty];
        ((PharmacyOrder*)[self.currPharmacyOrderArray objectAtIndex:currentBtnPressedTag/10]).dosage_form_id = [(DosageFrm*)[self.dosageFrmDtls objectAtIndex:indexPath.row] DosageFormId];
        for (UIButton*btn in [pharmacyOrderScrollView subviews]) {
            if(btn.tag==currentBtnPressedTag){
                [btn setTitle:cell.textLabel.text forState:UIControlStateNormal];
                PharmacyOrder* currentOrder = (PharmacyOrder*)[self.currPharmacyOrderArray objectAtIndex:btn.tag/10];
                currentOrder.dosage_form = cell.textLabel.text;
                break;
            }
        }
        self.tblDosageFrm.hidden = YES;
    }
    else if(tableView == self.tblInstruction){
        ((PharmacyOrder*)[self.currPharmacyOrderArray objectAtIndex:currentBtnPressedTag/10]).dosage_ins_id = [(Instruction*)[self.instructionDtls objectAtIndex:indexPath.row] DosageInsId];
        ((PharmacyOrder*)[self.currPharmacyOrderArray objectAtIndex:currentBtnPressedTag/10]).instruction = [(Instruction*)[self.instructionDtls objectAtIndex:indexPath.row] Instruction];
        for (UIButton*btn in [pharmacyOrderScrollView subviews]) {
            if(btn.tag==currentBtnPressedTag){
                [btn setTitle:cell.textLabel.text forState:UIControlStateNormal];
                PharmacyOrder* currentOrder = (PharmacyOrder*)[self.currPharmacyOrderArray objectAtIndex:btn.tag/10];
                currentOrder.instruction = cell.textLabel.text;
                break;
            }
        }
        self.tblInstruction.hidden = YES;
    }
    else if(tableView == self.tblFollowUp){
        ((PharmacyOrder*)[self.currPharmacyOrderArray objectAtIndex:currentBtnPressedTag/10]).durationno = [(FollowUp*)[self.followUpDtls objectAtIndex:indexPath.row] Durationno];
        ((PharmacyOrder*)[self.currPharmacyOrderArray objectAtIndex:currentBtnPressedTag/10]).durationunits = [(FollowUp*)[self.followUpDtls objectAtIndex:indexPath.row] Durationunits];
        ((PharmacyOrder*)[self.currPharmacyOrderArray objectAtIndex:currentBtnPressedTag/10]).followup_id = [(FollowUp*)[self.followUpDtls objectAtIndex:indexPath.row] FollowupId];
        for (UIButton*btn in [pharmacyOrderScrollView subviews]) {
            if(btn.tag==currentBtnPressedTag){
                [btn setTitle:cell.textLabel.text forState:UIControlStateNormal];
                break;
            }
        }
        self.tblFollowUp.hidden = YES;
    }
    else if(tableView==self.tblTemplates){
        [self.service getTemplateInvocation:[DataExchange getUserRoleId] TemplateId:[NSString stringWithFormat:@"%d",[[(Template*)[self.templatesArray objectAtIndex:indexPath.row] TemplateId] integerValue]] TemplateOrMedicine:FALSE delegate:self];
        self.tblTemplates.hidden = true;
    }
    else if(tableView == tblMedicineGlobal){
        currentMedFollowUpGlobalIndex = indexPath.row + 1;
        [btnMedicineGlobal setTitle:cell.textLabel.text forState:UIControlStateNormal];
        tblMedicineGlobal.hidden = YES;
    }
    else if(tableView == tblPharmacyGlobal){
        currentPharmacyGlobalIndex = indexPath.row + 1;
        [btnPharmacyGlobal setTitle:cell.textLabel.text forState:UIControlStateNormal];
        tblPharmacyGlobal.hidden = YES;
    }
}

-(void)setBrand:(Brand*)brand{
    currentBrand = brand;
    self.brandDtls = [[NSMutableArray alloc] initWithArray:[mCuraSqlite returnAllValidBrandRecords:@""]];
    for (int i=0; i<self.brandDtls.count; i++) {
        if([[(Brand*)[self.brandDtls objectAtIndex:i] BrandId] integerValue]==brand.BrandId.integerValue){
            currentBrandIdIndex = i+1;
            break;
        }
    }
    NSString* url = [NSMutableString stringWithFormat:@"%@DrugIndex_Brand?BrandID=%d",[DataExchange getbaseUrl],[[(Brand*)[self.brandDtls objectAtIndex:currentBrandIdIndex-1] BrandId] integerValue]];
    [self.service getStringResponseInvocation:url Identifier:@"GetDosageData" delegate:self];
    [txtBrand setText:[(Brand*)[self.brandDtls objectAtIndex:currentBrandIdIndex-1] BrandName]];
    self.tblBrand.hidden = YES;
}

-(void) setGeneric:(Generic*)generic{
    currentGeneric = generic;
    self.genericDtls = [[NSMutableArray alloc] initWithArray:[mCuraSqlite returnAllValidGenericRecords:@""]];
    for (int i=0; i<self.genericDtls.count; i++) {
        if([[(Generic*)[self.genericDtls objectAtIndex:i] GenericId] integerValue]==generic.GenericId.integerValue){
            currentGenericsIndex = i+1;
            break;
        }
    }
    [txtGenerics setText:[(Generic*)[self.genericDtls objectAtIndex:currentGenericsIndex-1] Generic]];
    self.tblGeneric.hidden = YES;
    Gen_Brand=0;
}

-(void)addFieldBtnPressed:(id)sender{
    UIButton* btn = (UIButton*)sender;
    CGRect rectFrame;
    currentBtnPressedTag = btn.tag;
    switch (btn.tag%10) {
        case 1://dosage form btn pressed
            rectFrame = self.tblDosageFrm.frame;
            rectFrame.origin.y = 229 + 3.9 * btn.tag;
            self.tblDosageFrm.frame = rectFrame;
            self.tblDosageFrm.hidden = false;
            break;
        case 2://dosage btn pressed
            rectFrame = self.tblDosage.frame;
            rectFrame.origin.y = 229 + 3.9 * btn.tag;
            self.tblDosage.frame = rectFrame;
            self.tblDosage.hidden = false;
            break;
        case 3://instr btn pressed
            rectFrame = self.tblInstruction.frame;
            rectFrame.origin.y = 229 + 3.9 * btn.tag;
            self.tblInstruction.frame = rectFrame;
            self.tblInstruction.hidden = false;
            break;
        case 4://duration btn pressed
            rectFrame = self.tblFollowUp.frame;
            rectFrame.origin.y = 229 + 3.9 * btn.tag;
            self.tblFollowUp.frame = rectFrame;
            self.tblFollowUp.hidden = false;
            break;
        default:
            break;
    }
}

- (IBAction)doSegmentSwitch:(id)sender {
    UISegmentedControl *segmentedControl = (UISegmentedControl *) sender;
    currentViewIndex = segmentedControl.selectedSegmentIndex;
    [textInputView resignFirstResponder];
    switch (currentViewIndex) {
        case 0:// keyboard view
            printBtn.hidden = false;
            dataView.hidden = true;
            keyboardView.hidden = false;
            stylingView.hidden = true;
            videoView.hidden = true;
            break;
        case 1:
            printBtn.hidden = false;
            dataView.hidden = true;
            keyboardView.hidden = true;
            stylingView.hidden = false;
            videoView.hidden = true;
            break;
        case 2:
            printBtn.hidden = true;
            dataView.hidden = true;
            keyboardView.hidden = true;
            stylingView.hidden = true;
            videoView.hidden = false;
            break;
        case 3:
            printBtn.hidden = false;
            dataView.hidden = false;
            keyboardView.hidden = true;
            stylingView.hidden = true;
            videoView.hidden = true;
            break;
        default:
            break;
    }
}

-(IBAction) sendSMSOptions{
    switch (currentViewIndex) {
        case 0:
            [self offerChoices:1];
            break;
        case 1:
            [self offerChoices:2];
            break;
        case 2:
            [self offerChoices:3];
            break;
        case 3:
            [self offerChoices:4];
            break;
        default:
            break;
    }
}

-(IBAction) clickCancel:(id)sender{
    closeScreenAlertView = [[proAlertView alloc] initWithTitle:@"Close Screen!" message:@"Proceed?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"YES",nil];
    [closeScreenAlertView setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
    [closeScreenAlertView show];
}

-(IBAction) clickGenericBtn:(id)sender{
    self.tblGeneric.hidden = NO;
}

-(IBAction) clickBrandBtn:(id)sender{
    self.tblBrand.hidden = NO;
}

-(IBAction) clickTemplateBtn:(id)sender{
    self.tblTemplates.hidden = NO;
}

-(IBAction) clickMedicineGlobalBtn:(id)sender{
    tblMedicineGlobal.hidden = false;
}

-(IBAction) clickPharmacyGlobalBtn:(id)sender{
    tblPharmacyGlobal.hidden = false;
}

-(void)addPharmacyOrder{
    [pharmacyOrderScrollView setContentSize:CGSizeMake(1024,self.currPharmacyOrderArray.count*39)];
    for(UIView *v in [pharmacyOrderScrollView subviews])
    {
        [v removeFromSuperview];
        v = nil;
    }

    for (int i = 0; i<self.currPharmacyOrderArray.count; i++) {
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btn.frame = CGRectMake(0, 10+39*i, 20, 20);
		btn.tag = 1000 + i;
        [btn setImage:[UIImage imageNamed:@"cross.png"] forState:UIControlStateNormal];
        [btn setTitle:[(PharmacyOrder*)[self.currPharmacyOrderArray objectAtIndex:i] Generic] forState:UIControlStateNormal];        
		[btn addTarget:self action:@selector(deleteRecordBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [pharmacyOrderScrollView addSubview:btn];
        UILabel* label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 1+39*i, 170, 37)];
        label1.text = [(PharmacyOrder*)[self.currPharmacyOrderArray objectAtIndex:i] Generic];
        label1.textAlignment = UITextAlignmentCenter;
        [pharmacyOrderScrollView addSubview:label1];
        UILabel* label2 = [[UILabel alloc] initWithFrame:CGRectMake(170, 1+39*i, 170, 37)];
        label2.text = [(PharmacyOrder*)[self.currPharmacyOrderArray objectAtIndex:i] brand_name];
        label2.textAlignment = UITextAlignmentCenter;
        [pharmacyOrderScrollView addSubview:label2];
        [label1 setBackgroundColor:[UIColor clearColor]];
        [label2 setBackgroundColor:[UIColor clearColor]];
        [label1 release];
        [label2 release];
        [pharmacyOrderScrollView addSubview:btn];
        
        UIView* line = [[UIView alloc] initWithFrame:CGRectMake(0, 39*(i+1), 1024, 1)];
        [line setBackgroundColor:[UIColor whiteColor]];
        [pharmacyOrderScrollView addSubview:line];
        [line release];
        //--------dosage frm btn
        UIButton* btn1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btn1.frame = CGRectMake(5+170*2, 5+39*i, 160, 30);
		btn1.tag = 10*i+1;
        [btn1 setTitle:([(PharmacyOrder*)[self.currPharmacyOrderArray objectAtIndex:i] dosage_form]!=nil?[(PharmacyOrder*)[self.currPharmacyOrderArray objectAtIndex:i] dosage_form]:@"--Select One--") forState:UIControlStateNormal];
		[btn1 addTarget:self action:@selector(addFieldBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [pharmacyOrderScrollView addSubview:btn1];
        //--------dosage btn
        UIButton* btn2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btn2.frame = CGRectMake(5+170*3, 5+39*i, 160, 30);
		btn2.tag = 10*i+2;
        [btn2 setTitle:([(PharmacyOrder*)[self.currPharmacyOrderArray objectAtIndex:i] dosage]!=nil?[(PharmacyOrder*)[self.currPharmacyOrderArray objectAtIndex:i] dosage]:@"--Select One--") forState:UIControlStateNormal];
		[btn2 addTarget:self action:@selector(addFieldBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [pharmacyOrderScrollView addSubview:btn2];
        //--------instruction btn
        UIButton* btn3 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btn3.frame = CGRectMake(5+170*4, 5+39*i, 160, 30);
		btn3.tag = 10*i+3;
        [btn3 setTitle:([(PharmacyOrder*)[self.currPharmacyOrderArray objectAtIndex:i] instruction]!=nil?[(PharmacyOrder*)[self.currPharmacyOrderArray objectAtIndex:i] instruction]:@"--Select One--") forState:UIControlStateNormal];        
		[btn3 addTarget:self action:@selector(addFieldBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [pharmacyOrderScrollView addSubview:btn3];
        //--------duration btn
        UIButton* btn4 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btn4.frame = CGRectMake(5+170*5, 5+39*i, 160, 30);
		btn4.tag = 10*i+4;
        NSString* str = [NSString stringWithFormat:@"%d %@",[[(PharmacyOrder*)[currPharmacyOrderArray objectAtIndex:i] durationno] integerValue],[(PharmacyOrder*)[currPharmacyOrderArray objectAtIndex:i] durationunits]];
        [btn4 setTitle:([(PharmacyOrder*)[currPharmacyOrderArray objectAtIndex:i] durationunits]!=nil?str:@"--Select--") forState:UIControlStateNormal];
		[btn4 addTarget:self action:@selector(addFieldBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [pharmacyOrderScrollView addSubview:btn4];
    }
}

-(void)deleteRecordBtnPressed:(id)sender{
    UIButton* btn = (UIButton*)sender;
    currentOrderDeleteTag = btn.tag - 1000;
    deleteAlertView = [[proAlertView alloc] initWithTitle:@"Delete?" message:@"Are you sure you want to delete this order?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    [deleteAlertView setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
    [deleteAlertView show];
}

-(IBAction)beginVideoRecording{
    if(currentMedFollowUpGlobalIndex==0 || currentPharmacyGlobalIndex==0){
        proAlertView *alert = [[proAlertView alloc] initWithTitle:nil message:@"Please select both Pharmacy and Follow-Up above before proceeding" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
        [alert show];
        [alert release];
    }else{
        imagePicker = [[[UIImagePickerController alloc] init] autorelease];
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.mediaTypes =[[NSArray alloc] initWithObjects: (NSString *)kUTTypeMovie,(NSString *)kUTTypeImage, nil];
        imagePicker.videoQuality=UIImagePickerControllerQualityTypeLow;
        imagePicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;
        imagePicker.delegate = self;
        imagePicker.allowsEditing = NO;
        [imagePicker startVideoCapture];
        [self presentModalViewController:imagePicker animated:YES];
    }
}

#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)info {
	[self didFinishWithCamera];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if([mediaType isEqualToString:@"public.image"]){
        currentImage = [info valueForKey:UIImagePickerControllerOriginalImage];
        [self PostUploadImage:UIImageJPEGRepresentation(currentImage,1.0)];
        postStylusView.hidden = false;
        [self didFinishWithCamera];
        return;
    }
    else if ([mediaType isEqualToString:@"public.movie"]){
#if 1	       
        NSURL *videoURL    = [info objectForKey:UIImagePickerControllerMediaURL];
        
        NSString *pathToVideo = [videoURL path];
        NSLog(@"pathToVideo=%@",pathToVideo);
        
        NSNumber *startN = [info objectForKey:@"_UIImagePickerControllerVideoEditingStart"];
        NSNumber *endN = [info objectForKey:@"_UIImagePickerControllerVideoEditingEnd"];
        
        int startMilliseconds = ([startN doubleValue] * 1000);
        int endMilliseconds = ([endN doubleValue] * 1000);
        NSLog(@"startVideo=%d,endVideo=%d",startMilliseconds,endMilliseconds);
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        
        NSFileManager *manager = [NSFileManager defaultManager];
        
        NSString *outputURL = [documentsDirectory stringByAppendingPathComponent:@"output"] ;
        [manager createDirectoryAtPath:outputURL withIntermediateDirectories:YES attributes:nil error:nil];
        
        outputURL = [outputURL stringByAppendingPathComponent:@"output.mp4"];
        // Remove Existing File
        [manager removeItemAtPath:outputURL error:nil];
        
        AVURLAsset *videoAsset = [AVURLAsset URLAssetWithURL:videoURL options:nil]; 
        
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:videoAsset presetName:AVAssetExportPresetHighestQuality];
        exportSession.outputURL = [NSURL fileURLWithPath:outputURL];
        exportSession.outputFileType = AVFileTypeQuickTimeMovie;
        exportSession.shouldOptimizeForNetworkUse = YES;
        
        CMTime start = CMTimeMakeWithSeconds(1.0, 600);
        CMTime duration = CMTimeMakeWithSeconds(30.0, 600);
        
        
        CMTimeRange timeRange = CMTimeRangeMake(start, duration);
        exportSession.timeRange = timeRange;
        
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            switch (exportSession.status) {
                case AVAssetExportSessionStatusCompleted:
                    // Custom method to import the Exported Video
                    [self loadAssetFromFile:exportSession.outputURL];
                    break;
                case AVAssetExportSessionStatusFailed:
                    //
                    NSLog(@"Failed:%@",exportSession.error);
                    break;
                case AVAssetExportSessionStatusCancelled:
                    //
                    NSLog(@"Canceled:%@",exportSession.error);
                    break;
                default:
                    break;
            }
        }];
#endif 
    }
}

-(void)loadAssetFromFile:(NSURL*)exportSession{
    NSString *pathToVideo = [exportSession path];
    UISaveVideoAtPathToSavedPhotosAlbum(pathToVideo, self, @selector(video:didFinishSavingWithError:contextInfo:), NULL);
}

- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSURL *videoURL=[NSURL fileURLWithPath:videoPath];
    videoData = [[NSData alloc] initWithContentsOfURL:videoURL];
    [self didFinishWithCamera];
    [self PostUploadVideo:videoData];
    postVideoView.hidden = false;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self didFinishWithCamera];
}

- (void)didFinishWithCamera {
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark invocations

-(void) getDosageInvocationDidFinish:(GetDosageInvocation*)invocation
                         withDosages:(NSArray*)dosages
                           withError:(NSError*)error{
    if(!error){
        if([dosages count] > 0){
            self.dosageDtls = [[NSMutableArray alloc] initWithArray:dosages];
            [self.tblDosage reloadData];
            tblDosage.frame = CGRectMake(tblDosage.frame.origin.x, tblDosage.frame.origin.y, tblDosage.frame.size.width, min(20+44*dosageDtls.count,260));
        }
    }
}

-(void) getGenericInvocationDidFinish:(GetGenericInvocation*)invocation
                      withInvocations:(NSArray*)invocations
                            withError:(NSError*)error{
    if(!error){
        if([invocations count] > 0){
            self.genericDtls = [[NSMutableArray alloc] initWithArray:invocations];
            [self.tblGeneric reloadData];
            tblGeneric.frame = CGRectMake(tblGeneric.frame.origin.x, tblGeneric.frame.origin.y, tblGeneric.frame.size.width, min(20+44*genericDtls.count,260));
        }
    }
}

-(void) getDosageFrmInvocationDidFinish:(GetDosageFrmInvocation*)invocation
                            withDosages:(NSArray*)dosages
                              withError:(NSError*)error{
    if(!error){
        if([dosages count] > 0){
            self.dosageFrmDtls = [[NSMutableArray alloc] initWithArray:dosages];
            [self.tblDosageFrm reloadData];
            tblDosageFrm.frame = CGRectMake(tblDosageFrm.frame.origin.x, tblDosageFrm.frame.origin.y, tblDosageFrm.frame.size.width, min(20+44*dosageFrmDtls.count,260));
        }
    }
}

-(void) getFollowUpInvocationDidFinish:(GetFollowUpInvocation*)invocation
                           withFollows:(NSArray*)follows
                             withError:(NSError*)error{
    if(!error){
        if([follows count] > 0){
            self.followUpDtls = follows;
            [self.tblFollowUp reloadData];
            [tblMedicineGlobal reloadData];
            tblFollowUp.frame = CGRectMake(tblFollowUp.frame.origin.x, tblFollowUp.frame.origin.y, tblFollowUp.frame.size.width, min(20+44*followUpDtls.count,260));
        }
    }
}

-(void) getPharmacyInvocationDidFinish:(GetPharmacyInvocation*)invocation
                         withPharmacys:(NSArray*)pharmacys
                             withError:(NSError*)error{
    if(!error){
        if([pharmacys count] > 0){
            self.pharmacyDtls = pharmacys;
            [tblPharmacyGlobal reloadData];
            Pharmacy *nat = [pharmacys objectAtIndex:0];
            [btnPharmacyGlobal setTitle:nat.SubTenantName forState:UIControlStateNormal];
            currentPharmacyGlobalIndex=1;
        }
        else{
            [self.service getPharmacyInvocation:[DataExchange getUserRoleId] SchedulesId:@"0" forType:1 delegate:self];
        }
    }
}

-(void) getInstructionInvocationDidFinish:(GetInstructionInvocation*)invocation
                          withInvocations:(NSArray*)invocations
                                withError:(NSError*)error{
    if(!error){
        if([invocations count] > 0){
            self.instructionDtls = invocations;
            [self.tblInstruction reloadData];
            tblInstruction.frame = CGRectMake(tblInstruction.frame.origin.x, tblInstruction.frame.origin.y, tblInstruction.frame.size.width, min(20+44*instructionDtls.count,260));
        }
    }
}

-(void) GetStringInvocationDidFinish:(GetStringInvocation *)invocation 
                  withResponseString:(NSString *)responseString 
                      withIdentifier:(NSString *)identifier 
                           withError:(NSError *)error{
    if(!error){
        NSArray* response = [responseString JSONValue];
        if([identifier isEqualToString:@"GetBrands"]){
            self.brandDtls = [[NSMutableArray alloc] init];
            self.brandDtlsForDrugView = [[NSMutableArray alloc] init];
            NSDictionary* dictTemp;
            for (int i=0; i<response.count; i++) {
                dictTemp = [response objectAtIndex:i];
                Brand* brandtemp = [[Brand alloc] init];
                brandtemp.BrandName = [dictTemp objectForKey:@"Name"];
                brandtemp.BrandId = [dictTemp objectForKey:@"Id"];
                [self.brandDtls addObject:brandtemp];
               
            }
            [mCuraSqlite DeleteAllBrands];
            for (int i=0; i<self.brandDtls.count; i++) {
                [mCuraSqlite InsertANewBrandRecord:[self.brandDtls objectAtIndex:i] ForGenericId:0];
            }
            if (self.activityController) {
                [self.activityController dismissActivity];
                self.activityController = Nil;
            }
            [self.tblBrand reloadData];
            tblBrand.frame = CGRectMake(tblBrand.frame.origin.x, tblBrand.frame.origin.y, tblBrand.frame.size.width, min(20+44*brandDtls.count,260));
        }else if([identifier isEqualToString:@"GetDosageData"]){
            self.dosageDtls = [[NSMutableArray alloc] init];
            self.dosageFrmDtls = [[NSMutableArray alloc] init];
            if(responseString.length<2){
                [self.tblDosage reloadData];
                tblDosage.frame = CGRectMake(tblDosage.frame.origin.x, tblDosage.frame.origin.y, tblDosage.frame.size.width, min(20+44*dosageDtls.count,260));
                [self.tblDosageFrm reloadData];
                tblDosageFrm.frame = CGRectMake(tblDosageFrm.frame.origin.x, tblDosageFrm.frame.origin.y, tblDosageFrm.frame.size.width, min(20+44*dosageFrmDtls.count,260));
                return;
            }
            NSDictionary* dictTemp = [responseString JSONValue];
            NSArray* pricesArr = [dictTemp objectForKey:@"Pricing"];
            for (int i=0; i<pricesArr.count; i++){
                NSDictionary* priceDict = [pricesArr objectAtIndex:i];
                DosageFrm* dosagefrmTemp = [[DosageFrm alloc] init];
                dosagefrmTemp.DosageFormId = [NSNumber numberWithInt:1];
                dosagefrmTemp.DosageFormProperty = [priceDict objectForKey:@"DosageForm"];
                [self.dosageFrmDtls addObject:dosagefrmTemp];
                
                Dosage* dosageTemp = [[Dosage alloc] init];
                dosageTemp.DosageId = [NSNumber numberWithInt:1];
                dosageTemp.DosageProperty = [priceDict objectForKey:@"Strength"];
                [self.dosageDtls addObject:dosageTemp];
            }
            [self.tblDosage reloadData];
            tblDosage.frame = CGRectMake(tblDosage.frame.origin.x, tblDosage.frame.origin.y, tblDosage.frame.size.width, min(20+44*dosageDtls.count,260));
            [self.tblDosageFrm reloadData];
            tblDosageFrm.frame = CGRectMake(tblDosageFrm.frame.origin.x, tblDosageFrm.frame.origin.y, tblDosageFrm.frame.size.width, min(20+44*dosageFrmDtls.count,260));
        }
        
        else if([identifier isEqualToString:@"Pricing"]){
            
            self.dosageDtls = [[NSMutableArray alloc] init];
            self.dosageFrmDtls = [[NSMutableArray alloc] init];
             NSLog(@"%@",responseString);
           if(responseString.length<2){
              
                 NSDictionary* dictTemp = [responseString JSONValue];
                  NSDictionary* priceDict = [dictTemp objectForKey:@"Pricing"];
               DosageFrm* dosagefrmTemp = [[DosageFrm alloc] init];
               dosagefrmTemp.DosageFormId = [NSNumber numberWithInt:1];
               dosagefrmTemp.DosageFormProperty = [priceDict objectForKey:@"DosageForm"];
               [self.dosageFrmDtls addObject:dosagefrmTemp];
               
               Dosage* dosageTemp = [[Dosage alloc] init];
               dosageTemp.DosageId = [NSNumber numberWithInt:1];
               dosageTemp.DosageProperty = [priceDict objectForKey:@"Strength"];
               [self.dosageDtls addObject:dosageTemp];

               
                [self.tblDosage reloadData];
                tblDosage.frame = CGRectMake(tblDosage.frame.origin.x, tblDosage.frame.origin.y, tblDosage.frame.size.width, min(20+44*dosageDtls.count,260));
                [self.tblDosageFrm reloadData];
                tblDosageFrm.frame = CGRectMake(tblDosageFrm.frame.origin.x, tblDosageFrm.frame.origin.y, tblDosageFrm.frame.size.width, min(20+44*dosageFrmDtls.count,260));
               //return;
           }
           else{
            NSDictionary* dictTemp = [responseString JSONValue];
            NSArray* pricesArr = [dictTemp objectForKey:@"Pricing"];
               if ([pricesArr count]>0) {
                   for (int i=0; i<pricesArr.count; i++){
                       NSDictionary* priceDict = [pricesArr objectAtIndex:i];
                       DosageFrm* dosagefrmTemp = [[DosageFrm alloc] init];
                       dosagefrmTemp.DosageFormId = [NSNumber numberWithInt:1];
                       dosagefrmTemp.DosageFormProperty = [priceDict objectForKey:@"DosageForm"];
                       [self.dosageFrmDtls addObject:dosagefrmTemp];
                       
                       Dosage* dosageTemp = [[Dosage alloc] init];
                       dosageTemp.DosageId = [NSNumber numberWithInt:1];
                       dosageTemp.DosageProperty = [priceDict objectForKey:@"Strength"];
                       [self.dosageDtls addObject:dosageTemp];
                   }
                   [self.tblDosage reloadData];
                   tblDosage.frame = CGRectMake(tblDosage.frame.origin.x, tblDosage.frame.origin.y, tblDosage.frame.size.width, min(20+44*dosageDtls.count,260));
                   [self.tblDosageFrm reloadData];
                   tblDosageFrm.frame = CGRectMake(tblDosageFrm.frame.origin.x, tblDosageFrm.frame.origin.y, tblDosageFrm.frame.size.width, min(20+44*dosageFrmDtls.count,260));
               }
               else{
                   proAlertView *alert = [[proAlertView alloc] initWithTitle:@"Error!" message:@"Could not find Details for this Brand!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                   [alert setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
                   [alert show];
                   [alert release];
                   
               }
          
           }
        }
    }
}

-(void) getBrandInvocationDidFinish:(GetBrandInvocation*)invocation
                         withBrands:(NSArray*)brands
                          withError:(NSError*)error{
    
    if (self.activityController) {
		[self.activityController dismissActivity];
		self.activityController = Nil;
	}
   
  
    if(!error){
        if([brands count] > 0){
            [mCuraSqlite DeleteAllBrands];
            for (int i=0; i<brands.count; i++) {
                [mCuraSqlite InsertANewBrandRecord:[brands objectAtIndex:i] ForGenericId:0];
            }
            self.brandDtls = [[NSMutableArray alloc] initWithArray:brands];
            self.brandDtlsForDrugView = [[[NSMutableArray alloc] initWithArray:brands] retain];
            [self.tblBrand reloadData];
        // tblBrand.frame = CGRectMake(tblBrand.frame.origin.x, tblBrand.frame.origin.y, tblBrand.frame.size.width, min(20+44*brandDtls.count,260));
                      
        }
        else{
            if (Gen_Brand==GenericfromBrand) {
            }
            else{
                proAlertView *alert = [[proAlertView alloc] initWithTitle:@"Error!" message:@"Could not find brand for this generic!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [alert setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
                [alert show];
                [alert release];
            }

        }
    }
}

-(void) getBrandIDDidFinish:(GetBrandIDInvocation*)invocation withBrands:(NSArray*)brands withError:(NSError*)error{
    
   
    if (self.activityController) {
        [self.activityController dismissActivity];
        self.activityController = Nil;
    }

    
    if(!error){
        if([brands count] > 0){
           // [mCuraSqlite DeleteAllBrands];
            for (int i=0; i<brands.count; i++) {
              // [mCuraSqlite InsertANewBrandRecord:[brands objectAtIndex:i] ForGenericId:0];
            }
           // self.brandDtls = [[NSMutableArray alloc] initWithArray:brands];
            self.brandDtlsForDrugView = [[[NSMutableArray alloc] initWithArray:brands] retain];
           // [self.tblBrand reloadData];
           // tblBrand.frame = CGRectMake(tblBrand.frame.origin.x, tblBrand.frame.origin.y, tblBrand.frame.size.width, min(20+44*brandDtls.count,260));
            if ([txtGenerics.text isEqualToString:@""]) {
                // Gen_Brand=GenericfromBrand;
                // NSArray* temp = [(Brand*)[brands objectAtIndex:0] arrayGeneric];
                  [self.service getStringResponseInvocation:BrandURL Identifier:@"Pricing" delegate:self];
                for (int i=0; i<[[(Brand*)[brands objectAtIndex:0] arrayGeneric] count]; i++){
                    self.genericDtls =nil;
                    strgeneric=[NSString stringWithString:[[(PriceObject*)[(Brand*)[brands objectAtIndex:0] arrayGeneric]objectAtIndex:i]PGenericName]];
                }
                self.genericDtls = [[NSMutableArray alloc] initWithArray:[mCuraSqlite returnSelectedGenericID:strgeneric]];
                currentGeneric = [self.genericDtls objectAtIndex:0];
               // self.selectedGeneric= currentGeneric;
                if(!self.activityController){
                    self.activityController = [ISActivityOverlayController presentActivityOverViewController:self withLabel:@"Loading..."];
                }
                [self.service getBrandsInvocation:[DataExchange getUserRoleId] GenericId:[NSString stringWithFormat:@"%d",[currentGeneric.GenericId integerValue]] delegate:self];
                [txtGenerics setText:[(Generic*)[self.genericDtls objectAtIndex:0] Generic]];
                tblGeneric.hidden = YES;
                
                
                //[self reloadViews];
            }

        }
 
        else{
           
            proAlertView *alert = [[proAlertView alloc] initWithTitle:@"Error!" message:@"Could not find this Brand Details!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
            [alert show];
            [alert release];
        }
    }
    
   }
    
-(void)GetTemplateInvocationDidFinish:(GetTemplateInvocation *)invocation
                        withTemplates:(NSArray *)templates 
                            withError:(NSError *)error{
    if(!error){
        self.templatesArray = [[NSArray alloc] initWithArray:templates];
        [tblTemplates reloadData];
        tblTemplates.frame = CGRectMake(tblTemplates.frame.origin.x, tblTemplates.frame.origin.y, tblTemplates.frame.size.width, min(20+44*templates.count,260));
    }
}

-(void)GetTemplateMedicineInvocationDidFinish:(GetTemplateInvocation *)invocation 
                                 withMedicine:(NSArray *)medicineArray
                                    withError:(NSError *)error{
    if(!error){
        for (int i=0; i<medicineArray.count; i++) {
            PharmacyOrder* currentPharmacyOrder = [[PharmacyOrder alloc] init];
            currentPharmacyOrder.generic_id = [NSNumber numberWithInt:[[(PharmacyOrder*)[medicineArray objectAtIndex:i] generic_id] integerValue]];
            currentPharmacyOrder.brand_id = [NSNumber numberWithInt:[[(PharmacyOrder*)[medicineArray objectAtIndex:i] brand_id] integerValue]];
            currentPharmacyOrder.dosage_form_id = [NSNumber numberWithInt:[[(PharmacyOrder*)[medicineArray objectAtIndex:i] dosage_form_id] integerValue]];
            currentPharmacyOrder.dosage_id = [NSNumber numberWithInt:[[(PharmacyOrder*)[medicineArray objectAtIndex:i] dosage_id] integerValue]];
            currentPharmacyOrder.dosage_ins_id = [NSNumber numberWithInt:[[(PharmacyOrder*)[medicineArray objectAtIndex:i] dosage_ins_id] integerValue]];
            currentPharmacyOrder.followup_id = [NSNumber numberWithInt:[[(PharmacyOrder*)[medicineArray objectAtIndex:i] followup_id] integerValue]];
            if ([(PharmacyOrder*)[medicineArray objectAtIndex:i] followup_id]) {
                currentPharmacyOrder.brand_name = [(PharmacyOrder*)[medicineArray objectAtIndex:i] brand_name];
            }else
                currentPharmacyOrder.brand_name = @"";
            
            NSArray* temp = [mCuraSqlite returnAllValidGenericRecords:@""];
            for(int i=0;i<temp.count;i++)
                if([currentPharmacyOrder.generic_id integerValue] == [[(Generic*)[temp objectAtIndex:i] GenericId] integerValue]){
                    currentPharmacyOrder.Generic = [(Generic*)[temp objectAtIndex:i] Generic];
                }
            
            for(int i=0;i<self.followUpDtls.count;i++)
                if([currentPharmacyOrder.followup_id integerValue] == [[(FollowUp*)[self.followUpDtls objectAtIndex:i] FollowupId] integerValue]){
                    currentPharmacyOrder.durationunits = [(FollowUp*)[self.followUpDtls objectAtIndex:i] Durationunits];
                    currentPharmacyOrder.durationno = [(FollowUp*)[self.followUpDtls objectAtIndex:i] Durationno];
                }
            for(int i=0;i<self.instructionDtls.count;i++)
                if([currentPharmacyOrder.dosage_ins_id integerValue] == [[(Instruction*)[self.instructionDtls objectAtIndex:i] DosageInsId] integerValue]){
                    currentPharmacyOrder.instruction = [(Instruction*)[self.instructionDtls objectAtIndex:i] Instruction];
                }
            currentPharmacyOrder.dosage = [(PharmacyOrder*)[medicineArray objectAtIndex:i] dosage];
            currentPharmacyOrder.dosage_form = [(PharmacyOrder*)[medicineArray objectAtIndex:i] dosage_form];
            currentPharmacyOrder.isTemplate = TRUE;
            [self.currPharmacyOrderArray addObject:currentPharmacyOrder];
            [self addPharmacyOrder];
            if(self.currPharmacyOrderArray.count<8){
                [UIView beginAnimations:nil context:NULL];
                [UIView setAnimationDuration:0.5];
                slidingView.frame = CGRectMake(slidingView.frame.origin.x, slidingView.frame.origin.y + 39, slidingView.frame.size.width, slidingView.frame.size.height);
                [UIView commitAnimations];
            }
        }
    }
}

#pragma mark others

-(IBAction)addBtnPressed{
    if(currentGenericsIndex==0 || currentBrandIdIndex==0){
        proAlertView *alert = [[proAlertView alloc] initWithTitle:@"Error!" message:@"Please select all options before adding!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
        [alert show];
        [alert release];
    }
    else{
        NSLog(@"%i",currentGenericsIndex-1);
        NSLog(@"%i",currentBrandIdIndex-1);
        PharmacyOrder* currentPharmacyOrder = [[PharmacyOrder alloc] init];
        if (Gen_Brand==GenericfromBrand) {
            currentPharmacyOrder.Generic = [(Generic*)[self.genericDtls objectAtIndex:0] Generic];
            currentPharmacyOrder.generic_id = [(Generic*)[self.genericDtls objectAtIndex:0] GenericId];
            
            currentPharmacyOrder.brand_name = [(Brand*)[self.UniquebrandDtls objectAtIndex:0] BrandName];
            currentPharmacyOrder.brand_id = [(Brand*)[self.UniquebrandDtls objectAtIndex:0] BrandId];
            self.UniquebrandDtls=nil;
        }
        else{
        currentPharmacyOrder.Generic = [(Generic*)[self.genericDtls objectAtIndex:currentGenericsIndex-1] Generic];
         currentPharmacyOrder.generic_id = [(Generic*)[self.genericDtls objectAtIndex:currentGenericsIndex-1] GenericId];
            
            currentPharmacyOrder.brand_name = [(Brand*)[self.brandDtls objectAtIndex:currentBrandIdIndex-1] BrandName];
            currentPharmacyOrder.brand_id = [(Brand*)[self.brandDtls objectAtIndex:currentBrandIdIndex-1] BrandId];
        }
        
       
        currentPharmacyOrder.dosage = nil;
        currentPharmacyOrder.dosage_id = nil;
        currentPharmacyOrder.followup_id = nil;
        currentPharmacyOrder.instruction = nil;
        currentPharmacyOrder.dosage_form = nil;
        currentPharmacyOrder.dosage_form_id = nil;
        currentPharmacyOrder.durationunits = nil;
        [self.currPharmacyOrderArray addObject:currentPharmacyOrder];
        [self addPharmacyOrder];
        if(self.currPharmacyOrderArray.count<8){
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.5];
            slidingView.frame = CGRectMake(slidingView.frame.origin.x, slidingView.frame.origin.y + 39, slidingView.frame.size.width, slidingView.frame.size.height);
            [UIView commitAnimations];
        }
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSArray *allTouches = [touches allObjects];
    int count = [allTouches count];
	if(count==1){
        UITouch *touch = [touches anyObject];
        lastPoint = [touch locationInView:handwritingView];
        secondLastPoint = lastPoint;
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    NSArray *allTouches = [touches allObjects];
    int count = [allTouches count];
	if(count==1){
        UITouch *touch = [touches anyObject];	
        CGPoint currentPoint = [touch locationInView:handwritingView];
        UIGraphicsBeginImageContext(handwritingView.frame.size);
        [drawImage.image drawInRect:CGRectMake(0, 0, handwritingView.frame.size.width, handwritingView.frame.size.height)];
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 2.0);
        switch (currentColor) {
            case 0:
                CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 0.0, 1.0, 0.0, 1.0);
                break;
            case 1:
                CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 0.0, 0.0, 1.0, 1.0);
                break;
            case 2:
                CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 1.0, 0.0, 0.0, 1.0);
                break;
            case 3:
                CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 0.5, 0.2, 0.3, 1.0);
                break;
            case 4:
                CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 6.0*(handwritingView.frame.size.height/350));
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

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    tblBrand.hidden = true;
    tblDosage.hidden = true;
    tblDosageFrm.hidden = true;
    tblFollowUp.hidden = true;
    tblGeneric.hidden = true;
    tblInstruction.hidden = true;
    tblTemplates.hidden = true;
    tblMedicineGlobal.hidden = true;
    tblPharmacyGlobal.hidden = true;
    [arrayOfStylistImages replaceObjectAtIndex:currentStylistPageIndex withObject:drawImage.image];
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

-(IBAction) clickOrderButton:(id)sender{
    if(currentPharmacyGlobalIndex==0 || currentMedFollowUpGlobalIndex==0){
        proAlertView *alert = [[proAlertView alloc] initWithTitle:nil message:@"Please select both pharmacy and next visit before proceeding!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
        [alert show];
        [alert release];
        return;
    } else if(self.currPharmacyOrderArray.count==0){
        proAlertView *alert = [[proAlertView alloc] initWithTitle:nil message:@"Please add a pharmacy before proceeding!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
        [alert show];
        [alert release];
        return;
    }else
    for (int i=0; i<self.currPharmacyOrderArray.count; i++) {
        if([[(PharmacyOrder*)[self.currPharmacyOrderArray objectAtIndex:i] dosage_form_id] integerValue]==0 || [[(PharmacyOrder*)[self.currPharmacyOrderArray objectAtIndex:i] dosage_ins_id] integerValue]==0 || [[(PharmacyOrder*)[self.currPharmacyOrderArray objectAtIndex:i] dosage_id] integerValue]==0||[[(PharmacyOrder*)[self.currPharmacyOrderArray objectAtIndex:i] followup_id] integerValue]==0){
            proAlertView *alert = [[proAlertView alloc] initWithTitle:nil message:@"Please select all items before proceeding" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
            [alert show];
            [alert release];
            return;
        }
    }
    saveAlertView= [[proAlertView alloc] initWithTitle:nil message:@"Submit Pharmacy Order?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes",nil];
    [saveAlertView setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
    [saveAlertView show];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{	
    if (self.activityController){
		[self.activityController dismissActivity];
		self.activityController = Nil;
	}
    if(connection!=videoConnection){
        [self.delegate labOrderDidSubmit];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    NSString *newStr = [[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    NSLog(@"---%@",newStr);
    postStylusView.hidden = true;
    if(connection==videoConnection || connection==stylusPicConnection){
        [self SuccessToLoadTable:newStr];
    }
    
    if(connection==postOrderConnection){
        NSDictionary* dictTemp = [newStr JSONValue];
        if([[dictTemp objectForKey:@"status"] boolValue]){
            NSString* recordId = [[newStr JSONValue] objectForKey:@"ID"];
            PatMedRecords* tempRec = [[[PatMedRecords alloc] init]autorelease];
            tempRec.EntryTypeId = [NSNumber numberWithInt:1];
            tempRec.Mrno = [NSString stringWithFormat:@"%d",self.mrNo];
            tempRec.RecNatureId = [NSString stringWithFormat:@"%d",self.pharmacyReportRecNatureIndex];
            tempRec.RecordId = recordId;
            tempRec.UserRoleId = [DataExchange getUserRoleId];
            
            [self.mParentController addRecord:tempRec];
            proAlertView *alert = [[proAlertView alloc] initWithTitle:@"Success!" message:@"Prescription posted successfully" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
            [alert show];
            [alert release];
        }
        else{
            proAlertView *alert = [[proAlertView alloc] initWithTitle:@"Error!" message:[newStr stringByReplacingOccurrencesOfString:@"\"" withString:@""] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
            [alert show];
            [alert release];
        }
    }
}

- (void)connection:(NSURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite{
    if(connection==videoConnection){
        CGRect frame = videoPostProgressBar.frame;
        frame.size.width = (totalBytesWritten*461/totalBytesExpectedToWrite);
        [videoPostProgressBar setFrame:frame];
        [progressLbl setText:[NSString stringWithFormat:@"%d kB of %d kB sent (%d%%)",totalBytesWritten/1000,totalBytesExpectedToWrite/1000,(totalBytesWritten*100/totalBytesExpectedToWrite)]];
        if(totalBytesWritten==totalBytesExpectedToWrite)
            postVideoView.hidden = true;
    }else if(connection==stylusPicConnection){
        CGRect frame = stylusProgressBar.frame;
        frame.size.width = (totalBytesWritten*461/totalBytesExpectedToWrite);
        [stylusProgressBar setFrame:frame];
        [stylusProgressLbl setText:[NSString stringWithFormat:@"%d kB of %d kB sent (%d%%)",totalBytesWritten/1000,totalBytesExpectedToWrite/1000,(totalBytesWritten*100/totalBytesExpectedToWrite)]];
        if(totalBytesWritten==totalBytesExpectedToWrite)
            [stylusProgressLbl setText:@"Finishing"];
    }
}

-(IBAction)cancelCurrVideoPost{
    stopVidPostAlertView= [[proAlertView alloc] initWithTitle:@"Cancel Post?" message:@"Some progress has been made. Proceed?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes",nil];
    [stopVidPostAlertView setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
    [stopVidPostAlertView show];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
	proAlertView *alert = [[proAlertView alloc] initWithTitle:@"Something Went Wrong" message:@"Please Try Again" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
    [alert setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
	[alert show];
	[alert release];
	return;
}

-(void)PostUploadVideo:(NSData*)_videoData{
    NSString *urlString = [NSString stringWithFormat:@"http://%@UploadOrderVedio",[DataExchange getbaseUrl]];
    //set up the request body
    NSMutableData *body = [[NSMutableData alloc] init];
    NSString* firstStr = @"{\"fileStream\":\"";
    NSString* lastStr = @"\"}";
    // add image data
    [body appendData:[firstStr dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[Base64 encode:_videoData] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[lastStr dataUsingEncoding:NSUTF8StringEncoding]];
    // setting up the request object now
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    [request setAllHTTPHeaderFields:[[NSDictionary alloc] initWithObjects:[[NSArray alloc] initWithObjects:@"application/json",@"utf-8",[DataExchange getDomainUrl],[NSString stringWithFormat:@"%d",body.length], nil] forKeys:[[NSArray alloc] initWithObjects:@"Content-Type",@"charset",@"Host",@"Content-Length", nil]]];
    [request setHTTPBody:body];
    videoConnection = [[[NSURLConnection alloc] initWithRequest:request delegate:self] autorelease];
}

-(void)PostUploadImage:(NSData*)_imgData{
    NSString *urlString = [NSString stringWithFormat:@"http://%@UploadOrderImage",[DataExchange getbaseUrl]];
    //set up the request body
    NSMutableData *body = [[NSMutableData alloc] init];
    NSString* firstStr = @"{\"fileStream\":\"";
    NSString* lastStr = @"\"}";
    // add image data
    [body appendData:[firstStr dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[Base64 encode:_imgData] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[lastStr dataUsingEncoding:NSUTF8StringEncoding]];
    // setting up the request object now
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    [request setAllHTTPHeaderFields:[[NSDictionary alloc] initWithObjects:[[NSArray alloc] initWithObjects:@"application/json",@"utf-8",[DataExchange getDomainUrl],[NSString stringWithFormat:@"%d",body.length], nil] forKeys:[[NSArray alloc] initWithObjects:@"Content-Type",@"charset",@"Host",@"Content-Length", nil]]];
    
    [request setHTTPBody:body];
    stylusPicConnection = [[[NSURLConnection alloc] initWithRequest:request delegate:self] autorelease];
}

-(void)PostUploadText:(NSString*)_textString{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSString *urlString = [NSString stringWithFormat:@"http://%@UploadOrderText",[DataExchange getbaseUrl]];
    //set up the request body
    NSMutableData *body = [[NSMutableData alloc] init];
    NSString* firstStr = @"{\"fileStream\":\"";
    NSString* lastStr = @"\"}";
    // add image data
    [body appendData:[firstStr dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[Base64 encode:[_textString dataUsingEncoding:NSUTF8StringEncoding]] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[lastStr dataUsingEncoding:NSUTF8StringEncoding]];
    // setting up the request object now
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    [request setAllHTTPHeaderFields:[[NSDictionary alloc] initWithObjects:[[NSArray alloc] initWithObjects:@"application/json",@"utf-8",[DataExchange getDomainUrl],[NSString stringWithFormat:@"%d",body.length], nil] forKeys:[[NSArray alloc] initWithObjects:@"Content-Type",@"charset",@"Host",@"Content-Length", nil]]];
    [request setHTTPBody:body];
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	
	NSString *response= [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding];
    [pool release];
    if([response rangeOfString:@"Request"].location == NSNotFound)
        [self performSelectorOnMainThread:@selector(SuccessToLoadTable:) withObject:response waitUntilDone:NO];    
}

-(void)SuccessToLoadTable:(NSString*)response{
    NSString* dataToPost = [NSString stringWithFormat:@"{\"Mrno\":%d,\"UserRoleID\":%@,\"PharmacyID\":%d,\"Followup\":%d,\"filename\":%@}",self.mrNo,[DataExchange getUserRoleId],[[(Pharmacy*)[self.pharmacyDtls objectAtIndex:currentPharmacyGlobalIndex-1] SubTenantId] integerValue],[[(FollowUp*)[self.followUpDtls objectAtIndex:currentMedFollowUpGlobalIndex-1] FollowupId] integerValue],response];
    NSURL* myUrl = [[[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://%@PostPharmacyOrder_file",[DataExchange getbaseUrl]]] autorelease];
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
    [request setURL:myUrl];
    [request setHTTPMethod:@"POST"];
    [request setAllHTTPHeaderFields:[[[NSDictionary alloc] initWithObjects:[[[NSArray alloc] initWithObjects:@"application/json",@"utf-8",[DataExchange getDomainUrl],[NSString stringWithFormat:@"%d",dataToPost.length], nil] autorelease] forKeys:[[[NSArray alloc] initWithObjects:@"Content-Type",@"charset",@"Host",@"Content-Length", nil]autorelease]]autorelease]];
    [request setHTTPBody:[NSData dataWithBytes:[dataToPost UTF8String] length:[dataToPost lengthOfBytesUsingEncoding:NSUTF8StringEncoding]]]; 
    NSURLConnection *theConnection=[[[NSURLConnection alloc] initWithRequest:request delegate:self] autorelease];
    if (!theConnection) {
        proAlertView *alert = [[proAlertView alloc] initWithTitle:@"No Internet Connection" message:@"Please Try Again Later" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
        [alert show];
        [alert release];
    }
}

-(IBAction)saveChanges{
    if(currentMedFollowUpGlobalIndex>0 && currentPharmacyGlobalIndex>0){
        CGSize newSize = CGSizeMake(drawImage.image.size.width, drawImage.image.size.height*arrayOfStylistImages.count);
        UIGraphicsBeginImageContext(newSize);
        for(int i=0;i<arrayOfStylistImages.count;i++){
            [[arrayOfStylistImages objectAtIndex:i] drawInRect:CGRectMake(0,drawImage.image.size.height*i,newSize.width,newSize.height)];
        }
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        NSData *imageData=UIImageJPEGRepresentation(newImage,1.0);
        UIGraphicsEndImageContext();
        if(imageData!=nil && ![stylingView isHidden]){
            [self PostUploadImage:imageData];
            postStylusView.hidden = false;
        }
        if(textInputView.text.length!=0 && ![keyboardView isHidden]){
            self.activityController = [ISActivityOverlayController presentActivityOverViewController:self withLabel:@"Uploading text prescription..."];
            [NSThread detachNewThreadSelector:@selector(PostUploadText:) toTarget:self withObject:textInputView.text];
        }
        if(drawImage.image==nil && textInputView.text.length==0){
            proAlertView* alert= [[proAlertView alloc] initWithTitle:nil message:@"No files to upload!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
            [alert show];
            [alert release];
            if (self.activityController) {
                [self.activityController dismissActivity];
                self.activityController = Nil;
            }
        }
    }
    else{
        proAlertView* alert= [[proAlertView alloc] initWithTitle:@"Error!" message:@"Please select both a pharmacy and a medicine follow up above before proceeding." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
        [alert show];
        [alert release];
    }
}

-(IBAction)cancelChanges{
    proAlertView *alert = [[proAlertView alloc] initWithTitle:@"Delete?" message:@"Proceed?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"YES",nil];
    [alert setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
    [alert show];
    [alert release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex==1){
        if(alertView==saveAlertView){
            if (!self.activityController) {
                self.activityController = [ISActivityOverlayController presentActivityOverViewController:self withLabel:@"Submitting order..."];
            }
            
            NSString* dataToPost = @"{\"medicine\":[";
            
            for (int i=0; i<self.currPharmacyOrderArray.count; i++) {
                NSString* dosageFormStr = [NSString stringWithFormat:@"{\"DosageFormId\":%d",[[(PharmacyOrder*)[self.currPharmacyOrderArray objectAtIndex:i] dosage_form_id] integerValue]];
                NSString* dosageInsStr = [NSString stringWithFormat:@",\"DosageInsId\":%d",[[(PharmacyOrder*)[self.currPharmacyOrderArray objectAtIndex:i] dosage_ins_id] integerValue]];
                NSString* dosageIdStr = [NSString stringWithFormat:@",\"DosageId\":%d",[[(PharmacyOrder*)[self.currPharmacyOrderArray objectAtIndex:i] dosage_id] integerValue]];
                NSString* followUpIdStr = [NSString stringWithFormat:@",\"Followupid\":%d",[[(PharmacyOrder*)[self.currPharmacyOrderArray objectAtIndex:i] followup_id] integerValue]];
                NSString* brandIdStr = [NSString stringWithFormat:@",\"BrandID\":%d",[[(PharmacyOrder*)[self.currPharmacyOrderArray objectAtIndex:i] brand_id] integerValue]];
                NSString* genericNameStr = [NSString stringWithFormat:@",\"GenericName\":\"%@\"",[(PharmacyOrder*)[self.currPharmacyOrderArray objectAtIndex:i] Generic]];
                NSString* brandNameStr = [NSString stringWithFormat:@",\"BrandName\":\"%@\"",[(PharmacyOrder*)[self.currPharmacyOrderArray objectAtIndex:i] brand_name]];
                NSString* dosageNameStr = [NSString stringWithFormat:@",\"DosageName\":\"%@\"",[(PharmacyOrder*)[self.currPharmacyOrderArray objectAtIndex:i] dosage]];
                NSString* dosFrmNameStr = [NSString stringWithFormat:@",\"DosageFromName\":\"%@\"",[(PharmacyOrder*)[self.currPharmacyOrderArray objectAtIndex:i] dosage_form]];
                NSString* genericsIdStr = [NSString stringWithFormat:@",\"GenericsID\":%d}",[[(PharmacyOrder*)[self.currPharmacyOrderArray objectAtIndex:i] generic_id] integerValue]];
                dataToPost = [dataToPost stringByAppendingString:dosageFormStr];
                dataToPost = [dataToPost stringByAppendingString:dosageInsStr];
                dataToPost = [dataToPost stringByAppendingString:dosageIdStr];
                dataToPost = [dataToPost stringByAppendingString:followUpIdStr];
                dataToPost = [dataToPost stringByAppendingString:brandIdStr];
                dataToPost = [dataToPost stringByAppendingString:genericNameStr];
                dataToPost = [dataToPost stringByAppendingString:brandNameStr];
                dataToPost = [dataToPost stringByAppendingString:dosageNameStr];
                dataToPost = [dataToPost stringByAppendingString:dosFrmNameStr];
                dataToPost = [dataToPost stringByAppendingString:genericsIdStr];
                dataToPost = [dataToPost stringByAppendingString:@","];
            }
            dataToPost = [dataToPost substringToIndex:(dataToPost.length-1)];
            NSString* pharmacyIdStr = [NSString stringWithFormat:@",\"PharmacyID\":%d",[[(Pharmacy*)[self.pharmacyDtls objectAtIndex:currentPharmacyGlobalIndex-1] SubTenantId] integerValue]];
            NSString* followUpStr = [NSString stringWithFormat:@",\"Followup\":%d}",[[(FollowUp*)[self.followUpDtls objectAtIndex:currentMedFollowUpGlobalIndex-1] FollowupId] integerValue]];
            NSString* userRoleStr = [NSString stringWithFormat:@",\"UserRoleID\":%@",[DataExchange getUserRoleId]];
            NSString* mrnoStr = [NSString stringWithFormat:@"],\"Mrno\":\"%d\"",self.mrNo];
            
            dataToPost = [dataToPost stringByAppendingString:mrnoStr];
            dataToPost = [dataToPost stringByAppendingString:pharmacyIdStr];
            dataToPost = [dataToPost stringByAppendingString:userRoleStr];
            dataToPost = [dataToPost stringByAppendingString:followUpStr];
            
            NSURL* myUrl = [[[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://%@PostPharmacyOrder",[DataExchange getbaseUrl]]] autorelease];
            NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
            [request setURL:myUrl];
            [request setHTTPMethod:@"POST"];
            [request setAllHTTPHeaderFields:[[[NSDictionary alloc] initWithObjects:[[[NSArray alloc] initWithObjects:@"application/json",@"utf-8",[DataExchange getDomainUrl],[NSString stringWithFormat:@"%d",dataToPost.length], nil] autorelease] forKeys:[[[NSArray alloc] initWithObjects:@"Content-Type",@"charset",@"Host",@"Content-Length", nil]autorelease]]autorelease]];
            [request setHTTPBody:[NSData dataWithBytes:[dataToPost UTF8String] length:[dataToPost lengthOfBytesUsingEncoding:NSUTF8StringEncoding]]]; 
            postOrderConnection = [[[NSURLConnection alloc] initWithRequest:request delegate:self] autorelease];
            if (!postOrderConnection) {
                proAlertView *alert = [[proAlertView alloc] initWithTitle:@"No Internet Connection" message:@"Please Try Again Later" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
                [alert setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
                [alert show];
                [alert release];
            }
        }
        else if(alertView==deleteAlertView){
            [self.currPharmacyOrderArray removeObjectAtIndex:currentOrderDeleteTag];
            if(self.currPharmacyOrderArray.count<8){
                [UIView beginAnimations:nil context:NULL];
                [UIView setAnimationDuration:0.5];
                slidingView.frame = CGRectMake(slidingView.frame.origin.x, slidingView.frame.origin.y - 39, slidingView.frame.size.width, slidingView.frame.size.height);
                [UIView commitAnimations];
            }
            [self addPharmacyOrder];
        }
        else if(alertView==stopVidPostAlertView){
            if(![videoView isHidden]){
                [videoConnection cancel];
                CGRect frame = videoPostProgressBar.frame;
                frame.size.width = 461;
                [videoPostProgressBar setFrame:frame];
                [progressLbl setText:@"Sending cancelled!"];
                [UIView beginAnimations:nil context:NULL];
                [UIView setAnimationDelay:1.0];
                [UIView setAnimationDuration:0.1];
                //do some animation
                postVideoView.hidden = true;
                [UIView commitAnimations];
            }else if(![stylingView isHidden]){
                [stylusPicConnection cancel];
                CGRect frame = stylusProgressBar.frame;
                frame.size.width = 461;
                [stylusProgressBar setFrame:frame];
                [stylusProgressLbl setText:@"Sending cancelled!"];
                [UIView beginAnimations:nil context:NULL];
                [UIView setAnimationDelay:1.0];
                [UIView setAnimationDuration:0.1];
                //do some animation
                postStylusView.hidden = true;
                [UIView commitAnimations];
            }
        }
        else if(alertView == closeScreenAlertView){
            [self dismissModalViewControllerAnimated:YES];
        }
        else
        switch (currentViewIndex) {
            case 0:
                 textInputView.text = @"";
                break;
            case 1:
               drawImage.image = nil;
                break;
            case 2:
               
                break;
            case 3:
                videoData = nil;
                break;
            case 4:
                
                break;
            default:
                break;
        }
    }
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

#pragma mark print

-(void)printdoc{
    if(currentMedFollowUpGlobalIndex==0 || currentPharmacyGlobalIndex==0){
        proAlertView *alert = [[proAlertView alloc] initWithTitle:nil message:@"Please select both Pharmacy and Follow-Up above before proceeding" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
        [alert show];
        [alert release];
        return;
    }
    
    // create top header
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(1024, 748),YES,0.0f);
    CGContextRef contextT = UIGraphicsGetCurrentContext();
    [self.view.layer renderInContext:contextT];
    UIImage *viewSnapshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(1024, 119),YES,0.0f);
    [viewSnapshot drawInRect:CGRectMake(0, -44, 1024, 748)];
    UIImage *topHeader = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImage* finalImage=nil;
    switch (currentViewIndex) {
        case 0:
            if(textInputView.text.length>0){
                UIGraphicsBeginImageContextWithOptions(CGSizeMake(1024, 1448),YES,0.0f);// A4 size
                CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(), [[UIColor whiteColor] CGColor]);
                CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, 1024, 1448));
                CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(), [[UIColor blackColor] CGColor]);
                [topHeader drawInRect:CGRectMake(0, 20, 1024, 119)];
                [textInputView.text drawInRect:CGRectMake(40, 200, 944, 1000) withFont:[UIFont boldSystemFontOfSize:18.0] lineBreakMode:UILineBreakModeWordWrap];
                [btnMedicineGlobal.titleLabel.text drawInRect:CGRectMake(0, 1300, 512, 100) withFont:[UIFont boldSystemFontOfSize:20] lineBreakMode:UILineBreakModeWordWrap alignment:UITextAlignmentCenter];
                [btnPharmacyGlobal.titleLabel.text drawInRect:CGRectMake(512, 1300, 512, 100) withFont:[UIFont boldSystemFontOfSize:20] lineBreakMode:UILineBreakModeWordWrap alignment:UITextAlignmentCenter];
                finalImage = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
            }
            else{
                proAlertView* alert= [[proAlertView alloc] initWithTitle:@"Alert!" message:@"Please enter some text to print." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [alert setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
                [alert show];
                [alert release];
            }
            break;
        case 1:
            if (drawImage.image){
                UIGraphicsBeginImageContextWithOptions(CGSizeMake(1024, 1448),YES,0.0f);// A4 size
                CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(), [[UIColor whiteColor] CGColor]);
                CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, 1024, 1448));
                [topHeader drawInRect:CGRectMake(0, 20, 1024, 119)];
                [drawImage.image drawInRect:CGRectMake(114, 140, 800, 1100)];
                CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(), [[UIColor blackColor] CGColor]);
                [btnMedicineGlobal.titleLabel.text drawInRect:CGRectMake(0, 1300, 512, 100) withFont:[UIFont boldSystemFontOfSize:20] lineBreakMode:UILineBreakModeWordWrap alignment:UITextAlignmentCenter];
                [btnPharmacyGlobal.titleLabel.text drawInRect:CGRectMake(512, 1300, 512, 100) withFont:[UIFont boldSystemFontOfSize:20] lineBreakMode:UILineBreakModeWordWrap alignment:UITextAlignmentCenter];
                finalImage = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
            }
            else{
                proAlertView* alert= [[proAlertView alloc] initWithTitle:@"Alert!" message:@"Please write some text to print." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [alert setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
                [alert show];
                [alert release];
            }
            break;
        case 3:
            if (self.currPharmacyOrderArray.count>0){
                UIGraphicsBeginImageContextWithOptions(CGSizeMake(1024, 1448),YES,0.0f);// A4 size
                CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(), [[UIColor whiteColor] CGColor]);
                CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, 1024, 1448));
                [topHeader drawInRect:CGRectMake(0, 0, 1024, 119)];
                NSArray* wired = [[NSBundle mainBundle] loadNibNamed:@"PrescriptionDataRow" owner:self options:nil];
                PrescriptionDataRow* row = (PrescriptionDataRow*)[wired objectAtIndex:0];
                [[row imageForView] drawInRect:CGRectMake(0, 200, 1024, 100)];
                for (int i=0; i<self.currPharmacyOrderArray.count; i++) {
                    row.brandStr = [(PharmacyOrder*)[currPharmacyOrderArray objectAtIndex:i] brand_name];
                    row.genericStr = [(PharmacyOrder*)[currPharmacyOrderArray objectAtIndex:i] Generic];
                    row.dosageStr = [(PharmacyOrder*)[currPharmacyOrderArray objectAtIndex:i] dosage];
                    row.dosageFrmStr = [(PharmacyOrder*)[currPharmacyOrderArray objectAtIndex:i] dosage_form];
                    row.instructionStr = [(PharmacyOrder*)[currPharmacyOrderArray objectAtIndex:i] instruction];
                    NSString* str = [NSString stringWithFormat:@"%d %@",[[(PharmacyOrder*)[currPharmacyOrderArray objectAtIndex:i] durationno] integerValue],[(PharmacyOrder*)[currPharmacyOrderArray objectAtIndex:i] durationunits]];
                    if([[(PharmacyOrder*)[currPharmacyOrderArray objectAtIndex:i] durationno] integerValue]==0)
                        str = @"";
                    row.followUpStr = str;
                    [row reloadView];
                    [[row imageForView] drawInRect:CGRectMake(0, 300 + 100*i, 1024, 100)];
                }
                CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(), [[UIColor blackColor] CGColor]);
                [btnMedicineGlobal.titleLabel.text drawInRect:CGRectMake(1300, 1300, 512, 100) withFont:[UIFont boldSystemFontOfSize:20] lineBreakMode:UILineBreakModeWordWrap alignment:UITextAlignmentCenter];
                [btnPharmacyGlobal.titleLabel.text drawInRect:CGRectMake(1300, 1300, 512, 100) withFont:[UIFont boldSystemFontOfSize:20] lineBreakMode:UILineBreakModeWordWrap alignment:UITextAlignmentCenter];
                finalImage = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
            }
            else{
                proAlertView* alert= [[proAlertView alloc] initWithTitle:@"Alert!" message:@"Please add some prescriptions to print." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [alert setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
                [alert show];
                [alert release];
            }
            break;
        default:
            break;
    }
# if 0
    UIViewController* controller = [[UIViewController alloc] init];
    UIImageView* imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 400, 600)];
    [imgView setImage:finalImage];
    [controller.view addSubview:imgView];
    popover = [[UIPopoverController alloc] initWithContentViewController:controller];
    popover.popoverContentSize = CGSizeMake(400, 600);
    popover.delegate = self;
    [popover presentPopoverFromRect:CGRectMake(0, 0, 20, 20) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    return;
#endif

    NSData * imageData = UIImageJPEGRepresentation(finalImage,1.0);
    UIPrintInteractionController *pic = [UIPrintInteractionController sharedPrintController];
    if  (pic && [UIPrintInteractionController canPrintData:imageData] ) {
        pic.delegate = self;
        UIPrintInfo *printInfo = [UIPrintInfo printInfo];
        printInfo.outputType = UIPrintInfoOutputGeneral;
        printInfo.jobName = @"mCura Doctor Note";
        printInfo.duplex = UIPrintInfoDuplexNone;
        pic.printInfo = printInfo;
        pic.showsPageRange = YES;
        pic.printingItem = imageData;
        void (^completionHandler)(UIPrintInteractionController *, BOOL, NSError *) =
        ^(UIPrintInteractionController *pic, BOOL completed, NSError *error) {
            if (!completed && error)
                NSLog(@"FAILED! due to error in domain %@ with error code %u",
                      error.domain, error.code);
        };
        // iPad only printing
        [pic presentAnimated:YES completionHandler:completionHandler];
    }
    else{
        proAlertView* alert= [[proAlertView alloc] initWithTitle:@"Sorry!" message:@"Printer unavailable! Please connect to a printer and try again." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
        [alert show];
        [alert release];
    }
}

-(IBAction)openDrugsIndex:(id)sender{
    NSInteger index = [sender tag]-101;
   
    DrugViewController* controller = [[DrugViewController alloc] initWithNibName:@"DrugViewController" bundle:nil];
    controller.pharmacyParentController = self;
    controller.selectedGeneric= currentGeneric;
    controller.arrBrands = self.brandDtlsForDrugView;
    controller.isparentView=YES;
    if(index==1)
        controller.selectedBrand = currentBrand;
    [self presentModalViewController:controller animated:YES];
    [controller release];
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
