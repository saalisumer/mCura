//
//  OtherDrugTableController.m
//  mCura
//
//  Created by Aakash Chaudhary on 18/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "OtherDrugTableController.h"

@implementation OtherDrugTableController
@synthesize arrSafetyNames,arrSideEffects,arrSafetyStatus,type;

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
    if(self.type==1){
        divider.hidden = TRUE;
        lbl1.text = @"Side Effects";
        navBar.topItem.title=@"Side Effects";
    }
    else if(self.type==2){
        lbl1.text = @"Safety";
        lbl2.text = @"Status";
        navBar.topItem.title=@"Safety Indications";
    }
}

-(IBAction)closeView{
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - Table view data source

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(type==1)
        return [self.arrSideEffects count];
    else if (type==2) 
        return self.arrSafetyNames.count;
    else
        return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    if(type==1){//table SideEffects
        cell.textLabel.text = [self.arrSideEffects objectAtIndex:indexPath.row];
        [cell.textLabel setFont:[UIFont systemFontOfSize:16]];
    }
    else if(type==2){// table SafetyNames
        for (UIView* view in [cell subviews]) {
            if([view isKindOfClass:[UILabel class]]){
                [view removeFromSuperview];
                view = nil;
            }
        }
        UILabel* lblSafetyName = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 512, 44)];
        lblSafetyName.backgroundColor = [UIColor clearColor];
        lblSafetyName.textAlignment = UITextAlignmentCenter;
        lblSafetyName.numberOfLines = 0;
        lblSafetyName.font = [UIFont systemFontOfSize:18];
        lblSafetyName.lineBreakMode = UILineBreakModeWordWrap;
        lblSafetyName.text = [self.arrSafetyNames objectAtIndex:indexPath.row];
        [cell addSubview:lblSafetyName];
        
        UILabel* lblSafetyStatus = [[UILabel alloc] initWithFrame:CGRectMake(512, 0, 512, 44)];
        lblSafetyStatus.backgroundColor = [UIColor clearColor];
        lblSafetyStatus.textAlignment = UITextAlignmentCenter;
        lblSafetyStatus.numberOfLines = 0;
        lblSafetyStatus.font = [UIFont systemFontOfSize:18];
        lblSafetyStatus.lineBreakMode = UILineBreakModeWordWrap;
        lblSafetyStatus.text = [self.arrSafetyStatus objectAtIndex:indexPath.row];
        [cell addSubview:lblSafetyStatus];
    }
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
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
