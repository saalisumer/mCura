//
//  AppointmentViewController.h
//  mCura
//
//  Created by Aakash Chaudhary on 02/04/12.
//  Copyright (c) 2012 aakash272@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppointmentTblCell.h"
#import "CurrentVisitDetailViewController.h"
#import "PatientDetailTblCell.h"
#import "Appointment.h"
#import "Response.h"

@class Patdemographics;
@class _GMDocService; 
@class ISActivityOverlayController;
@class Patient;
@class CurrentVisitDetailViewController;

@interface AppointmentViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate,UITabBarControllerDelegate>{
    AppointmentTblCell *cell;
    Response *res;
    PatientDetailTblCell *cell_Details;
    Patdemographics *pat;
    _GMDocService *_service;
    CurrentVisitDetailViewController *visitDetailController;
    UIPopoverController *popover;
    BOOL keepmeAppointmentBool;
    NSMutableArray* pharmacyOrderArray;
    UIPopoverController *popoverController;
    IBOutlet UITableView* tblSubTenants;
    IBOutlet UIButton* btnSubTenants;
    NSInteger currSubTenIndex;
    NSMutableArray* arraySubTenants;
    NSMutableArray* arraySubTenantIds;
}
@property (nonatomic) NSInteger currentIndex;
@property (nonatomic, retain) NSMutableArray* pharmacyOrderArray;
@property (nonatomic, retain) UIPopoverController * popoverController;
@property (nonatomic, retain) ISActivityOverlayController *activityController;
@property (nonatomic, retain) _GMDocService *service;
@property (nonatomic, retain) Patdemographics *pat;
@property (nonatomic, retain) NSString *patMrno;
@property (nonatomic, retain) IBOutlet UITableView *tblView;
@property (nonatomic, retain) NSArray *patients;
@property (nonatomic, retain) IBOutlet UISearchBar *txtSearch;
@property (nonatomic, retain) IBOutlet UIButton *btnChecked;
@property (nonatomic, retain) NSMutableArray *capturedImages;
@property (nonatomic, retain) UIImagePickerController *imagePicker;
@property (nonatomic, retain) NSArray *patAllergy;
@property (nonatomic, retain) NSArray *patVitals;
@property (nonatomic, retain) NSArray *patHealth;
@property (nonatomic, retain) NSString *patmrno;
@property (nonatomic, retain) NSMutableArray* phone;

- (IBAction)clickCheckBtn:(id)sender;
- (IBAction)btnSubTensPressed;
- (void)openCurrentVisitDetailController;
- (void)back:(id)sender;
-(void)selectLogout:(id)sender;

@end
