//
//  CustomPopoverViewController.m
//  mCura
//
//  Created by Aakash Chaudhary on 02/04/12.
//  Copyright (c) 2012 aakash272@gmail.com. All rights reserved.
//

#import "CustomPopoverViewController.h"

@implementation CustomPopoverViewController
@synthesize delegate,listOfOptions,type,listOfDetailOptions,btn;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	if((type==0)||(type==2))
        self.contentSizeForViewInPopover = CGSizeMake(125, ( (40 * [listOfOptions count]) > 480? 480 : 40*[listOfOptions count]));
    else {
		self.contentSizeForViewInPopover = CGSizeMake(325, 40 * [listOfOptions count]);
	}
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

#pragma mark - Table view data source

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [listOfOptions count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
	if(type==2){
		cell.textLabel.text = [listOfOptions objectAtIndex:indexPath.row];
        if(listOfDetailOptions.count>indexPath.row)
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%d",[(NSNumber*)[listOfDetailOptions objectAtIndex:indexPath.row] integerValue]];
	}
	else {
        cell.textLabel.text = [listOfOptions objectAtIndex:indexPath.row];
	}
	cell.textLabel.textAlignment = UITextAlignmentCenter;
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(type==2)
        [delegate optionSelected:[NSString stringWithFormat:@"%d",indexPath.row]];
    else if(type==55){
        [delegate optionSelected:[listOfOptions objectAtIndex:indexPath.row] ForButton:btn AndIndex:indexPath.row];
    }
    else
        [delegate optionSelected:[tableView cellForRowAtIndexPath:indexPath].textLabel.text];
}

@end
