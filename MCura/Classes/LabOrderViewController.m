//
//  LabOrderViewController.m
//  mCura
//
//  Created by Aakash Chaudhary on 02/04/12.
//  Copyright (c) 2012 aakash272@gmail.com. All rights reserved.
//

#import "LabOrderViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "Response.h"
#import "DataExchange.h"
#import "Lab.h"
#import "Schedule.h"
#import "LabTestList.h"
#import "LabPackage.h"
#import "LabGroupTest.h"
#import "SubTenant.h"
#import "NSData+Base64.h"
#import "Utilities.h"
#import "Base64.h"
#import "PharmacyViewController.h"
#import "LabOrderCell.h"
#import "LabTestList+Parse.h"
#import "LabGroupTest+Parse.h"
#define min(X,Y) (X<Y?X:Y)
#define maxSize 20

@implementation LabOrderViewController
@synthesize delegate,tblFacility,mrNo,activityController,tblGroups,tblPackages,tblTestList;
@synthesize userRoleId,patient,patientNumber,patCity;
@synthesize docAddress,docName,docNumber,lastPackageId,expandedGroupIndexPath;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    tblFacility.layer.cornerRadius = 10;
    tblGroups.layer.cornerRadius = 10;
    tblPackages.layer.cornerRadius = 10;
    tblTestList.layer.cornerRadius = 10;
    stylusScrollView.layer.cornerRadius = 10;
    textInputView.layer.cornerRadius = 10;
    scrollBG.layer.cornerRadius = 5;
    scrollFG.layer.cornerRadius = 5;
    [scrollFG addTarget:self action:@selector(wasDragged:withEvent:) forControlEvents:UIControlEventTouchDragInside];
    currentSchedule=0;
    
    _service = [[_GMDocService alloc] init];
    [_service getSubTenantIdInvocation:userRoleId delegate:self];
    
    datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 216.0)];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker addTarget:self action:@selector(dateChanged) forControlEvents:UIControlEventValueChanged];
    drawImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, handwritingView.frame.size.width, handwritingView.frame.size.height)];
    [handwritingView addSubview:drawImage];
    NSDateFormatter *df = [[[NSDateFormatter alloc] init] autorelease];
    [df setDateFormat:@"dd-MM-yyyy"];
    patientAgeLblT.text = [PharmacyViewController AgeFromString:[df stringFromDate:[PharmacyViewController mfDateFromDotNetJSONString:(![self.patient.patDOB isKindOfClass:[NSNull class]]?self.patient.patDOB:@"")]]];
    patientMobileLblT.text = patientNumber;
    patientNameLbl.text = self.patient.patName;
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
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	dateFormatter.dateFormat=@"dd MMM, YYYY";
    NSString *currentTime=[dateFormatter stringFromDate:[NSDate date]];
	[dateBtn setTitle:[NSString stringWithFormat:@"%@",currentTime] forState:UIControlStateNormal];
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(keyboardDidShow:) 
                                                 name:UIKeyboardDidShowNotification 
                                               object:self.view.window];
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(keyboardDidHide:) 
                                                 name:UIKeyboardDidHideNotification 
                                               object:self.view.window];
    [topTabBar setImage:[UIImage imageNamed:@"dataD.png"] forSegmentAtIndex:0];
    [topTabBar setImage:[UIImage imageNamed:@"keyboardD.png"] forSegmentAtIndex:1];
    [topTabBar setImage:[UIImage imageNamed:@"penD.png"] forSegmentAtIndex:2];
    for (int i =0; i<maxSize; i++) {
        packagesSelectedArray[i] = false;
        groupsSelectedArray[i] = false;
        testsSelectedArray[i] = false;
        packagesExpandedArray[i]=false;
    }
    expandedGroupTableIndexPath=-1;
    currentFacilitySelectedIndex = -1;
    oldExpandedIndex = -1;
    currentStylistPageIndex=0;
    arrayOfStylistImages = [[NSMutableArray alloc] init];
    [arrayOfStylistImages addObject:[[UIImage alloc] init]];
    drawImage.image = (UIImage*)[arrayOfStylistImages lastObject];
    self.lastPackageId = @"-1";
    self.expandedGroupIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
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

