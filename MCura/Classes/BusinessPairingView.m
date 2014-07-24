//
//  BusinessPairingView.m
//  mCura
//
//  Created by Aakash Chaudhary on 02/07/12.
//  Copyright (c) 2012 aakash272@gmail.com. All rights reserved.
//

#import "BusinessPairingView.h"
#import "Schedule.h"
#import "proAlertView.h"

@implementation BusinessPairingView

@synthesize activityController,service,mParentController,arrSchedules;

-(id)initWithParent:(UserAccountViewController*)parent
{
    if ((self = [super init])) {
        NSArray * nib = [[NSBundle mainBundle] loadNibNamed: @"BusinessPairingView" owner:self options:nil];
        // prevent memory leak
        [self release];
        self = [[nib objectAtIndex:0] retain];
    }
    
    mParentController = parent;
    self.service = [[[_GMDocService alloc] init] autorelease];
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateFormat:@"dd-MMM-yyyy"];
    [self.service getScheduleInvocation:[DataExchange getUserRoleId] CurrentDate:[dateFormatter stringFromDate:[NSDate date]] Type:@"99" delegate:self];
    if(!self.activityController)
        self.activityController = [ISActivityOverlayController presentActivityOverViewController:mParentController withLabel:@"Loading..."];
    
    return self;
}

-(void)getScheduleInvocationDidFinish:(GetScheduleInvocation *)invocation 
                         withSchedule:(NSArray *)schedules 
                            withError:(NSError *)error{
    if(!error){
        if(schedules.count==0){
            proAlertView *alert = [[proAlertView alloc] initWithTitle:@"Sorry!" message:@"No business pairing records available..." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
            [alert show];
            [alert release];
            if (self.activityController) {
                [self.activityController dismissActivity];
                self.activityController = nil;
            } 
            return;
        }
        
        self.arrSchedules = [[NSMutableArray alloc] initWithArray:schedules];
        NSMutableArray* tempBigArr = [[[NSMutableArray alloc] init] autorelease];
        if(schedules.count>0)
        for (int i=0; i<self.arrSchedules.count; i++) {
            NSMutableArray* temp = [[[NSMutableArray alloc] init] autorelease];
            [temp addObject:[self.arrSchedules objectAtIndex:i]];
            for (int j=i+1; j<self.arrSchedules.count; j++) {
                if(![[(Schedule*)[self.arrSchedules objectAtIndex:j] ScheduleId] isKindOfClass:[NSNull class]] && ![[(Schedule*)[self.arrSchedules objectAtIndex:i] ScheduleId] isKindOfClass:[NSNull class]])
                    if([[(Schedule*)[self.arrSchedules objectAtIndex:j] ScheduleId] integerValue] == [[(Schedule*)[self.arrSchedules objectAtIndex:i] ScheduleId] integerValue]){
                        [temp addObject:[self.arrSchedules objectAtIndex:j]];
                        [self.arrSchedules removeObjectAtIndex:j];
                        j--;
                    }
            }
            [tempBigArr addObject:temp];
            [self.arrSchedules removeObjectAtIndex:i];
            i--;
        }
        self.arrSchedules = nil;
        self.arrSchedules = [[NSMutableArray alloc] initWithArray:tempBigArr];
        [tblSchedules reloadData];
    }
    if(self.activityController){
        [self.activityController dismissActivity];
        self.activityController = nil;
    }
}

#pragma mark -
#pragma mark Table view data source

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.arrSchedules.count;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [[self.arrSchedules objectAtIndex:indexPath.section] count]*44;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    tableView.separatorColor = [UIColor blackColor];
    
    for (UIView* view in [cell subviews]) {
        if([view isKindOfClass:[UILabel class]]){
            [view removeFromSuperview];
            view = nil;
        }
    }
    
    UILabel* lblHosp = [[[UILabel alloc] initWithFrame:CGRectMake(30, 0, 232, [[self.arrSchedules objectAtIndex:indexPath.section] count]*44)] autorelease];
    lblHosp.backgroundColor = [UIColor clearColor];
    lblHosp.textAlignment = UITextAlignmentCenter;
    [cell addSubview:lblHosp];
    if(![[(Schedule*)[[self.arrSchedules objectAtIndex:indexPath.section] objectAtIndex:0] hospital] isKindOfClass:[NSNull class]])
        lblHosp.text = [(Schedule*)[[self.arrSchedules objectAtIndex:indexPath.section] objectAtIndex:0] hospital];
    else
        lblHosp.text = @"---";
    
    for (int i=0; i<[[self.arrSchedules objectAtIndex:indexPath.section] count]; i++) {
        UILabel* lblFacility = [[UILabel alloc] initWithFrame:CGRectMake(262, 44*i, 262, 44)];
        lblFacility.backgroundColor = [UIColor clearColor];
        lblFacility.textAlignment = UITextAlignmentCenter;
        [cell addSubview:lblFacility];
        if(![[(Schedule*)[[self.arrSchedules objectAtIndex:indexPath.section] objectAtIndex:0] facilityName] isKindOfClass:[NSNull class]])
            lblFacility.text = [(Schedule*)[[self.arrSchedules objectAtIndex:indexPath.section] objectAtIndex:i] facilityName];
        else
            lblFacility.text = @"---";
        
        UILabel* lblPriority = [[UILabel alloc] initWithFrame:CGRectMake(524, 44*i, 180, 44)];
        lblPriority.backgroundColor = [UIColor clearColor];
        lblPriority.textAlignment = UITextAlignmentCenter;
        [cell addSubview:lblPriority];
        if(![[(Schedule*)[[self.arrSchedules objectAtIndex:indexPath.section] objectAtIndex:0] priority] isKindOfClass:[NSNull class]])
            lblPriority.text = [(Schedule*)[[self.arrSchedules objectAtIndex:indexPath.section] objectAtIndex:i] priority];
        else
            lblPriority.text = @"---";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	
}

@end
