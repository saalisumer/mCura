//
//  CompareImagePopupVC.m
//  mCura
//
//  Created by Aakash Chaudhary on 28/06/12.
//  Copyright (c) 2012 aakash272@gmail.com. All rights reserved.
//

#import "CompareImagePopupVC.h"
#import "NatureTblCell.h"

@implementation CompareImagePopupVC

@synthesize listOfOptions,delegate,doctorNamesArray,dateDtls,imageDtls;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark -
#pragma mark Table view data source

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return listOfOptions.count;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDateFormatter *df = [[[NSDateFormatter alloc] init] autorelease];
    [df setDateFormat:@"dd-MM-yyyy"];
    static NSString* sRowCell = @"RowCell";
    NatureTblCell* cell = (NatureTblCell*)[tableView dequeueReusableCellWithIdentifier:sRowCell];	
    if (Nil == cell) {
        cell = [NatureTblCell createTextRowWithOwner:self];
    }
    
    cell.lblAppTime.text = [NSString stringWithFormat:@"%@",[df stringFromDate:[self.dateDtls objectAtIndex:indexPath.row]]];
    cell.lblName.text = [self.doctorNamesArray objectAtIndex:indexPath.row];
    cell.imgView.image = [UIImage imageNamed:[self.imageDtls objectAtIndex:indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [delegate optionSelected:[NSString stringWithFormat:@"%d",indexPath.row]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // return UIInterfaceOrientationIsLandscape(interfaceOrientation);
    return UIInterfaceOrientationLandscapeRight;
}

@end