-(void)viewWillAppear:(BOOL)animated{
    self.activityController = [ISActivityOverlayController presentActivityOverViewController:self withLabel:@"Loading..."];
    if (dateObject != nil)
        [datePicker setDate:dateObject animated:YES];
    else
        [datePicker setDate:[NSDate date] animated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
	return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];    
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
    [arrayOfStylistImages replaceObjectAtIndex:currentStylistPageIndex withObject:drawImage.image];
    tblFacility.hidden = true;
    [datePicker removeFromSuperview];
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

- (void)wasDragged:(UIButton *)button withEvent:(UIEvent *)event{
	// get the touch
	UITouch *touch = [[event touchesForView:button] anyObject];
	// get delta
	CGPoint previousLocation = [touch previousLocationInView:button];
	CGPoint location = [touch locationInView:button];
	CGFloat delta_y = location.y - previousLocation.y;
	// move button
    if(button.center.y + delta_y >= 80 && button.center.y + delta_y <= 464)
        button.center = CGPointMake(button.center.x, button.center.y + delta_y);
    [stylusScrollView setContentOffset:CGPointMake(0, 720.0*(button.center.y-80)/384) animated:NO];
}

#pragma mark Table view data source

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(tableView==tblPackages)
        return packagesArray.count;
    else
        return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(tableView == self.tblFacility)
        return [labsArray count];
    else if(tableView == self.tblPackages){
        if(packagesExpandedArray[section])
            return [(NSMutableArray*)[arrayOfGroupsArrays objectAtIndex:section] count]+1;
        else
            return 1;
    }
    else if(tableView == self.tblGroups)
        return [groupsArray count];
    else if(tableView == self.tblTestList)
        return [testListArray count];
    else
        return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView==tblPackages){
        int tests =0;
        if(indexPath.row>0 && self.expandedGroupIndexPath.section==indexPath.section && self.expandedGroupIndexPath.row==indexPath.row)
            tests = [[(LabGroupTest*)[(NSMutableArray*)[arrayOfGroupsArrays objectAtIndex:indexPath.section] objectAtIndex:indexPath.row-1] arrayOfTests] count];
        if(indexPath.row!=0)
            tests+=[(NSMutableArray*)[arrayOfPackageTestsArray objectAtIndex:indexPath.section] count];
        return 44 + tests*44;
    }
    else if(tableView==tblGroups) {
        int tests =0;
        if(expandedGroupTableIndexPath==indexPath.row)
            tests = [[(LabGroupTest*)[groupsArray objectAtIndex:indexPath.row] arrayOfTests] count];
        return 44 + tests*44;
    }
    else
        return 44;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    static NSString *PackageCellId = @"CellPackage";
    
    if(tableView == tblFacility){
        UITableViewCell *cell = [tblFacility dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        }
        cell.textLabel.text = [(Lab*)[labsArray objectAtIndex:indexPath.row] SubTenantName];
        
        return cell;
    }
    else if(tableView == tblPackages){
        LabOrderCell *cell = [tblPackages dequeueReusableCellWithIdentifier:PackageCellId];
//        if (cell == nil) {
            cell = [[[LabOrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:PackageCellId] autorelease];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.clipsToBounds = YES;
//        }
        cell.textLabel.autoresizingMask = UIViewAutoresizingNone;

        cell.indentationLevel = 5;
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = [(LabPackage*)[packagesArray objectAtIndex:indexPath.section] Packagename];
                if([(NSMutableArray*)[arrayOfGroupsArrays objectAtIndex:indexPath.section] count]!=0){
                    UIButton* checkButton = (UIButton*)[cell viewWithTag:indexPath.section*100 + indexPath.row+1];
                    if(checkButton==nil){
                        checkButton = [UIButton buttonWithType:UIButtonTypeCustom];
                        [checkButton addTarget:self action:@selector(toggleSectionPackages:) forControlEvents:UIControlEventTouchUpInside];
                        [checkButton setFrame:CGRectMake(15, 7, 30, 30)];
                        [checkButton setTag:indexPath.section*100 + indexPath.row+1];
                        [cell addSubview:checkButton];
                    }
                    if(packagesExpandedArray[indexPath.section]){
                        [checkButton setBackgroundImage:[UIImage imageNamed:@"unexpand.png"] forState:UIControlStateNormal];
                        cell.accessoryType = UITableViewCellAccessoryCheckmark;
                    }
                    else{
                        [checkButton setBackgroundImage:[UIImage imageNamed:@"expand.png"] forState:UIControlStateNormal];
                        cell.accessoryType = UITableViewCellAccessoryNone;
                    }
                    if (packagesSelectedArray[indexPath.section])
                        cell.accessoryType = UITableViewCellAccessoryCheckmark;
                    else
                        cell.accessoryType = UITableViewCellAccessoryNone;
                }
                break;
            default:
                cell.indentationLevel = 8;
                cell.textLabel.text = [(LabGroupTest*)[(NSMutableArray*)[arrayOfGroupsArrays objectAtIndex:indexPath.section] objectAtIndex:indexPath.row-1] LabGrpName];
                CGRect frame = CGRectMake(100, 0, 200, 40);
                int numTests = [[(LabGroupTest*)[(NSMutableArray*)[arrayOfGroupsArrays objectAtIndex:indexPath.section] objectAtIndex:indexPath.row-1] arrayOfTests] count];
                if(numTests!=0){
                    UIButton* checkButton = (UIButton*)[cell viewWithTag:indexPath.section*100 + indexPath.row+5000];
                    if(checkButton==nil){
                        checkButton = [UIButton buttonWithType:UIButtonTypeCustom];
                        [checkButton addTarget:self action:@selector(toggleSectionGroup:) forControlEvents:UIControlEventTouchUpInside];
                        [checkButton setFrame:CGRectMake(50, 7, 30, 30)];
                        [checkButton setTag:indexPath.section*100 + indexPath.row+5000];
                        [cell addSubview:checkButton];
                    }
                    if(self.expandedGroupIndexPath.section==indexPath.section && self.expandedGroupIndexPath.row==indexPath.row)
                        [checkButton setBackgroundImage:[UIImage imageNamed:@"unexpand.png"] forState:UIControlStateNormal];
                    else
                        [checkButton setBackgroundImage:[UIImage imageNamed:@"expand.png"] forState:UIControlStateNormal];
                }
                
                if(self.expandedGroupIndexPath.section==indexPath.section && self.expandedGroupIndexPath.row==indexPath.row)
                    for (int i=0; i<numTests; i++) {
                        frame.origin.y += 40;
                        UILabel* temp = [[UILabel alloc] initWithFrame:frame];
                        [temp setBackgroundColor:[UIColor clearColor]];
                        temp.text = [(LabTestList*)[[(LabGroupTest*)[(NSMutableArray*)[arrayOfGroupsArrays objectAtIndex:indexPath.section] objectAtIndex:indexPath.row-1] arrayOfTests] objectAtIndex:i] Testname];
                        [cell addSubview:temp];
                        [temp release];
                    }
                for (int i=0; i<[(NSMutableArray*)[arrayOfPackageTestsArray objectAtIndex:indexPath.section] count]; i++) {
                    frame.origin.y += 40;
                    UILabel* temp = [[UILabel alloc] initWithFrame:frame];
                    [temp setBackgroundColor:[UIColor clearColor]];
                    [temp setFont:[UIFont boldSystemFontOfSize:[UIFont systemFontSize]]];
                    temp.text = [(LabTestList*)[(NSMutableArray*)[arrayOfPackageTestsArray objectAtIndex:indexPath.section] objectAtIndex:i] Testname];
                    [cell addSubview:temp];
                    [temp release];
                }
                break;
        }
        
        return cell;
    }
    else if(tableView == tblGroups){
        LabOrderCell *cell = [tblGroups dequeueReusableCellWithIdentifier:CellIdentifier];
        //if (cell == nil) {
            cell = [[[LabOrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        //}
        if (groupsSelectedArray[indexPath.row]) 
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        else 
            cell.accessoryType = UITableViewCellAccessoryNone;
        cell.indentationLevel = 5;
        cell.clipsToBounds=YES;
        cell.textLabel.text = [(LabGroupTest*)[groupsArray objectAtIndex:indexPath.row] LabGrpName];
        CGRect frame = CGRectMake(70, 0, 200, 40);
        int numTests = [[(LabGroupTest*)[groupsArray objectAtIndex:indexPath.row] arrayOfTests] count];
        if(numTests!=0){
            UIButton* checkButton = (UIButton*)[cell viewWithTag:indexPath.row+5000];
            if(checkButton==nil){
                checkButton = [UIButton buttonWithType:UIButtonTypeCustom];
                [checkButton addTarget:self action:@selector(toggleGroupTblTests:) forControlEvents:UIControlEventTouchUpInside];
                [checkButton setFrame:CGRectMake(15, 7, 30, 30)];
                [checkButton setTag:indexPath.row+5000];
                [cell addSubview:checkButton];
            }
            if(expandedGroupTableIndexPath==indexPath.row)
                [checkButton setBackgroundImage:[UIImage imageNamed:@"unexpand.png"] forState:UIControlStateNormal];
            else
                [checkButton setBackgroundImage:[UIImage imageNamed:@"expand.png"] forState:UIControlStateNormal];
        }
        
        for (int i=0; i<numTests; i++) {
            frame.origin.y += 40;
            UILabel* temp = [[UILabel alloc] initWithFrame:frame];
            [temp setBackgroundColor:[UIColor clearColor]];
            temp.text = [(LabTestList*)[[(LabGroupTest*)[groupsArray objectAtIndex:indexPath.row] arrayOfTests] objectAtIndex:i] Testname];
            [cell addSubview:temp];
            [temp release];
        }
        
        return cell;
    }
    else if(tableView == tblTestList){
        UITableViewCell *cell = [tblTestList dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        cell.textLabel.text = [(LabTestList*)[testListArray objectAtIndex:indexPath.row] Testname];
        if (testsSelectedArray[indexPath.row]) 
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        else 
            cell.accessoryType = UITableViewCellAccessoryNone;
        
        return cell;
    }
    else{
        return nil;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == tblFacility){
        tblFacility.hidden = true;
        currentFacilitySelectedIndex = indexPath.row;
        self.activityController = [ISActivityOverlayController presentActivityOverViewController:self withLabel:@"Loading..."];
        [_service getLabPackageInvocation:userRoleId SubTenantId:[[(Lab*)[labsArray objectAtIndex:currentFacilitySelectedIndex] SubTenantId] stringValue] delegate:self];
        NSString* url = [NSMutableString stringWithFormat:@"%@GetLabTest?LabID=%@&UserRoleID=%@",[DataExchange getbaseUrl],[[(Lab*)[labsArray objectAtIndex:currentFacilitySelectedIndex] SubTenantId] stringValue],[DataExchange getUserRoleId]];
        [_service getStringResponseInvocation:url Identifier:@"GetLabTest" delegate:self];
        [btnFacility.titleLabel setText:[(Lab*)[labsArray objectAtIndex:currentFacilitySelectedIndex] SubTenantName]];
    }
    else if(tableView == tblPackages && indexPath.row==0){
        packagesSelectedArray[indexPath.section] = !packagesSelectedArray[indexPath.section];
        currentPackageSelectedIndex = indexPath.row;
        [tblPackages reloadData];
    }
    else if(tableView == tblGroups){
        groupsSelectedArray[indexPath.row] = !groupsSelectedArray[indexPath.row];
        currentGroupSelectedIndex = indexPath.row;
        [tblGroups reloadData];
    }
    else if(tableView == tblTestList){
        testsSelectedArray[indexPath.row] = !testsSelectedArray[indexPath.row];
        currentTestSelectedIndex = indexPath.row;
        [tblTestList reloadData];
    }
}

-(void)toggleSectionPackages:(id)sender{
    NSInteger index = ([(UIButton*)sender tag] - 1)/100;
    if(index!=oldExpandedIndex)
        packagesExpandedArray[oldExpandedIndex] = false;
    packagesExpandedArray[index] = !packagesExpandedArray[index];
    oldExpandedIndex = index;
    [tblPackages reloadData];
}

-(void)toggleSectionGroup:(id)sender{
    NSInteger section = ([(UIButton*)sender tag] - 5000)/100;
    NSInteger row = ([(UIButton*)sender tag] - 5000)%100;
    if(self.expandedGroupIndexPath.row==row && self.expandedGroupIndexPath.section==section){
        section = 0;
        row = 0;
    }
    self.expandedGroupIndexPath = [NSIndexPath indexPathForRow:row inSection:section];
    [tblPackages reloadData];
}

-(void)toggleGroupTblTests:(id)sender{
    NSInteger row = ([(UIButton*)sender tag] - 5000);
    if(expandedGroupTableIndexPath==row){
        expandedGroupTableIndexPath = -1;
    }
    else
        expandedGroupTableIndexPath = row;
    [tblGroups reloadData];
}

-(IBAction)saveChanges{
    if(currentFacilitySelectedIndex!=-1){
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
            self.activityController = [ISActivityOverlayController presentActivityOverViewController:self withLabel:@"Uploading text notes..."];
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
        proAlertView* alert= [[proAlertView alloc] initWithTitle:@"Error!" message:@"Please select a lab facility before proceeding" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
        [alert show];
        [alert release];
    }
}

-(IBAction)cancelChanges{
    deleteAlertView= [[proAlertView alloc] initWithTitle:@"Delete?" message:@"Proceed?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"YES",nil];
    [deleteAlertView setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
    [deleteAlertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex==1){
        if(alertView==closeAlertView){
            if(self.delegate != nil){
                [self.delegate closePopup];
            }
        }
        else if(alertView==stopStylusPostAlertView){
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
        else if(alertView==deleteAlertView){
            switch (currentViewIndex) {
                case 0:
                    
                    break;
                case 1:
                    textInputView.text = @"";
                    break;
                case 2:
                    drawImage.image = nil;
                    break;
                case 3:
                    
                    break;
                case 4:
                    
                    break;
                default:
                    break;
            }
        }
        else if(alertView==saveAlertView){
            if (!self.activityController) {
                self.activityController = [ISActivityOverlayController presentActivityOverViewController:self withLabel:@"Submitting order..."];
            }
            
            NSString* packageIdStr = [NSString stringWithFormat:@"{\"LabOrderPackages\":[{\"PackageId\":%d",[[(LabPackage*)[packagesArray objectAtIndex:currentPackageSelectedIndex] PackageId] integerValue]];
            NSString* groupIdStr = [NSString stringWithFormat:@"}],\"LabOrderGrps\":[{\"LabGrpId\":%d",[[(LabGroupTest*)[groupsArray objectAtIndex:currentGroupSelectedIndex] LabGrpId] integerValue]];
            NSString* testIdStr = [NSString stringWithFormat:@"}],\"LabOrderTests\":[{\"TestId\":%d",[[(LabTestList*)[testListArray objectAtIndex:currentTestSelectedIndex] TestId] integerValue]];
            NSString* mrnoStr = [NSString stringWithFormat:@"}],\"Mrno\":\"%@\"",self.mrNo];
            NSString* facilityIdStr = [NSString stringWithFormat:@",\"LabFacility\":%d",[[(Lab*)[labsArray objectAtIndex:currentFacilitySelectedIndex] SubTenantId] integerValue]];
            NSString* userRoleStr = [NSString stringWithFormat:@",\"UserRoleID\":%@}",userRoleId];
            NSString* dataToPost = [packageIdStr stringByAppendingString:groupIdStr];
            dataToPost = [dataToPost stringByAppendingString:testIdStr];
            dataToPost = [dataToPost stringByAppendingString:mrnoStr];
            dataToPost = [dataToPost stringByAppendingString:facilityIdStr];
            dataToPost = [dataToPost stringByAppendingString:userRoleStr];
            
            NSURL* myUrl = [[[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://%@PostLabOrder",[DataExchange getbaseUrl]]] autorelease];
            NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
            [request setURL:myUrl];
            [request setHTTPMethod:@"POST"];
            [request setAllHTTPHeaderFields:[[[NSDictionary alloc] initWithObjects:[[[NSArray alloc] initWithObjects:@"application/json",@"utf-8",[DataExchange getDomainUrl],@"81", nil] autorelease] forKeys:[[[NSArray alloc] initWithObjects:@"Content-Type",@"charset",@"Host",@"Content-Length", nil]autorelease]] autorelease]];
            [request setHTTPBody:[NSData dataWithBytes:[dataToPost UTF8String] length:[dataToPost lengthOfBytesUsingEncoding:NSUTF8StringEncoding]]]; 
            postOrderConnection=[[[NSURLConnection alloc] initWithRequest:request delegate:self] autorelease];
            if (!postOrderConnection) {
                proAlertView *alert = [[proAlertView alloc] initWithTitle:@"No Internet Connection" message:@"Please Try Again Later" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
                [alert setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
                [alert show];
                [alert release];
            }
            else{
                
            }
        }
    }else if(alertView==closeOrderAlertView){
        if(self.delegate != nil){
            [self.delegate closePopup];
        }
    }
}

-(IBAction)facilityBtnPressed{
    tblFacility.frame = CGRectMake(tblFacility.frame.origin.x, tblFacility.frame.origin.y, tblFacility.frame.size.width, min(20+44*labsArray.count,200));
    tblFacility.hidden = NO;
}

#pragma mark - Invocations

-(void) getLabInvocationDidFinish:(GetLabInvocation*)invocation
                         withLabs:(NSArray*)Labs
                        withError:(NSError*)error{
    if(!error){
        if(Labs.count==0 && currentSchedule<schedulesArray.count-1){
            currentSchedule++;
            [_service getLabInvocation:userRoleId SchedulesId:[(Schedule*)[schedulesArray objectAtIndex:currentSchedule] schedule_id] forType:1 delegate:self];
        }
        else if(Labs.count==0){
            proAlertView *alert = [[proAlertView alloc] initWithTitle:@"Sorry!" message:@"No Labs Available..." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
            [alert show];
            [alert release];
            if (self.activityController) {
                [self.activityController dismissActivity];
                self.activityController = nil;
            } 
        }        
        else{
            [DataExchange setLabFromResponse:Labs];
            labsArray = [[NSMutableArray alloc] initWithArray:Labs];
            [tblFacility reloadData];
            [btnFacility.titleLabel setText:[(Lab*)[labsArray objectAtIndex:0] SubTenantName]];
            currentFacilitySelectedIndex=0;
            [_service getLabPackageInvocation:userRoleId SubTenantId:[[(Lab*)[labsArray objectAtIndex:currentFacilitySelectedIndex] SubTenantId] stringValue] delegate:self];
            NSString* url = [NSMutableString stringWithFormat:@"%@GetLabTest?LabID=%@&UserRoleID=%@",[DataExchange getbaseUrl],[[(Lab*)[labsArray objectAtIndex:currentFacilitySelectedIndex] SubTenantId] stringValue],[DataExchange getUserRoleId]];
            [_service getStringResponseInvocation:url Identifier:@"GetLabTest" delegate:self];
            url = [NSMutableString stringWithFormat:@"%@GetLabGrp?UserRoleID=%@&LabID=%@",[DataExchange getbaseUrl],[DataExchange getUserRoleId],[[(Lab*)[labsArray objectAtIndex:currentFacilitySelectedIndex] SubTenantId] stringValue]];
            [_service getStringResponseInvocation:url Identifier:@"GetLabGroups" delegate:self];
        }
    }
}

-(void) GetLabPackageInvocationDidFinish:(GetLabPackageInvocation *)invocation 
                            withPackages:(NSArray *)LabPackages 
                               withError:(NSError *)error{
    if(!error){
        if(LabPackages.count==0){
            proAlertView *alert = [[proAlertView alloc] initWithTitle:@"Sorry!" message:@"No Packages Available..." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
            [alert show];
            [alert release];
            if (self.activityController) {
                [self.activityController dismissActivity];
                self.activityController = nil;
            } 
            return;
        }
        packagesArray = [[NSMutableArray alloc] initWithArray:LabPackages];
        arrayOfGroupsArrays = [[NSMutableArray alloc] init];
        arrayOfPackageTestsArray = [[NSMutableArray alloc] init];
        for(int i=0;i<packagesArray.count;i++){
            [arrayOfGroupsArrays addObject:[[NSMutableArray alloc] init]];
            [arrayOfPackageTestsArray addObject:[[NSMutableArray alloc] init]];
            [_service getLabGroupTestInvocation:userRoleId PackageId:[[(LabPackage*)[packagesArray objectAtIndex:i] PackageId] stringValue] delegate:self];
            NSString* url = [NSMutableString stringWithFormat:@"%@GetLabTestListByPKG?PackageId=%@&UserRoleID=%@",[DataExchange getbaseUrl],[(LabPackage*)[packagesArray objectAtIndex:i] PackageId],[DataExchange getUserRoleId]];
            [_service getStringResponseInvocation:url Identifier:[NSString stringWithFormat:@"GetPackageTests:%d",[[(LabPackage*)[packagesArray objectAtIndex:i] PackageId] integerValue]] delegate:self];
        }
        self.lastPackageId = [NSString stringWithFormat:@"%d",[[(LabPackage*)[packagesArray objectAtIndex:LabPackages.count-1] PackageId] integerValue]];
        [tblPackages reloadData];
    }
}

-(void)GetStringInvocationDidFinish:(GetStringInvocation *)invocation 
                 withResponseString:(NSString *)responseString
                     withIdentifier:(NSString *)identifier
                          withError:(NSError *)error{
    if(!error){
        if([identifier isEqualToString:@"GetLabGroups"]){
            NSArray* resultsd = [responseString JSONValue];
            NSArray *response = [LabGroupTest LabGroupTestFromArray:resultsd];
            groupsArray = [[NSMutableArray alloc] initWithArray:response];
            for (int i=0; i<groupsArray.count; i++) {
                NSString* url = [NSMutableString stringWithFormat:@"%@GetLabTestListByGroup?LabGrpId=%@&UserRoleID=%@",[DataExchange getbaseUrl],[[(LabGroupTest*)[groupsArray objectAtIndex:i] LabGrpId] stringValue],[DataExchange getUserRoleId]];
                [_service getStringResponseInvocation:url Identifier:@"GetLabGroupsTest" delegate:self];
            }
            tblGroups.frame = CGRectMake(tblGroups.frame.origin.x, tblGroups.frame.origin.y, tblGroups.frame.size.width, min(20+132*groupsArray.count,400));
        }
        else if([identifier isEqualToString:@"GetLabGroupsTest"]){
            NSArray* resultsd = [responseString JSONValue];
            NSArray *response = [LabTestList LabTestListFromArray:resultsd];
            if(resultsd.count==0)
                return;
            for(int j=0;j<[groupsArray count];j++){
                NSString* str = [NSString stringWithFormat:@"%d",[[(LabGroupTest*)[groupsArray objectAtIndex:j] LabGrpId] integerValue]];
                if([str isEqualToString:[[(LabTestList*)[response objectAtIndex:0] TestId] stringValue]]){
                    ((LabGroupTest*)[groupsArray objectAtIndex:j]).arrayOfTests = [[NSMutableArray alloc] initWithArray:response];
                    break;
                }
            }
            [tblGroups reloadData];
        }
        else if([[[identifier componentsSeparatedByString:@":"] objectAtIndex:0] isEqualToString:@"GetPackageTests"]){
            NSArray* resultsd = [responseString JSONValue];
            NSArray *response = [LabTestList LabTestListFromArray:resultsd];
            for (int i=0; i<packagesArray.count; i++) {
                if([[[(LabPackage*)[packagesArray objectAtIndex:i] PackageId] stringValue] isEqualToString:[[identifier componentsSeparatedByString:@":"] objectAtIndex:1]]){
                    [arrayOfPackageTestsArray replaceObjectAtIndex:i withObject:response];
                }
            }
        }
        else if([identifier isEqualToString:@"GetLabTest"]){
            NSArray* resultsd = [responseString JSONValue];
            NSArray *response = [LabTestList LabTestListFromArray:resultsd];
            testListArray = [[NSMutableArray alloc] initWithArray:response];
            tblTestList.frame = CGRectMake(tblTestList.frame.origin.x, tblTestList.frame.origin.y, tblTestList.frame.size.width, min(20+44*testListArray.count,400));
            [tblTestList reloadData];
        }
    }
}

-(void) GetLabGroupTestInvocationDidFinish:(GetLabGroupTestInvocation *)invocation
                         withLabGroupTests:(NSArray *)LabGroupTests 
                             withPackageId:(NSString *)packageId
                                 withError:(NSError *)error{
    if(!error){
        if(LabGroupTests.count==0){
            for(int i=0;i<packagesArray.count;i++){
                if([[[(LabPackage*)[packagesArray objectAtIndex:i] PackageId] stringValue] isEqualToString:packageId]){
                    proAlertView *alert = [[proAlertView alloc] initWithTitle:@"Sorry!" message:[NSString stringWithFormat:@"No Lab Groups Available for %@",[(LabPackage*)[packagesArray objectAtIndex:i] Packagename]] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
                    [alert show];
                    [alert release];
                    break;
                }
            }
            if (self.activityController) {
                [self.activityController dismissActivity];
                self.activityController = nil;
            } 
            return;
        }
        for(int i=0;i<packagesArray.count;i++){
            if([[[(LabPackage*)[packagesArray objectAtIndex:i] PackageId] stringValue] isEqualToString:packageId]){
                [arrayOfGroupsArrays replaceObjectAtIndex:i withObject:LabGroupTests];
                for(int j=0;j<LabGroupTests.count;j++){
                    [_service getLabTestListInvocation:userRoleId PackageId:packageId GroupId:[[(LabGroupTest*)[LabGroupTests objectAtIndex:j] LabGrpId] stringValue] delegate:self];
                }
                break;
            }
        }
        if (arrayOfGroupsArrays.count==packagesArray.count && self.activityController) {
            [self.activityController dismissActivity];
            self.activityController = nil;
        }
    }
}

-(void) GetLabTestListInvocationDidFinish:(GetLabTestListInvocation *)invocation 
                             withLabTests:(NSArray *)LabTests 
                            withPackageId:(NSString *)packageId 
                              withGroupId:(NSString *)grpId 
                                withError:(NSError *)error{
    if(!error){
        if(LabTests.count==0){
            for(int i=0;i<packagesArray.count;i++){
                if([[[(LabPackage*)[packagesArray objectAtIndex:i] PackageId] stringValue] isEqualToString:packageId]){
                    proAlertView *alert = [[proAlertView alloc] initWithTitle:@"Sorry!" message:[NSString stringWithFormat:@"No Lab Tests Available for %@",[(LabPackage*)[packagesArray objectAtIndex:i] Packagename]] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                   [alert setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
                   [alert show];
                   [alert release];
                    break;
                }
            }
            if (self.activityController) {
                [self.activityController dismissActivity];
                self.activityController = nil;
            } 
            return;
        }
        for(int i=0;i<packagesArray.count;i++){
            if([[[(LabPackage*)[packagesArray objectAtIndex:i] PackageId] stringValue] isEqualToString:packageId]){
                for(int j=0;j<[(NSMutableArray*)[arrayOfGroupsArrays objectAtIndex:i] count];j++){
                    NSString* str = [NSString stringWithFormat:@"%d",[[(LabGroupTest*)[(NSMutableArray*)[arrayOfGroupsArrays objectAtIndex:i] objectAtIndex:j] LabGrpId] integerValue]];
                    if([str isEqualToString:grpId]){
                        ((LabGroupTest*)[(NSMutableArray*)[arrayOfGroupsArrays objectAtIndex:i] objectAtIndex:j]).arrayOfTests = [[NSMutableArray alloc] initWithArray:LabTests];
                        break;
                    }
                }
            }
        }
        if([packageId isEqualToString:self.lastPackageId]){
            [tblPackages reloadData];
            if (self.activityController) {
                [self.activityController dismissActivity];
                self.activityController = nil;
            }
        }
    }
}

-(void)GetSubtenIdInvocationDidFinish:(GetSubtenIdInvocation *)invocation 
                     withSubTenantIds:(NSArray *)subTenantIds
                            withError:(NSError *)error{
    if(!error){
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:[NSDate date]];
        currentYear = [components year];
        currentMonth = [components month];
        currentDay = [components day];
        NSString* monthStr=@"";
        NSString* dayStr = [NSString stringWithFormat:@"%d",currentDay];
        if(currentDay<10)
            dayStr = [@"0" stringByAppendingString:dayStr];
        switch (currentMonth) {
            case 1:
                monthStr = @"jan";
                break;
            case 2:
                monthStr = @"feb";
                break;
            case 3:
                monthStr = @"mar";
                break;
            case 4:
                monthStr = @"apr";
                break;
            case 5:
                monthStr = @"may";
                break;
            case 6:
                monthStr = @"jun";
                break;
            case 7:
                monthStr = @"jul";
                break;
            case 8:
                monthStr = @"aug";
                break;
            case 9:
                monthStr = @"sep";
                break;
            case 10:
                monthStr = @"oct";
                break;
            case 11:
                monthStr = @"nov";
                break;
            case 12:
                monthStr = @"dec";
                break;    
            default:
                break;
        }
        subTenIdString = [[(SubTenant*)[subTenantIds objectAtIndex:0] SubTenantId] stringValue];
        NSString* currentDateString = [NSString stringWithFormat:@"%@-%@-%d",dayStr,monthStr,currentYear];
        [_service getSchedule2Invocation:userRoleId SubTenantId:subTenIdString CurrentDate:currentDateString Type:@"3" delegate:self];
    }
}

-(void)getScheduleInvocationDidFinish:(GetScheduleInvocation *)invocation 
                         withSchedule:(NSArray *)schedules 
                            withError:(NSError *)error{
    if(schedules.count==0 && !error){
        if(currentDay>7){
            currentDay -=7;
        }else {
            currentDay=26;
            currentMonth -=1;
        }
        if(currentMonth==0){
            currentYear-=1;
            currentMonth=12;
        }
        NSString* monthStr=@"";
        NSString* dayStr = [NSString stringWithFormat:@"%d",currentDay];
        if(currentDay<10)
            dayStr = [@"0" stringByAppendingString:dayStr];
        switch (currentMonth) {
            case 1:
                monthStr = @"jan";
                break;
            case 2:
                monthStr = @"feb";
                break;
            case 3:
                monthStr = @"mar";
                break;
            case 4:
                monthStr = @"apr";
                break;
            case 5:
                monthStr = @"may";
                break;
            case 6:
                monthStr = @"jun";
                break;
            case 7:
                monthStr = @"jul";
                break;
            case 8:
                monthStr = @"aug";
                break;
            case 9:
                monthStr = @"sep";
                break;
            case 10:
                monthStr = @"oct";
                break;
            case 11:
                monthStr = @"nov";
                break;
            case 12:
                monthStr = @"dec";
                break;    
            default:
                break;
        }
        NSString* currentDateString = [NSString stringWithFormat:@"%@-%@-%d",dayStr,monthStr,currentYear];
        [_service getSchedule2Invocation:userRoleId SubTenantId:subTenIdString CurrentDate:currentDateString Type:@"3" delegate:self];
    }
    else if(!error){
        schedulesArray = [[NSMutableArray alloc] initWithArray:schedules];
        [_service getLabInvocation:userRoleId SchedulesId:[(Schedule*)[schedulesArray objectAtIndex:currentSchedule] schedule_id] forType:1 delegate:self];
    }
}

-(IBAction)cancelCurrStylusPost{
    stopStylusPostAlertView= [[proAlertView alloc] initWithTitle:@"Cancel Post?" message:@"Some progress has been made. Proceed?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes",nil];
    [stopStylusPostAlertView setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
    [stopStylusPostAlertView show];
}

-(IBAction) clickCancel:(id)sender{
    
    if(self.delegate != nil){
        [self.delegate closePopup];
    }
}

-(IBAction) closePopup:(id)sender{
    closeAlertView= [[proAlertView alloc] initWithTitle:@"Close Screen!" message:@"Proceed?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"YES",nil];
    [closeAlertView setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
    [closeAlertView show];
}

- (IBAction)doSegmentSwitch:(id)sender {
    UISegmentedControl *segmentedControl = (UISegmentedControl *) sender;
    NSInteger selectedSegment = segmentedControl.selectedSegmentIndex;
    switch (selectedSegment) {
        case 0:
            dataView.hidden = false;
            keyboardView.hidden = true;
            stylingView.hidden = true;
            currentViewIndex=0;
            break;
        case 1:
            dataView.hidden = true;
            keyboardView.hidden = false;
            stylingView.hidden = true;
            currentViewIndex=1;
            break;
        case 2:
            dataView.hidden = true;
            keyboardView.hidden = true;
            stylingView.hidden = false;
            currentViewIndex=2;
            break;
        default:
            break;
    }
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
    NSString* dataToPost = [NSString stringWithFormat:@"{\"Mrno\":%@,\"LabFacility\":%@,\"UserRoleID\":%@,\"filename\":%@}",self.mrNo,[[(Lab*)[labsArray objectAtIndex:currentFacilitySelectedIndex] SubTenantId] stringValue],userRoleId,response];
    NSURL* myUrl = [[[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://%@PostLabOrder_file",[DataExchange getbaseUrl]]] autorelease];
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

-(IBAction) timePopupBtnPressed{
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	dateFormatter.dateFormat=@"dd MMM, YYYY";
    NSString *currentTime=[dateFormatter stringFromDate:[NSDate date]];
	[dateBtn setTitle:[NSString stringWithFormat:@"%@",currentTime] forState:UIControlStateNormal];
    UIViewController* viewController = [[UIViewController alloc] init];
    [viewController.view addSubview:datePicker];
    popover = [[UIPopoverController alloc] initWithContentViewController:viewController];
    [popover setPopoverContentSize:CGSizeMake(320,216) animated:YES];
    [popover presentPopoverFromRect:dateBtn.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
	[viewController release];
}

-(void)dateChanged{
    dateObject = [datePicker date];
	NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	dateFormatter.dateFormat=@"dd MMM, YYYY";
    NSString *currentTime=[dateFormatter stringFromDate:dateObject];
	[dateBtn setTitle:[NSString stringWithFormat:@"%@",currentTime] forState:UIControlStateNormal];
}

-(IBAction) submitOrder{
    if(currentFacilitySelectedIndex==-1){
        proAlertView *alert = [[proAlertView alloc] initWithTitle:@"Warning!" message:@"Please select a facility before proceeding..." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
        [alert setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
        [alert show];
        [alert release];
        return;
    }
    saveAlertView= [[proAlertView alloc] initWithTitle:nil message:@"Submit Lab Order?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"YES",nil];
    [saveAlertView setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
    [saveAlertView show];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    NSString *newStr = [[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    NSLog(@"---%@",newStr);
    [receivedData appendData:data];
    if(connection==stylusPicConnection){
        [self SuccessToLoadTable:newStr];
        postStylusView.hidden = TRUE;
        proAlertView *alert = [[proAlertView alloc] initWithTitle:@"Success!" message:@"Image posted successfully." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
        [alert setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
        [alert show];
        [alert release];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    if(connection==postOrderConnection){
        closeOrderAlertView = [[proAlertView alloc] initWithTitle:@"Success!" message:@"Order posted successfully." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
        [closeOrderAlertView setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
        [closeOrderAlertView show];
    }
    if (self.activityController) {
		[self.activityController dismissActivity];
		self.activityController = nil;
	}
    [self.delegate labOrderDidSubmit];
}

- (void)connection:(NSURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite{
    if(connection==stylusPicConnection){
        CGRect frame = stylusProgressBar.frame;
        frame.size.width = (totalBytesWritten*461/totalBytesExpectedToWrite);
        [stylusProgressBar setFrame:frame];
        [stylusProgressLbl setText:[NSString stringWithFormat:@"%d kB of %d kB sent (%d%%)",totalBytesWritten/1000,totalBytesExpectedToWrite/1000,(totalBytesWritten*100/totalBytesExpectedToWrite)]];
        if(totalBytesWritten==totalBytesExpectedToWrite)
            [stylusProgressLbl setText:@"Finishing"];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	proAlertView *alert = [[proAlertView alloc] initWithTitle:@"Something Went Wrong" message:@"Please Try Again" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
    [alert setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
    [alert show];
	[alert release];
	return;
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
