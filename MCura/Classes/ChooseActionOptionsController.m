//
//  ChooseActionOptionsController.m
//  mCura
//
//  Created by Aakash Chaudhary on 14/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ChooseActionOptionsController.h"
#define numOptions 3

@implementation ChooseActionOptionsController
@synthesize delegate,tblChoices,type;
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

-(IBAction)selectAll{
    for (int i=0; i<numOptions; i++) {
        choices[i]=true;
    }
    [self.tblChoices reloadData];
}

-(IBAction)selectNone{
    for (int i=0; i<numOptions; i++) {
        choices[i]=false;
    }
    [self.tblChoices reloadData];
}

-(IBAction)doneBtnPressed{
    [delegate choicesMade:choices];
}

-(IBAction)cancelBtnPressed{
    [delegate closePopup];
}

-(IBAction)chooseTime:(id)sender{
    STPNDateViewController* controller = [[STPNDateViewController alloc] initWithNibName:@"STPNDateViewController" bundle:nil];
    controller.delegate = self;
    if([sender tag]==21){
        controller.maxValue=10.0;
        controller.minVal=5.0;
    }else if([sender tag]==22){
        controller.minVal=11.0;
        controller.maxValue=15.0;
    }else if([sender tag]==23){
        controller.minVal=19.0;
        controller.maxValue=23.0;
    }
    controller.setExternalValue = true;
    popover = [[UIPopoverController alloc] initWithContentViewController:controller];
    [popover setPopoverContentSize:CGSizeMake(245, 185)];
    [controller release];
    [popover presentPopoverFromRect:[(UIButton*)sender frame] inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (void) closeFromTime:(NSString*)dt{
    [popover dismissPopoverAnimated:YES];
}

- (void) closeToTime:(NSString*)dt{
    [popover dismissPopoverAnimated:YES];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    switch (type) {
        case 1://prescription data
            listOfOptions = [[NSMutableArray alloc] initWithObjects:@"e-mail prescription",@"SMS prescription",@"SMS medicine reminder", nil];
            break;
        case 2://prescription keyboard
            listOfOptions = [[NSMutableArray alloc] initWithObjects:@"e-mail prescription",@"SMS prescription",@"SMS reminder", nil];
            break;
        case 3://prescription stylus
            listOfOptions = [[NSMutableArray alloc] initWithObjects:@"e-mail prescription", nil];
            break;
        case 4://prescription video
            listOfOptions = [[NSMutableArray alloc] initWithObjects:@"e-mail video",@"SMS video reminder",@"MMS", nil];
            break;
        case 11://doctor advice video
            listOfOptions = [[NSMutableArray alloc] initWithObjects:@"e-mail",@"MMS", nil];
            hideBtnsView.hidden = FALSE;
            break;
        case 12://doctor advice keyboard
            listOfOptions = [[NSMutableArray alloc] initWithObjects:@"e-mail",@"SMS", nil];
            hideBtnsView.hidden = FALSE;
            break;
        case 13://doctor advice stylus
            listOfOptions = [[NSMutableArray alloc] initWithObjects:@"e-mail", nil];
            hideBtnsView.hidden = FALSE;
            break;
        default:
            break;
    }
        
    [self selectNone];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

#pragma mark - Table view data source

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return listOfOptions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	
    cell.textLabel.text = [listOfOptions objectAtIndex:indexPath.row];
    if(choices[indexPath.row])
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    else
        cell.accessoryType = UITableViewCellAccessoryNone;

    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    choices[indexPath.row] = !choices[indexPath.row];
    [self.tblChoices reloadData];
}

@end
