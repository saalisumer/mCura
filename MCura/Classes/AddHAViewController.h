//
//  AddHAViewController.h
//  mCura
//
//  Created by Aakash Chaudhary on 20/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STPNDatePickerViewController.h"
#import "ISActivityOverlayController.h"
#import "LabOrderViewController.h"
#import "_GMDocService.h"
#import "GetPatientAllergyInvocation.h"
#import "GetAllergyInvocation.h"

@class proAlertView;
@interface AddHAViewController : UIViewController<UIAlertViewDelegate,UINavigationControllerDelegate,UIPopoverControllerDelegate,STPNDatePickerDelegate,NSURLConnectionDelegate,GetAllergyInvocationDelegate,GetPatientAllergyInvocationDelegate,GetPatientHealthInvocationDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>{
    IBOutlet UILabel* titleLbl;
    IBOutlet UILabel* firstLbl;
    IBOutlet UILabel* secondLbl;
    IBOutlet UIButton* btnDate;
    IBOutlet UIButton* btnType;
    IBOutlet UIButton* btnName;
    IBOutlet UIButton* btnVital;
    IBOutlet UITableView* typeTable;
    IBOutlet UITableView* nameTable;
    IBOutlet UITableView* vitalTable;
    IBOutlet UIView* vitalView;
    IBOutlet UITextField* reading;
    IBOutlet UITextField* otherInfo;
    IBOutlet UITextField* remarks;
    proAlertView* closeAlertView;
    proAlertView* saveAlertView;
    NSInteger typeIndex;
    NSInteger nameIndex;
    NSInteger vitalIndex;
}

@property (nonatomic,retain) _GMDocService *service;
@property (nonatomic,retain) UIPopoverController * popover;
@property (assign) NSInteger healthAllergyOrVital;//0-health,1-allergy,2-vital
@property (nonatomic,retain) NSString* mrNo;
@property (nonatomic,retain) NSString* userRoleId;
@property (nonatomic,retain) NSString* subTenId;
@property (nonatomic,retain) ISActivityOverlayController *activityController;
@property (assign) id<LabOrderViewControllerDelegate> delegate;
@property (nonatomic, retain) NSMutableArray* vitalsArray;
@property (nonatomic, retain) NSMutableArray* typeArray;
@property (nonatomic, retain) NSMutableArray* nameArray;

-(IBAction) clickFromDate:(id)sender;
-(IBAction) clickTypeBtn:(id)sender;
-(IBAction) clickNameBtn:(id)sender;
-(IBAction) clickVitalBtn:(id)sender;
-(IBAction)submitBtnPressed:(id)sender;
-(IBAction)cancelBtnPrsd:(id)sender;

@end
