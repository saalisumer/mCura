//
//  ScheduleView.m
//  mCura
//
//  Created by Aakash Chaudhary on 07/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ScheduleView.h"
#import "SubTenant.h"
#import <QuartzCore/QuartzCore.h>
#import "SubTenant.h"
#import "Pharmacy.h"
#import "SubTenant.h"
#import "Lab.h"
#import "Schedule.h"
#import "proAlertView.h"
#import "DataExchange.h"
#import "PriorityObject.h"
#import "JSON.h"
#import "STPNAppointmentRootViewController.h"

@implementation ScheduleView

@synthesize arraySubTenants,popover,mParentController,activityController,arrPharmaPlusLab;
@synthesize prioritiesArray,appIdsArray,prioritiesNamesArray,arraySubTenantIds,service,arrayMoreActionScheduleList;

-(id)initWithParent:(UserAccountViewController*)parent{
    if ((self = [super init])) {
        NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"ScheduleView" owner:self options:nil];
        // prevent memory leak
        [self release];
        self = [[nib objectAtIndex:0] retain];
    }
    self.mParentController = parent;  
    self.service = [[[_GMDocService alloc] init] autorelease];
    arrDays = [[NSMutableArray alloc] init];
    arrDaysSmall = [[NSMutableArray alloc] init];
    arrDurationMin = [[NSMutableArray alloc] init];
    arrDurationHrs = [[NSMutableArray alloc] init];
    [arrDaysSmall addObject:@"Sun"];
    [arrDaysSmall addObject:@"Mon"];
    [arrDaysSmall addObject:@"Tue"];
    [arrDaysSmall addObject:@"Wed"];
    [arrDaysSmall addObject:@"Thu"];
    [arrDaysSmall addObject:@"Fri"];
    [arrDaysSmall addObject:@"Sat"];
    [arrDays addObject:@"Sunday"];
    [arrDays addObject:@"Monday"];
    [arrDays addObject:@"Tuesday"];
    [arrDays addObject:@"Wednesday"];
    [arrDays addObject:@"Thursday"];
    [arrDays addObject:@"Friday"];
    [arrDays addObject:@"Saturday"];
    hrsNotMinutes = true;
    todayNotSpecific = true;
    isSchEditMode = FALSE;
    subTenCount=0;
    childNavBar.layer.cornerRadius = 5.0;
    tblSelectPriority.layer.cornerRadius = 5.0;
    for (int i=0; i<100; i++) {
        subTenIsSelected[i]=false;
        priorityIdArray[i]=-1;
    }
    NSMutableURLRequest* request = [[[NSMutableURLRequest alloc] init] autorelease]; 
	NSString* url = [NSString stringWithFormat:@"http://%@getPriority",[DataExchange getbaseUrl]];
 
    
	[request setURL:[NSURL URLWithString:url]];
	[request setHTTPMethod:@"GET"];
	getPriorityConnection = [[[NSURLConnection alloc] initWithRequest:request delegate:self] autorelease];
    
    request = [[[NSMutableURLRequest alloc] init] autorelease];
	url = [NSString stringWithFormat:@"http://%@getAppSlots",[DataExchange getbaseUrl]];
	[request setURL:[NSURL URLWithString:url]];
	[request setHTTPMethod:@"GET"];
	getAppIdsConnection = [[[NSURLConnection alloc] initWithRequest:request delegate:self] autorelease];
    
    return self;
}

-(void)reloadDataOfFacility{
    [tblSelectPriority reloadData];
    for (int i=0; i<self.arrPharmaPlusLab.count; i++) {
        facilityIdArray[i] = [[(SubTenant*)[self.arrPharmaPlusLab objectAtIndex:i] SubTenantId] integerValue];
    }
}

-(IBAction)doSegmentSwitch:(id)sender {
    UISegmentedControl *segmentedControl = (UISegmentedControl *) sender;
    NSInteger selectedSegment = segmentedControl.selectedSegmentIndex;
    switch (selectedSegment) {
        case 0:
            newScheduleView.hidden = false;
            moreActionsView.hidden = true;
            break;
        case 1:
            newScheduleView.hidden = true;
            moreActionsView.hidden = false;
            break;
        default:
            break;
    }
}

-(BOOL)isDate:(NSString*)firstDate lessThan:(NSString*)secondDate{
    NSDateFormatter *df = [[[NSDateFormatter alloc] init] autorelease];
    [df setDateFormat:@"dd-MMM-yyyy"];
    NSDate* dateFirst = [df dateFromString:firstDate];
    NSDate* dateSecond = [df dateFromString:secondDate];
    if([self daysBetweenDate:dateFirst andDate:dateSecond]>0)//>0 for descending order
        return TRUE;
    else
        return FALSE;
}

