//
//  DrugViewController.h
//  mCura
//
//  Created by Aakash Chaudhary on 02/04/12.
//  Copyright (c) 2012 aakash272@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ISActivityOverlayController.h"
#import "_GMDocService.h"
#import "proAlertView.h"
#import "Generic.h"
#import "Brand.h"
#import "PharmacyViewController.h"
#import "TemplatesView.h"

@interface DrugViewController : UIViewController<GetDrugIndexInvocationDelegate,UITextViewDelegate,UITableViewDataSource,UITableViewDelegate,GetStringInvocationDelegate,UITextFieldDelegate,UIAlertViewDelegate,UIPopoverControllerDelegate,GetBrandInvocationDelegate,GetBrandIDDelegate,UITabBarControllerDelegate>{
    _GMDocService *_service;
    IBOutlet UITableView* tblGeneric;
    IBOutlet UITableView *tblBrand;
    IBOutlet UITableView* tblSafety;
    IBOutlet UITableView* tblSideEffects;
    IBOutlet UITableView* tblPrice;
    IBOutlet UITextView* txtDosage;
    IBOutlet UITextView* txtCrossRtn;
    IBOutlet UITextView* txtModeOfAction;
    IBOutlet UIButton* btnGeneric;
    IBOutlet UIButton *btnBrand;
    IBOutlet UITextField* txtGenerics;
    IBOutlet UITextField* txtTopBrand;
    UIPopoverController *popover;
    NSInteger selectedIndex;
    Generic *currentGeneric;
    Brand *currentBrand;
    NSMutableArray *brandDtls;
    NSMutableArray *brandDtlsForDrugView;
    NSString *strgeneric;
    IBOutlet UINavigationBar *navBar;
}

@property (nonatomic, retain) PharmacyViewController* pharmacyParentController;
@property (nonatomic, retain) TemplatesView* templateParentView;
@property (nonatomic, retain) NSMutableArray* arrDrugIndices;
@property (nonatomic, retain) NSMutableArray* arrBrands;
@property (nonatomic, retain) NSMutableArray* arrSafetyNames;
@property (nonatomic, retain) NSMutableArray* arrSafetyStatus;
@property (nonatomic, retain) NSMutableArray* arrDrugPrices;
@property (nonatomic, retain) NSMutableArray* arrSideEffects;
@property (nonatomic, assign) NSInteger genericId;
@property (nonatomic, assign) NSInteger brandId;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, retain) Generic* selectedGeneric;
@property (nonatomic, retain) Brand* selectedBrand;
@property (nonatomic, retain) ISActivityOverlayController *activityController;
@property (nonatomic, retain) _GMDocService *service;
@property (nonatomic, assign) BOOL isparentView;

-(IBAction) closePopup;
-(IBAction) btnGenericClicked:(id)sender;
-(IBAction) clickBrandBtn:(id)sender;
-(IBAction) expandTextView:(id)sender;
-(IBAction) expandTableView:(id)sender;
-(void) closePopover;

@end
