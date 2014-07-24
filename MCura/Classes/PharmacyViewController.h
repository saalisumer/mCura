//
//  PharmacyViewController.h
//  mCura
//
//  Created by Aakash Chaudhary on 02/04/12.
//  Copyright (c) 2012 aakash272@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PostUploadOrderTextInvocation.h"
#import "Response.h"
#import "PharmacyOrder.h"
#import "proAlertView.h"
#import "LabOrderViewController.h"
#import "Patdemographics.h"
#import "ChooseActionOptionsController.h"
#import "CurrentVisitDetailViewController.h"
#import "Generic.h"
#import "FollowUp.h"
#import "Brand.h"
#import "CustomStatusBar.h"

@class _GMDocService;
@class ISActivityOverlayController;
@class CurrentVisitDetailViewController;

@interface PharmacyViewController : UIViewController <UITableViewDataSource, UITableViewDelegate,NSURLConnectionDelegate,UIImagePickerControllerDelegate,UITextViewDelegate,UINavigationControllerDelegate,UIAlertViewDelegate,UIPopoverControllerDelegate,UIPrintInteractionControllerDelegate,NSURLConnectionDataDelegate,choiceDelegate,UITextFieldDelegate>{

    _GMDocService *_service;
    id<LabOrderViewControllerDelegate> delegate;
    CGFloat animatedDistance;
    NSInteger currentBrandIdIndex;
    NSInteger currentGenericsIndex;
    NSInteger currentPharmacyGlobalIndex;
    NSInteger currentMedFollowUpGlobalIndex;
    NSInteger currentBtnPressedTag;
    NSInteger currentOrderDeleteTag;
    NSInteger mrNo;
    CurrentVisitDetailViewController* mParentController;
    NSMutableArray* genericsArraySelected;
    NSMutableArray* brandArraySelected;
    NSMutableArray* dosageArraySelected;
    NSMutableArray* followUpArraySelected;
    bool orderAdded;
    NSMutableArray* pharmacyOrderArray;
    IBOutlet UIToolbar* printBtn;
    IBOutlet UIView* slidingView;
    IBOutlet UIView* dataView;
    IBOutlet UIView* keyboardView;
    IBOutlet UIView* stylingView;
    IBOutlet UIView* videoView;
    IBOutlet UIImageView *handwritingView;
    IBOutlet UITextView* textInputView;
    IBOutlet UIScrollView* pharmacyOrderScrollView;
    IBOutlet UILabel* patientMobileLblT;
    IBOutlet UILabel* patientNameLblT;
    IBOutlet UILabel* patientAgeLblT;
    IBOutlet UISegmentedControl* topTabBar;
    IBOutlet UITableView* tblMedicineGlobal;
    IBOutlet UITableView* tblPharmacyGlobal;
    IBOutlet UIButton *btnMedicineGlobal;
    IBOutlet UIButton *btnPharmacyGlobal;
    IBOutlet UINavigationItem* navItem;
    IBOutlet UILabel* lblDocName;
    IBOutlet UILabel* lblDocAddress;
    IBOutlet UILabel* lblDocNumber;
    IBOutlet UILabel* lblDocRow4;
    IBOutlet UILabel* lblPatCity;
    IBOutlet UIView* postVideoView;
    IBOutlet UIImageView* scrollBG;
    IBOutlet UIButton* scrollFG;
    IBOutlet UIScrollView* stylusScrollView;
    IBOutlet UIView* videoPostProgressBar;
    IBOutlet UILabel* progressLbl;
    IBOutlet UIView* postStylusView;
    IBOutlet UIView* stylusProgressBar;
    IBOutlet UILabel* stylusProgressLbl;
    IBOutlet UITextField* txtGenerics;
    IBOutlet UITextField* txtBrand;
    NSURLConnection *stylusPicConnection;
    NSURLConnection *videoConnection;
    NSURLConnection *postOrderConnection;
    CGPoint lastPoint;
    CGPoint secondLastPoint;
    UIImageView* drawImage;
    UIImage* finalImageToBeSaved;
    UIImagePickerController* imagePicker;
    NSInteger currentViewIndex;
    NSMutableData *receivedData;
    NSInteger currentColor;
    proAlertView* saveAlertView;
    proAlertView* deleteAlertView;
    proAlertView* closeScreenAlertView;
    proAlertView* stopVidPostAlertView;
    Response *res;
    UIPopoverController* popover;
    NSString* currTemplateName;
    NSMutableArray* arrayOfStylistImages;
    NSInteger currentStylistPageIndex;
    UIImage* dataImage;
    UIImage* templateDataImage;
    NSData* videoData;
    UIImage* currentImage;
    Generic* currentGeneric;
    Brand* currentBrand;
    NSString *strgeneric;
}