-(void)getScheduleInvocationDidFinish:(GetScheduleInvocation *)invocation
                         withSchedule:(NSArray *)schedules
                            withError:(NSError *)error{
    if(!error && schedules.count>0){
        NSMutableArray* temp = [[NSMutableArray alloc] initWithObjects:[schedules objectAtIndex:0], nil];
        for (int i=1; i<schedules.count; i++){
            for (int j=0; j<temp.count; j++){
                if([self isDate:[(Schedule*)[schedules objectAtIndex:i] date] lessThan:[(Schedule*)[temp objectAtIndex:j] date]]){
                    [temp insertObject:[schedules objectAtIndex:i] atIndex:j];
                    break;
                }
                else if(j==temp.count-1){
                    [temp addObject:[schedules objectAtIndex:i]];
                    break;
                }
            }
        }
        self.arrayMoreActionScheduleList = [[NSMutableArray alloc] initWithArray:temp];
        for (int i=0; i<self.arrayMoreActionScheduleList.count; i++) {
            NSInteger subTenInt = [[(Schedule*)[self.arrayMoreActionScheduleList objectAtIndex:i] HospitalId] integerValue];
            [self.service getSubTenantId2Invocation:[DataExchange getUserRoleId] SubTenantId:[NSString stringWithFormat:@"%d",subTenInt] IsSecond:YES delegate:self];
        }
        [tblMoreSchedules reloadData];
    }
    else if(self.activityController){
        self.arrayMoreActionScheduleList = [[NSMutableArray alloc] init];
        [tblMoreSchedules reloadData];
        [self.activityController dismissActivity];
        self.activityController = Nil;
    }
}

-(void) GetSubtenIdInvocationDidFinish:(GetSubtenIdInvocation*)invocation
                      withSubTenantIds:(NSArray*)subTenantId
                             withError:(NSError*)error{
    if(!error){
        for (int i=0; i<self.arrayMoreActionScheduleList.count; i++) {
            NSInteger subTenIntTemp = [[(SubTenant*)[subTenantId objectAtIndex:0] SubTenantId] integerValue];
            NSInteger subTenInt = [[(Schedule*)[self.arrayMoreActionScheduleList objectAtIndex:i] HospitalId] integerValue];
            if(subTenIntTemp == subTenInt){
                Schedule* tempSch = (Schedule*)[self.arrayMoreActionScheduleList objectAtIndex:i];
                tempSch.hospital = [NSString stringWithFormat:@"%@",[(SubTenant*)[subTenantId objectAtIndex:0] SubTenantName]];
            }
        }
        subTenCount++;
        if(subTenCount==self.arrayMoreActionScheduleList.count){
            if(self.activityController){
                [self.activityController dismissActivity];
                self.activityController = Nil;
            }
            [tblMoreSchedules reloadData];
            subTenCount=0;
        }
    }else if(self.activityController){
        [self.activityController dismissActivity];
        self.activityController = Nil;
    }
}

