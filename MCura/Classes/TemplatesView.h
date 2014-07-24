//
//  TemplatesView.h
//  mCura
//
//  Created by Aakash Chaudhary on 09/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ISActivityOverlayController.h"
#import "UserAccountViewController.h"
#import "_GMDocService.h"
#import "proAlertView.h"
#import "Generic.h"
#import "FollowUp.h"
#import "Brand.h"
#import "PharmacyOrder.h"

@interface TemplatesView : UIView<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,NSURLConnectionDelegate,UITextFieldDelegate>{
    IBOutlet UINavigationBar* childNavBar;
    IBOutlet UITextField* templateName;
    IBOutlet UIView* slidingView;
    IBOutlet UIScrollView* pharmacyOrderScrollView;
    IBOutlet UITextField* txtGenerics;
    IBOutlet UITextField* txtBrand;
    PharmacyOrder* currPharmacyOrder;
    NSInteger currentBrandIdIndex;
    NSInteger currentGenericsIndex;
    NSInteger currentPharmacyGlobalIndex;
    NSInteger currentMedFollowUpGlobalIndex;
    NSInteger currentBtnPressedTag;
    NSInteger currentOrderDeleteTag;
    NSMutableArray* currPharmacyOrderArray;
    proAlertView* deleteAlertView;
    Generic* currentGeneric;
    Brand* currentBrand;
     NSString *strgeneric;
}

@property(nonatomic, retain)UserAccountViewController* mParentController;
@property (nonatomic, retain) ISActivityOverlayController *activityController;
@property (nonatomic, retain) _GMDocService *service;
@property (nonatomic, retain) NSArray *genericDtls;
@property(nonatomic,retain) NSMutableArray *uniquebrandDtls;
@property (nonatomic, retain) NSMutableArray *dosageDtls;
@property (nonatomic, retain) NSMutableArray *brandDtls;
@property (nonatomic, retain) NSMutableArray *dosageFrmDtls;
@property (nonatomic, retain) NSMutableArray *brandDtlsForDrugView;
@property (nonatomic, retain) NSArray *instructionDtls;
@property (nonatomic, retain) NSArray *followUpDtls;
@property (nonatomic, retain) NSMutableArray* arrDrugIndices;
@property (nonatomic, retain) IBOutlet UITableView *tblGeneric;
@property (nonatomic, retain) IBOutlet UITableView *tblDosage;
@property (nonatomic, retain) IBOutlet UITableView *tblBrand;
@property (nonatomic, retain) IBOutlet UITableView *tblDosageFrm;
@property (nonatomic, retain) IBOutlet UITableView *tblInstruction;
@property (nonatomic, retain) IBOutlet UITableView *tblFollowUp;
@property (nonatomic, retain) IBOutlet UIButton *btnGeneric;
@property (nonatomic, retain) IBOutlet UIButton *btnBrand;
@property (nonatomic, retain) NSString* TempBrandURL;

-(void)addPharmacyOrder;
-(void)addFieldBtnPressed:(id)sender;
-(id)initWithParent:(UserAccountViewController*)parent;
-(IBAction) submitBtnPressed;
-(IBAction) addBtnPressed;
-(IBAction) clickGenericBtn:(id)sender;
-(IBAction) clickBrandBtn:(id)sender;
-(IBAction) openDrugsIndex:(id)sender;
-(void) clickFollowupBtn:(id)sender;
-(void) clickDosageBtn:(id)sender;
-(void) clickDosageFormBtn:(id)sender;
-(void) clickInstructionBtn:(id)sender;
-(void) setBrand:(Brand*)brand;
-(void) setGeneric:(Generic*)generic;

@end