@property (nonatomic, retain) NSMutableArray* currPharmacyOrderArray;
@property (nonatomic, retain) CurrentVisitDetailViewController* mParentController;
@property (assign) id<LabOrderViewControllerDelegate> delegate;
@property (nonatomic, assign) NSInteger mrNo;
@property (nonatomic, retain) ISActivityOverlayController *activityController;
@property (nonatomic, retain) _GMDocService *service;
@property (nonatomic, retain) NSMutableArray *genericDtls;
@property (nonatomic, retain) NSMutableArray *dosageDtls;
@property (nonatomic, retain) NSMutableArray *brandDtls;
@property (nonatomic, retain) NSString* BrandURL;
@property (nonatomic, retain) NSMutableArray *UniquebrandDtls;
@property (nonatomic, retain) NSMutableArray *brandDtlsForDrugView;
@property (nonatomic, retain) NSMutableArray *dosageFrmDtls;
@property (nonatomic, retain) NSArray *instructionDtls;
@property (nonatomic, retain) NSArray *followUpDtls;
@property (nonatomic, retain) NSArray *pharmacyDtls;
@property (nonatomic, retain) NSArray *templatesArray;
@property (nonatomic, retain) NSMutableArray* arrDrugIndices;
@property (nonatomic, retain) IBOutlet UITableView *tblGeneric;
@property (nonatomic, retain) IBOutlet UITableView *tblDosage;
@property (nonatomic, retain) IBOutlet UITableView *tblBrand;
@property (nonatomic, retain) IBOutlet UITableView *tblDosageFrm;
@property (nonatomic, retain) IBOutlet UITableView *tblInstruction;
@property (nonatomic, retain) IBOutlet UITableView *tblFollowUp;
@property (nonatomic, retain) IBOutlet UITableView *tblTemplates;
@property (nonatomic, retain) IBOutlet UIButton *btnGeneric;
@property (nonatomic, retain) IBOutlet UIButton *btnBrand;
@property (nonatomic, retain) Patdemographics* patient;
@property (nonatomic, retain) NSString* patientNumber;
@property (nonatomic, retain) NSString* docName;
@property (nonatomic, retain) NSString* docAddress;
@property (nonatomic, retain) NSString* docNumber;
@property (nonatomic, retain) PharmacyOrder* currPresFromTemplate;
@property (nonatomic, retain) NSString* patCity;
@property (nonatomic, assign) NSInteger pharmacyReportRecNatureIndex;


-(IBAction) clickCancel:(id)sender;
-(IBAction) clickOrderButton:(id)sender;
-(IBAction) clickGenericBtn:(id)sender;
-(IBAction) clickBrandBtn:(id)sender;
-(IBAction) clickMedicineGlobalBtn:(id)sender;
-(IBAction) clickPharmacyGlobalBtn:(id)sender;
-(IBAction) clickTemplateBtn:(id)sender;
-(IBAction) addBtnPressed;
-(IBAction) doSegmentSwitch:(id)sender;
-(IBAction) saveChanges;
-(IBAction) cancelChanges;
-(IBAction) beginVideoRecording;
-(IBAction) selectColor1;
-(IBAction) selectColor2;
-(IBAction) selectColor3;
-(IBAction) selectColor4;
-(IBAction) selectErase;
-(IBAction) cancelCurrVideoPost;
-(IBAction) sendSMSOptions;
-(IBAction) openDrugsIndex:(id)sender;
-(IBAction) printdoc;
-(void) offerChoices:(NSInteger)type;
-(void) loadAssetFromFile:(NSURL*)exportSession;
-(void) wasDragged:(UIButton *)button withEvent:(UIEvent *)event;
-(void) addFieldBtnPressed:(id)sender;
-(void) deleteRecordBtnPressed:(id)sender;
-(void) SuccessToLoadTable:(NSString*)response;
-(void) didFinishWithCamera;
-(void) PostUploadImage:(NSData*)_imgData;
-(void) PostUploadText:(NSString*)_textString;
-(void) PostUploadVideo:(NSData*)_imgData;
-(void) setBrand:(Brand*)brand;
-(void) setGeneric:(Generic*)generic;
+(NSDate*) mfDateFromDotNetJSONString:(NSString *)string;
+(NSString*) AgeFromString:(NSString*)dob;

@end




