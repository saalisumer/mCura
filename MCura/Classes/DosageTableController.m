//
//  DosageTableController.m
//  mCura
//
//  Created by Aakash Chaudhary on 18/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DosageTableController.h"
#import "PriceObject.h"
#import "Brand.h"

@implementation DosageTableController
@synthesize arrBrands;

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
}

-(IBAction)closeView{
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.arrBrands count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [[(Brand*)[self.arrBrands objectAtIndex:indexPath.section] arrayPrices] count]*44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell5";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.clipsToBounds=YES;
    //}
    for (UIView* view in [cell subviews]) {
        if([view isKindOfClass:[UILabel class]]){
            [view removeFromSuperview];
            view = nil;
        }
    }
    
    NSInteger cellHeight = cell.frame.size.height;
    UILabel* lblManufacturer = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 218, cellHeight)];
    lblManufacturer.backgroundColor = [UIColor clearColor];
    lblManufacturer.textAlignment = UITextAlignmentCenter;
    lblManufacturer.numberOfLines = 0;
    lblManufacturer.lineBreakMode = UILineBreakModeCharacterWrap;
    lblManufacturer.text = [(Brand*)[self.arrBrands objectAtIndex:indexPath.section] BrandManufacturer];
    [cell addSubview:lblManufacturer];
    
    UILabel* lblBrandName = [[UILabel alloc] initWithFrame:CGRectMake(218, 0, 184, cellHeight)];
    lblBrandName.backgroundColor = [UIColor clearColor];
    lblBrandName.textAlignment = UITextAlignmentCenter;
    lblBrandName.numberOfLines = 0;
    lblBrandName.lineBreakMode = UILineBreakModeCharacterWrap;
    lblBrandName.text = [(Brand*)[self.arrBrands objectAtIndex:indexPath.section] BrandName];
    [cell addSubview:lblBrandName];
    
    UILabel* lblComposition = [[UILabel alloc] initWithFrame:CGRectMake(402, 0, 302, cellHeight)];
    lblComposition.backgroundColor = [UIColor clearColor];
    lblComposition.textAlignment = UITextAlignmentCenter;
    lblComposition.numberOfLines = 0;
    lblComposition.lineBreakMode = UILineBreakModeCharacterWrap;
    lblComposition.text = [(Brand*)[self.arrBrands objectAtIndex:indexPath.section] BrandComposition];
    [cell addSubview:lblComposition];
    
    NSArray* temp = [(Brand*)[self.arrBrands objectAtIndex:indexPath.section] arrayPrices];
    for (int i=0; i<[[(Brand*)[self.arrBrands objectAtIndex:indexPath.section] arrayPrices] count]; i++) {
        UILabel* lblDosForm = [[UILabel alloc] initWithFrame:CGRectMake(704, 44*i, 80, 44)];
        lblDosForm.backgroundColor = [UIColor clearColor];
        lblDosForm.textAlignment = UITextAlignmentCenter;
        lblDosForm.numberOfLines = 0;
        lblDosForm.lineBreakMode = UILineBreakModeCharacterWrap;
        lblDosForm.text = [(PriceObject*)[temp objectAtIndex:i] DosageForm];
        [cell addSubview:lblDosForm];
        
        UILabel* lblStrength = [[UILabel alloc] initWithFrame:CGRectMake(784, 44*i, 80, 44)];
        lblStrength.backgroundColor = [UIColor clearColor];
        lblStrength.textAlignment = UITextAlignmentCenter;
        lblStrength.numberOfLines = 0;
        lblStrength.lineBreakMode = UILineBreakModeCharacterWrap;
        lblStrength.text = [(PriceObject*)[temp objectAtIndex:i] Strength];
        [cell addSubview:lblStrength];
        
        UILabel* lblPackSize = [[UILabel alloc] initWithFrame:CGRectMake(864, 44*i, 80, 44)];
        lblPackSize.backgroundColor = [UIColor clearColor];
        lblPackSize.textAlignment = UITextAlignmentCenter;
        lblPackSize.numberOfLines = 0;
        lblPackSize.lineBreakMode = UILineBreakModeCharacterWrap;
        lblPackSize.text = [(PriceObject*)[temp objectAtIndex:i] PackSize];
        [cell addSubview:lblPackSize];
        
        UILabel* lblRetailPrice = [[UILabel alloc] initWithFrame:CGRectMake(944, 44*i, 80, 44)];
        lblRetailPrice.backgroundColor = [UIColor clearColor];
        lblRetailPrice.textAlignment = UITextAlignmentCenter;
        lblRetailPrice.numberOfLines = 0;
        lblRetailPrice.lineBreakMode = UILineBreakModeCharacterWrap;
        lblRetailPrice.text = [(PriceObject*)[temp objectAtIndex:i] RetailPrice];
        [cell addSubview:lblRetailPrice];
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
