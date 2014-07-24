//
//  STPNDatePickerViewController.m
//  3GMDoc
//
//  Created by sandeep agrawal on 08/01/12.
//  Copyright (c) 2012 student.san1986@gmail.com. All rights reserved.
//

#import "STPNDatePickerViewController.h"

@implementation STPNDatePickerViewController

@synthesize datePicker, delegate;

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

-(IBAction)clickBtnDone:(id)sender{

    NSDate * selectedDate = self.datePicker.date;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat: @"dd-MMM-yyyy"]; 
    
    NSString *stringFromDate = [formatter stringFromDate:selectedDate];
    [formatter release];
    
    if(self.delegate != nil){
        [self.delegate closePopUpDate:stringFromDate];
    }
}

-(IBAction)clickBtnCancel:(id)sender{
    if(self.delegate != nil){
         [self.delegate closePopUpDate:nil];
    }
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