#pragma mark connection delegate

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    NSString *newStr = [[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    if(connection==getPriorityConnection){
        NSArray* response = [newStr JSONValue];
        self.prioritiesArray = [[NSMutableArray alloc] init];
        prioritiesNamesArray = [[NSMutableArray alloc] init];
        for (int i=0; i<response.count; i++) {
            NSDictionary* dictTemp = [response objectAtIndex:i];
            PriorityObject* tempObj = [[PriorityObject alloc] init];
            tempObj.priorityId = [dictTemp objectForKey:@"PriorityId"];
            tempObj.priorityName = [dictTemp objectForKey:@"PriorityProperty"];
            [prioritiesNamesArray addObject:tempObj.priorityName];
            [self.prioritiesArray addObject:tempObj];
        }
        [tblSelectPriority reloadData];
    }
    else if(connection==getAppIdsConnection){
        NSArray* response = [newStr JSONValue];
        appIdsArray = [[NSMutableArray alloc] init];
        for (int i=0; i<response.count; i++) {
            NSDictionary* dictTemp = [response objectAtIndex:i];
            PriorityObject* tempObj = [[PriorityObject alloc] init];
            tempObj.appSlotId = [dictTemp objectForKey:@"AppSlotId"];
            tempObj.appDuration = [dictTemp objectForKey:@"AppDuration"];
            if([tempObj.appDuration integerValue]<10)
                [arrDurationHrs addObject:[NSString stringWithFormat:@"%d",[tempObj.appDuration integerValue]]];
            else
                [arrDurationMin addObject:[NSString stringWithFormat:@"%d",[tempObj.appDuration integerValue]]];
            [appIdsArray addObject:tempObj];
            [tempObj release];
        }        
    }
    else if([newStr isEqualToString:@"\"True\""]){
        if(isSchEditMode){
            isSchEditMode = FALSE;
            btnEditSchHider.hidden = TRUE;
            proAlertView *alert = [[proAlertView alloc] initWithTitle:nil message:@"Schedule updated successfully!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
            [alert setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
            [alert show];
            [alert release];
        }
        else{
            proAlertView *alert = [[proAlertView alloc] initWithTitle:nil message:@"Schedule created successfully!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
            [alert setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
            [alert show];
            [alert release];
        }
        [DataExchange setAppointmentRefreshIndex:1];
        txtScheduleName.text = @"";
    }
    else if([newStr rangeOfString:@"conflict"].length != NSNotFound){
        proAlertView *alert = [[proAlertView alloc] initWithTitle:@"Error!" message:[newStr stringByReplacingOccurrencesOfString:@"\"" withString:@""] delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
        [alert setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
        [alert show];
        [alert release];
    }    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    if (self.activityController) {
        [self.activityController dismissActivity];
        self.activityController = nil;
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    if (self.activityController) {
        [self.activityController dismissActivity];
        self.activityController = nil;
    }
    proAlertView *alert = [[proAlertView alloc] initWithTitle:@"Something Went Wrong" message:@"Please Try Again" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
    [alert setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
    [alert show];
    [alert release];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(tableView==tblSelectDays)
        return 7;
    else if(tableView==tblMoreSchedules)
        return self.arrayMoreActionScheduleList.count;
    else
        return self.arrPharmaPlusLab.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView==tblSelectPriority){
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tblSelectPriority dequeueReusableCellWithIdentifier:CellIdentifier];
//        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
            [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
//        }
        
        cell.textLabel.text = [(SubTenant*)[self.arrPharmaPlusLab objectAtIndex:indexPath.row] SubTenantName];

        
        if(subTenIsSelected[indexPath.row])
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        else
            cell.accessoryType = UITableViewCellAccessoryNone;
        
        UIButton* btn = (UIButton*)[cell viewWithTag:900+indexPath.row];
        if(btn==nil){
            btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [btn setFrame:CGRectMake(250, 6, 80, 32)];
            [btn addTarget:self action:@selector(priorityBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag=900+indexPath.row;
            [cell addSubview:btn];
        }
        if(priorityIdArray[indexPath.row]==-1)
            [btn setTitle:@"-Priority-" forState:UIControlStateNormal];
        else{
            [btn setTitle:[prioritiesNamesArray objectAtIndex:priorityIdArray[indexPath.row]] forState:UIControlStateNormal];
        }
        return cell;
    }
    else if(tableView==tblMoreSchedules){
        static NSString *CellIdentifier = @"CellMore";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        }
        
        for (UIView* view in [cell subviews]) {
            if([view isKindOfClass:[UILabel class]]){
                [view removeFromSuperview];
                view = nil;
            }
        }
        
        UILabel* lblScheduleName = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 141, 44)];
        lblScheduleName.backgroundColor = [UIColor clearColor];
        lblScheduleName.textAlignment = UITextAlignmentCenter;
        lblScheduleName.numberOfLines = 0;
        lblScheduleName.lineBreakMode = UILineBreakModeWordWrap;
        lblScheduleName.text = [(Schedule*)[self.arrayMoreActionScheduleList objectAtIndex:indexPath.row] schedule_name];
        [cell addSubview:lblScheduleName];
        
        UILabel* lblHospital = [[UILabel alloc] initWithFrame:CGRectMake(141, 0, 141, 44)];
        lblHospital.backgroundColor = [UIColor clearColor];
        lblHospital.textAlignment = UITextAlignmentCenter;
        lblHospital.numberOfLines = 0;
        lblHospital.lineBreakMode = UILineBreakModeWordWrap;
        lblHospital.text = [(Schedule*)[self.arrayMoreActionScheduleList objectAtIndex:indexPath.row] hospital];
        [cell addSubview:lblHospital];
        
        
        UILabel* lblDate = [[UILabel alloc] initWithFrame:CGRectMake(282, 0, 141, 44)];
        lblDate.backgroundColor = [UIColor clearColor];
        lblDate.numberOfLines = 0;
        lblDate.lineBreakMode = UILineBreakModeWordWrap;
        lblDate.textAlignment = UITextAlignmentCenter;
        lblDate.text = [(Schedule*)[self.arrayMoreActionScheduleList objectAtIndex:indexPath.row] date];
        [cell addSubview:lblDate];
        
        UILabel* lblTime = [[UILabel alloc] initWithFrame:CGRectMake(423, 0, 141, 44)];
        lblTime.backgroundColor = [UIColor clearColor];
        lblTime.textAlignment = UITextAlignmentCenter;
        lblTime.numberOfLines = 0;
        lblTime.lineBreakMode = UILineBreakModeWordWrap;
        lblTime.text = [NSString stringWithFormat:@"%@ To %@",[(Schedule*)[self.arrayMoreActionScheduleList objectAtIndex:indexPath.row] from_time],[(Schedule*)[self.arrayMoreActionScheduleList objectAtIndex:indexPath.row] to_time]];
        [cell addSubview:lblTime];
        
        UIButton* btnAction = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnAction setFrame:CGRectMake(564, 0, 100, 44)];
        btnAction.titleLabel.textAlignment = UITextAlignmentCenter;
        [btnAction setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [btnAction addTarget:self action:@selector(clickEditSchedule:) forControlEvents:UIControlEventTouchUpInside];
        btnAction.tag = 90+indexPath.row;
        [btnAction setTitle:@"Edit" forState:UIControlStateNormal];
        [cell addSubview:btnAction];
        
        return cell;
    }
    else{
        static NSString *CellIdentifier = @"Cell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        }
        
        cell.textLabel.text = [arrDays objectAtIndex:indexPath.row];
        if(dayIsSelected[indexPath.row])
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        else
            cell.accessoryType = UITableViewCellAccessoryNone;
        
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if(tableView==tblSelectPriority){
        subTenIsSelected[indexPath.row]=!subTenIsSelected[indexPath.row];
        [tblSelectPriority reloadData];
    }
    else{
        dayIsSelected[indexPath.row]=!dayIsSelected[indexPath.row];
        [tblSelectDays reloadData];
    }
}

-(NSString*)militaryToTwelveHr:(NSString*)time{
    NSString* timeStr;
    NSInteger sliderVal = [[[time componentsSeparatedByString:@":"] objectAtIndex:0] integerValue];
    NSInteger timeMin = [[[time componentsSeparatedByString:@":"] objectAtIndex:1] integerValue];
    if(sliderVal < 12){
        timeStr = [NSString stringWithFormat:@"%d:",sliderVal];
        timeStr = [timeStr stringByAppendingFormat:@"%@%d",(timeMin<10?@"0":@""),timeMin];
        timeStr = [timeStr stringByAppendingFormat:@" am"];
    }
    else if(sliderVal<13){
        timeStr = [NSString stringWithFormat:@"%d:",sliderVal];
        timeStr = [timeStr stringByAppendingFormat:@"%@%d",(timeMin<10?@"0":@""),timeMin];
        timeStr = [timeStr stringByAppendingFormat:@" pm"];
    }
    else{
        timeStr = [NSString stringWithFormat:@"%d:",sliderVal-12];
        timeStr = [timeStr stringByAppendingFormat:@"%@%d",(timeMin<10?@"0":@""),timeMin];
        timeStr = [timeStr stringByAppendingFormat:@" pm"];
    }
    return timeStr;
}

-(void)clickEditSchedule:(id)sender{
    isSchEditMode = TRUE;
    topBar.selectedSegmentIndex = 0;
    newScheduleView.hidden = false;
    moreActionsView.hidden = true;
    Schedule* currentScheduleToEdit = [self.arrayMoreActionScheduleList objectAtIndex:([(UIButton*)sender tag] - 90)];
    [txtScheduleName setText:currentScheduleToEdit.schedule_name];
    NSDateFormatter *df = [[[NSDateFormatter alloc] init] autorelease];
    [df setDateFormat:@"dd-MMM-yyyy"];
    
    [btnFromTime setTitle:[self militaryToTwelveHr:[currentScheduleToEdit from_time]] forState:UIControlStateNormal];
    [btnToTime setTitle:[self militaryToTwelveHr:[currentScheduleToEdit to_time]] forState:UIControlStateNormal];
    [btnFacility setTitle:[currentScheduleToEdit hospital] forState:UIControlStateNormal];
    [btnNature setTitle:[currentScheduleToEdit priority] forState:UIControlStateNormal];
    facilityId = [currentScheduleToEdit.HospitalId integerValue];
    editScheduleId = [currentScheduleToEdit.schedule_id integerValue];
    priorityId = [currentScheduleToEdit.Priority_id integerValue];
    
    for (int i=0; i<self.prioritiesArray.count; i++) {
        if([[(PriorityObject*)[self.prioritiesArray objectAtIndex:i] priorityId] integerValue]==[currentScheduleToEdit.Priority_id integerValue]){
            [btnNature setTitle:[(PriorityObject*)[self.prioritiesArray objectAtIndex:i] priorityName] forState:UIControlStateNormal];
            break;
        }
    }
    
    specificSegmentControl.selectedSegmentIndex=0;
    hideSpecificView.hidden = FALSE;
    hideSpecificDaysBtnView.hidden = FALSE;
    btnEditSchHider.hidden = FALSE;
    [btnEditSchHider setTitle:[currentScheduleToEdit date] forState:UIControlStateNormal];
    for (int i=0; i<currentScheduleToEdit.specificDays.count; i++) {
        for (int j=0; j<arrDaysSmall.count; j++) {
            dayIsSelected[i]=FALSE;
            [btnDays setTitle:@"--Select Day--" forState:UIControlStateNormal];
        }
    }
    
    if(currentScheduleToEdit.facilities.count>0){
        for (int i=0; i<currentScheduleToEdit.facilities.count; i++) {
            for (int j=0; j<self.arrPharmaPlusLab.count; j++) {
                NSInteger index = facilityIdArray[j];
                NSInteger index2 = [(SubTenant*)[currentScheduleToEdit.facilities objectAtIndex:i] SubTenantIdInteger];
                if(index==index2){
                    subTenIsSelected[j]=TRUE;
                    ((SubTenant*)[self.arrPharmaPlusLab objectAtIndex:j]).PriorityIndex=index;
                    for (int k=0; k<self.prioritiesArray.count; k++) {
                        if([(SubTenant*)[currentScheduleToEdit.facilities objectAtIndex:i] PriorityIndex]==[[(PriorityObject*)[self.prioritiesArray objectAtIndex:k] priorityId] integerValue])
                            priorityIdArray[j]=k;
                    }
                    
                }
            }
        }
        [tblSelectPriority reloadData];
    }
    
    for (int i=0; i<appIdsArray.count; i++){
        if([currentScheduleToEdit.app_slot_id integerValue]==[[(PriorityObject*)[appIdsArray objectAtIndex:i] appSlotId] integerValue]){
            intDuration = [[(PriorityObject*)[appIdsArray objectAtIndex:i] appDuration] integerValue];
            if([[(PriorityObject*)[appIdsArray objectAtIndex:i] appDuration] integerValue]<10){
                hrsNotMinutes = TRUE;
                hrsMinSegCtrl.selectedSegmentIndex = 0;
                [btnDuration setTitle:[NSString stringWithFormat:@"%d",[[(PriorityObject*)[appIdsArray objectAtIndex:i] appDuration] integerValue]] forState:UIControlStateNormal];
            }
            else{
                hrsNotMinutes = FALSE;
                hrsMinSegCtrl.selectedSegmentIndex = 1;
                [btnDuration setTitle:[NSString stringWithFormat:@"%d",[[(PriorityObject*)[appIdsArray objectAtIndex:i] appDuration] integerValue]] forState:UIControlStateNormal];
            }
        }
    }
    
    [tblSelectDays reloadData];
}

-(void)priorityBtnClicked:(id)sender{
    CustomPopoverViewController* controller = [[CustomPopoverViewController alloc] initWithNibName:@"CustomPopoverViewController" bundle:nil];
    controller.listOfOptions = prioritiesNamesArray;
    controller.delegate = self;
    controller.type = 55;
    controller.btn = (UIButton*)sender;
    self.popover = [[UIPopoverController alloc] initWithContentViewController:controller];
    [controller release];
    [self.popover setPopoverContentSize:CGSizeMake(120, 20 + 44*(self.prioritiesArray.count>5?5:self.prioritiesArray.count))];
    [self.popover presentPopoverFromRect:CGRectMake(600, 156, 10, 10) inView:self permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
}

-(IBAction)btnFacilityClicked{
    CustomPopoverViewController* controller = [[CustomPopoverViewController alloc] initWithNibName:@"CustomPopoverViewController" bundle:nil];
    NSMutableArray* tempArr = [[NSMutableArray alloc] init];
    for (int i=0; i<arraySubTenants.count; i++) {
        [tempArr addObject:[(SubTenant*)[arraySubTenants objectAtIndex:i] SubTenantName]];
    }
    controller.listOfOptions = tempArr;
    controller.delegate = self;
    controller.type =55;
    controller.btn = btnFacility;
    self.popover = [[UIPopoverController alloc] initWithContentViewController:controller];
    [controller release];
    [self.popover setPopoverContentSize:CGSizeMake(250, 20 + 50*(self.arraySubTenants.count>5?5:self.arraySubTenants.count))];
    [self.popover presentPopoverFromRect:btnFacility.frame inView:newScheduleView permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
}

- (IBAction)btnNatureClicked{
    CustomPopoverViewController* controller = [[CustomPopoverViewController alloc] initWithNibName:@"CustomPopoverViewController" bundle:nil];
    controller.listOfOptions = prioritiesNamesArray;
    controller.delegate = self;
    controller.type =55;
    controller.btn = btnNature;
    self.popover = [[UIPopoverController alloc] initWithContentViewController:controller];
    [controller release];
    [self.popover setPopoverContentSize:CGSizeMake(250, 20 + 50*(prioritiesNamesArray.count>5?5:prioritiesNamesArray.count))];
    [self.popover presentPopoverFromRect:btnNature.frame inView:newScheduleView permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
}

- (IBAction)btnDurationClicked{
    CustomPopoverViewController* controller = [[CustomPopoverViewController alloc] initWithNibName:@"CustomPopoverViewController" bundle:nil];
    controller.listOfOptions = (hrsNotMinutes?arrDurationHrs:arrDurationMin);
    controller.delegate = self;
    controller.type =55;
    controller.btn = btnDuration;
    self.popover = [[UIPopoverController alloc] initWithContentViewController:controller];
    [controller release];
    [self.popover setPopoverContentSize:CGSizeMake(250, 20 + 50*(arrDurationMin.count>5?5:arrDurationMin.count))];
    [self.popover presentPopoverFromRect:btnDuration.frame inView:newScheduleView permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (IBAction)btnDayslicked{
    selectDaysView.hidden = false;
}

-(IBAction)selectAll{
    for (int i=0; i<7; i++) {
        dayIsSelected[i]=true;
    }
    [tblSelectDays reloadData];
}

-(IBAction)selectNone{
    for (int i=0; i<7; i++) {
        dayIsSelected[i]=false;
    }
    [tblSelectDays reloadData];
}

-(IBAction)doneBtnPressed{
    selectDaysView.hidden = true;
    [btnDays setTitle:@"Days Selected" forState:UIControlStateNormal];
}

-(IBAction)cancelBtnPressed{
    selectDaysView.hidden = true;
}

-(void)optionSelected:(NSString *)cellValue ForButton:(UIButton *)btn AndIndex:(NSInteger)index{
    [btn setTitle:cellValue forState:UIControlStateNormal];
    [self.popover dismissPopoverAnimated:YES];
    if(btn==btnDuration){
        intDuration = [cellValue integerValue];
        [btn setTitle:[NSString stringWithFormat:@"%@ %@",cellValue,(hrsNotMinutes?@"Hrs":@"Min")] forState:UIControlStateNormal];
    }else if(btn==btnFacility){
        facilityId = [[(SubTenant*)[[DataExchange getSubTenantIds] objectAtIndex:index] SubTenantId] integerValue];
    }else if(btn==btnNature){
        priorityId = [[(PriorityObject*)[self.prioritiesArray objectAtIndex:index] priorityId] integerValue];
    }else{
        int i=[btn tag]-900;
        ((SubTenant*)[self.arrPharmaPlusLab objectAtIndex:i]).PriorityIndex=index;
        [btn setTitle:[prioritiesNamesArray objectAtIndex:index] forState:UIControlStateNormal];
        priorityIdArray[i] = index;
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

- (void) closePopUpDate:(NSString*)dt{
    [self.popover dismissPopoverAnimated:YES];
    if(dt.length==0)
        return;
    
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateFormat: @"dd-MMM-yyyy"];    
    NSDate *dateFromString = [dateFormatter dateFromString:dt];
    if(isSchEditMode){
        [btnEditSchHider setTitle:dt forState:UIControlStateNormal];
        return;
    }
    if(![newScheduleView isHidden]){// new schedule case
        if(isFromDate){
            if(![btnToDate.titleLabel.text isEqualToString:@"--Select Date--"] && [self daysBetweenDate:dateFromString andDate:[dateFormatter dateFromString:btnToDate.titleLabel.text]]<=0){
                proAlertView *alert = [[proAlertView alloc] initWithTitle:@"Error!" message:@"From-Date selected should not be after To-date!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [alert setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
                [alert show];
                [alert release];
                return;
            }else if([self daysBetweenDate:dateFromString andDate:[NSDate date]]>0){
                proAlertView *alert = [[proAlertView alloc] initWithTitle:@"Error!" message:@"From-Date selected should not be before Today!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [alert setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
                [alert show];
                [alert release];
                return;
            }
            [btnFromDate setTitle:dt forState:UIControlStateNormal];
            [btnToDate setTitle:@"--Select Date--" forState:UIControlStateNormal];
        }else{
            if([self daysBetweenDate:[dateFormatter dateFromString:btnFromDate.titleLabel.text] andDate:dateFromString]<0){
                proAlertView *alert = [[proAlertView alloc] initWithTitle:@"Error!" message:@"To-Date selected should be after starting date!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [alert setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
                [alert show];
                [alert release];
                return;
            }
            [btnToDate setTitle:dt forState:UIControlStateNormal];
        }
    }else{// more actions case
        if(isFromDate){
            if(![btnMoreActionsToDate.titleLabel.text isEqualToString:@"--Select Date--"] && [self daysBetweenDate:dateFromString andDate:[dateFormatter dateFromString:btnMoreActionsToDate.titleLabel.text]]<=0){
                proAlertView *alert = [[proAlertView alloc] initWithTitle:@"Error!" message:@"From-Date selected should not be before To-date!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [alert setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
                [alert show];
                [alert release];
                return;
            }
            [btnMoreActionsFromDate setTitle:dt forState:UIControlStateNormal];
        }else{
            if([self daysBetweenDate:[dateFormatter dateFromString:btnMoreActionsFromDate.titleLabel.text] andDate:dateFromString]<=0){
                proAlertView *alert = [[proAlertView alloc] initWithTitle:@"Error!" message:@"To-Date selected should be after from-date!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [alert setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
                [alert show];
                [alert release];
                return;
            }
            [btnMoreActionsToDate setTitle:dt forState:UIControlStateNormal];
        }
    }
}

- (IBAction)btntoDateClicked:(id)sender{
    if([btnFromDate.titleLabel.text isEqualToString:@"--Select Date--"]){
        proAlertView *alert = [[proAlertView alloc] initWithTitle:@"" message:@"Please select from date first!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
        [alert show];
        [alert release];
        return;
    }
    isFromDate=false;
    STPNDatePickerViewController *addController = [[STPNDatePickerViewController alloc] initWithNibName:@"STPNDatePickerViewController" bundle:nil];
    
    addController.delegate = self;
    
    self.popover = [[[UIPopoverController alloc] initWithContentViewController:addController] autorelease]; 
    self.popover.popoverContentSize = CGSizeMake(300, 259);
    
    [self.popover presentPopoverFromRect:btnToDate.frame inView:newScheduleView permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
    [addController release];
}

- (IBAction)editDateBtnClicked{
    STPNDatePickerViewController *addController = [[STPNDatePickerViewController alloc] initWithNibName:@"STPNDatePickerViewController" bundle:nil];
    
    addController.delegate = self;
    
    self.popover = [[[UIPopoverController alloc] initWithContentViewController:addController] autorelease]; 
    self.popover.popoverContentSize = CGSizeMake(300, 259);
    
    [self.popover presentPopoverFromRect:btnEditSchHider.frame inView:newScheduleView permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
    [addController release];
}

- (IBAction)btnFromDateClicked:(id)sender{
    isFromDate=true;
    STPNDatePickerViewController *addController = [[STPNDatePickerViewController alloc] initWithNibName:@"STPNDatePickerViewController" bundle:nil];
    
    addController.delegate = self;
    
    self.popover = [[[UIPopoverController alloc] initWithContentViewController:addController] autorelease]; 
    self.popover.popoverContentSize = CGSizeMake(300, 259);
    
    [self.popover presentPopoverFromRect:btnFromDate.frame inView:newScheduleView permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
    [addController release];
}

- (IBAction)btnMoreActionstoDateClicked:(id)sender{
    isFromDate=false;
    STPNDatePickerViewController *addController = [[STPNDatePickerViewController alloc] initWithNibName:@"STPNDatePickerViewController" bundle:nil];
    
    addController.delegate = self;
    
    self.popover = [[[UIPopoverController alloc] initWithContentViewController:addController] autorelease]; 
    self.popover.popoverContentSize = CGSizeMake(300, 259);
    
    [self.popover presentPopoverFromRect:btnMoreActionsToDate.frame inView:moreActionsView permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    [addController release];
}

- (IBAction)btnMoreActionsFromDateClicked:(id)sender{
    isFromDate=true;
    STPNDatePickerViewController *addController = [[STPNDatePickerViewController alloc] initWithNibName:@"STPNDatePickerViewController" bundle:nil];
    
    addController.delegate = self;
    
    self.popover = [[[UIPopoverController alloc] initWithContentViewController:addController] autorelease]; 
    self.popover.popoverContentSize = CGSizeMake(300, 259);
    
    [self.popover presentPopoverFromRect:btnMoreActionsFromDate.frame inView:moreActionsView permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    [addController release];
}

- (IBAction)btnToTimeClicked:(id)sender{
    STPNDateViewController* controller = [[STPNDateViewController alloc] initWithNibName:@"STPNDateViewController" bundle:nil];
    controller.flag = false;
    controller.delegate = self;
    popover = [[UIPopoverController alloc] initWithContentViewController:controller];
    [popover setPopoverContentSize:CGSizeMake(245, 185)];
    [controller release];
    [popover presentPopoverFromRect:[(UIButton*)sender frame] inView:newScheduleView permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
}

- (IBAction)btnFromTimeClicked:(id)sender{
    STPNDateViewController* controller = [[STPNDateViewController alloc] initWithNibName:@"STPNDateViewController" bundle:nil];
    controller.flag = true;
    controller.delegate = self;
    popover = [[UIPopoverController alloc] initWithContentViewController:controller];
    [popover setPopoverContentSize:CGSizeMake(245, 185)];
    [controller release];
    [popover presentPopoverFromRect:[(UIButton*)sender frame] inView:newScheduleView permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
}

- (void) closeFromTime:(NSString*)time{
    [self.popover dismissPopoverAnimated:YES];
    [btnFromTime setTitle:time forState:UIControlStateNormal];
}

- (void) closeToTime:(NSString*)time{
    [self.popover dismissPopoverAnimated:YES];
    [btnToTime setTitle:time forState:UIControlStateNormal];
}

- (IBAction)toggleHrsAndMinutes:(id)sender {
    UISegmentedControl *segmentedControl = (UISegmentedControl *) sender;
    NSInteger selectedSegment = segmentedControl.selectedSegmentIndex;
    switch (selectedSegment) {
        case 0:
            hrsNotMinutes = true;
            break;
        case 1:
            hrsNotMinutes = false;
            break;
        default:
            break;
    }
    [btnDuration setTitle:@"--Select Duration--" forState:UIControlStateNormal];
}

- (IBAction)toggleTodayAndSpecificDay:(id)sender {
    UISegmentedControl *segmentedControl = (UISegmentedControl *) sender;
    NSInteger selectedSegment = segmentedControl.selectedSegmentIndex;
    switch (selectedSegment) {
        case 0:
            todayNotSpecific = true;
            hideSpecificView.hidden = false;
            hideSpecificDaysBtnView.hidden = false;
            break;
        case 1:
            todayNotSpecific = false;
            hideSpecificView.hidden = true;
            hideSpecificDaysBtnView.hidden = true;
            break;
        default:
            break;
    }
}

-(IBAction)searchBtnClicked{
    [self.service getScheduleMoreActionInvocation:[DataExchange getUserRoleId] FromDate:btnMoreActionsFromDate.titleLabel.text CurrentDate:btnMoreActionsToDate.titleLabel.text Type:@"4" delegate:self];
    if(!self.activityController)
        self.activityController = [ISActivityOverlayController presentActivityOverViewController:mParentController withLabel:@"Loading..."];
}

- (IBAction)submitBtnClicked{
    if(txtScheduleName.text.length==0){
        proAlertView *alert = [[proAlertView alloc] initWithTitle:@"Error!" message:@"Please enter schedule name" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
        [alert show];
        [alert release];
        return;
    }
    else if(!todayNotSpecific && !isSchEditMode && ([btnFromDate.titleLabel.text isEqualToString:@"--Select Date--"] || [btnToDate.titleLabel.text isEqualToString:@"--Select Date--"])){
        proAlertView *alert = [[proAlertView alloc] initWithTitle:@"" message:@"Please select both \"from\" and \"to\" date!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
        [alert show];
        [alert release];
        return;
    }
    else if([btnNature.titleLabel.text isEqualToString:@"--Select Priority--"]){
        proAlertView *alert = [[proAlertView alloc] initWithTitle:@"" message:@"Please select a priority!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
        [alert show];
        [alert release];
        return;
    }
    else if([btnDuration.titleLabel.text isEqualToString:@"--Select Duration--"]){
        proAlertView *alert = [[proAlertView alloc] initWithTitle:@"" message:@"Please select a duration!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
        [alert show];
        [alert release];
        return;
    }
    else if([btnFromTime.titleLabel.text isEqualToString:@"--Select--"] || [btnToTime.titleLabel.text isEqualToString:@"--Select--"]){
        proAlertView *alert = [[proAlertView alloc] initWithTitle:@"" message:@"Please select both \"from\" and \"to\" Time!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
        [alert show];
        [alert release];
        return;
    }
    
    proAlertView *alert = [[proAlertView alloc] initWithTitle:@"Submit?" message:@"Are you sure you want to submit this schedule?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes",nil];
    [alert setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
    [alert show];
    [alert release];
}

- (IBAction)cancelBtnClicked{
    isSchEditMode = FALSE;
    btnEditSchHider.hidden = TRUE;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex==1){
        self.activityController = [ISActivityOverlayController presentActivityOverViewController:self.mParentController withLabel:@"Loading ..."];
        int slotId=0;
        for (int i=0; i<appIdsArray.count; i++)
            if([[(PriorityObject*)[appIdsArray objectAtIndex:i] appDuration] integerValue] == intDuration){
                slotId = [[(PriorityObject*)[appIdsArray objectAtIndex:i] appSlotId] integerValue];
                break;
            }
        
        NSString* dataToPost = [NSString stringWithFormat:@"{\"schedule\":{\"Name\":\"%@\",\"FromTime\":\"%@\",\"Totime\":\"%@\",\"HospitalID\":%d,\"PriorityID\":%d,\"SlotID\":%d,\"IsSpecific\":\"%@\",",txtScheduleName.text,btnFromTime.titleLabel.text,btnToTime.titleLabel.text,facilityId,priorityId,slotId,(isSchEditMode?@"false":(todayNotSpecific?@"false":@"true"))];
        
        if(isSchEditMode){
            dataToPost = [dataToPost stringByAppendingFormat:@"\"SpecificFromDate\":\"\",\"SpecificToDate\":\"\",\"Date\":\"%@\",\"SpecificDays\":[",btnEditSchHider.titleLabel.text];
            int count=0;
            for (int i=0; i<7; i++){
                if(dayIsSelected[i]){
                    dataToPost = [dataToPost stringByAppendingFormat:@"{\"DayId\":%d,\"Day\":\"%@\"}",i+1,[arrDaysSmall objectAtIndex:i]];
                    count++;
                    break;
                }
            }
        }
        else{
            if(todayNotSpecific){
                dataToPost = [dataToPost stringByAppendingFormat:@"\"SpecificFromDate\":\"\",\"SpecificToDate\":\"\",\"SpecificDays\":["];
            }else{
                dataToPost = [dataToPost stringByAppendingFormat:@"\"SpecificFromDate\":\"%@\",\"SpecificToDate\":\"%@\",\"SpecificDays\":[",btnFromDate.titleLabel.text,btnToDate.titleLabel.text];
                int count=0;
                for (int i=0; i<7; i++){
                    if(dayIsSelected[i]){
                        dataToPost = [dataToPost stringByAppendingFormat:@"{\"DayId\":%d,\"Day\":\"%@\"},",i+1,[arrDaysSmall objectAtIndex:i]];
                        count++;
                    }
                }
                if(count>0)
                    dataToPost = [dataToPost substringToIndex:(dataToPost.length-1)]; 
            }
        }
        
        int count=0;
        dataToPost = [dataToPost stringByAppendingFormat:@"],\"Facility\":["];
        for (int i=0; i<self.arrPharmaPlusLab.count; i++) {
            if(subTenIsSelected[i]){
                count++;
                NSInteger index = [[(PriorityObject*)[self.prioritiesArray objectAtIndex:priorityIdArray[i]] priorityId] integerValue];
                dataToPost = [dataToPost stringByAppendingFormat:@"{\"FacilityID\":%d,\"PriorityID\":%d},",facilityIdArray[i],index];
            }
        }
        if(count>0)
            dataToPost = [dataToPost substringToIndex:(dataToPost.length-1)];
        dataToPost = [dataToPost stringByAppendingFormat:@"]},\"UserRoleId\":%@}",[DataExchange getUserRoleId]];
        if(isSchEditMode){
            dataToPost = [dataToPost substringToIndex:(dataToPost.length-1)];
            dataToPost = [dataToPost stringByAppendingFormat:@",\"ScheduleID\":%d}",editScheduleId];
        }
        
        NSURL* myUrl = [[[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://%@%@",[DataExchange getbaseUrl],(!isSchEditMode?@"Schedule_Create":@"Schedule_update")]] autorelease];
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
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [txtScheduleName resignFirstResponder];
}

@end
