//
//  CurrentVisitDetailViewController.h
//  mCura
//
//  Created by Aakash Chaudhary on 02/04/12.
//  Copyright (c) 2012 aakash272@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NatureTblCell.h"
#import "LabOrderViewController.h"
#import "PharmacyViewController.h"
#import "PatientDetailTblCell.h"
#import "Patdemographics.h"
#import "PatMedRecords.h"
#import "Response.h"
#import "Schedule.h"
#import "PatientComplaint.h"
#import "NSData+Base64.h"
#import "Utilities.h"
#import "CorePlot-CocoaTouch.h"
#import "NotesViewController.h"
#import "CompareImagesViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "proAlertView.h"
#import "UserDetail.h"
#import "PatientAddress.h"
#import "PatientContactDetails.h"

@class Patdemographics;
@class _GMDocService;
@class ISActivityOverlayController;
@interface CurrentVisitDetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate,UIPopoverControllerDelegate ,UINavigationControllerDelegate,UITextFieldDelegate,UITextViewDelegate,NSURLConnectionDelegate,GetPatMedRecordsInvocationDelegate,CPTPlotDataSource,UIScrollViewDelegate,UIPopoverControllerDelegate>{
    
    _GMDocService *_service;
    Patdemographics *pat;
    NatureTblCell *cell;
    PatientDetailTblCell* cell1;
    NSMutableArray* phone;
    bool labOrderExpanded;
    CGPoint lastPoint;
    CGPoint secondLastPoint;
	UIImageView *drawImage;
    NSInteger currentColor;
    BOOL isHandwritingEnabled;
    NSMutableArray* pharmacyOrderArray;
    IBOutlet UIButton* daysBtn;
    IBOutlet UIButton* hrsBtn;
    IBOutlet UIButton* monthsBtn;
    IBOutlet UIButton* yrsBtn;
    IBOutlet UIButton* progressionBtn;
    IBOutlet UIButton* regressionBtn;
    IBOutlet UITextView* chiefComplaintTxtVw;
    IBOutlet UITextField* onsetTxtVw;
    IBOutlet UITextField* durationTxtVw;
    IBOutlet UIButton* severityBtn;
    IBOutlet UITextView* otherSymptomsTxtVw;
    IBOutlet UITextView* associatedSymptomsTxtVw;
    IBOutlet UITextField* pastEpisodesTxtVw;
    IBOutlet UIButton* saveBtn;
    IBOutlet UIButton* cancelBtn;
    NSInteger hrsDaysMonYrsIndex;
    BOOL progressionNotRegression;
    NSInteger currentCount;
    NSInteger currentSeverity;
    IBOutlet UIButton* addComplaintBtn;
    IBOutlet UIButton* addMoreComplaintBtn;
    BOOL editCompliance;
    BOOL popoverVisible;
    IBOutlet UIView* labOrderView;
    NSInteger currentComplaintId;
    NSMutableArray* currPharmacyOrderArray;
    IBOutlet UIView* pharmacyOrderView;
    IBOutlet UIView* pharmacyOrderInnerView;
    IBOutlet UIScrollView* pharmacyOrderScrollView;
    IBOutlet UIImageView* labOrderImgView;
    NSInteger complaintLabOrPharmacyIndex;
    bool sortingOfArraysIsNotDone;
    bool postImageCase;
    CPTXYGraph *graph;
    IBOutlet UIButton* addLabOrderButton;
    IBOutlet UIButton* saveLabOrderButton;
    IBOutlet UIButton* cancelLabOrderButton;
    IBOutlet UILabel* labOrderTopLbl;
    IBOutlet UILabel* labOrderBottomLbl;
    IBOutlet UIButton* vitalsBtn;
    IBOutlet UILabel* prescriptionOrTemplateLbl;
    BOOL isTemplateNotPrescription;
    proAlertView* profileOptionsAlert;
    proAlertView* labOrderOptionsAlert;
    proAlertView* saveLabReportChangesAlert;
    proAlertView* compareImagesAlert;
    proAlertView* sendSmsAlert;
    proAlertView* sendThanksAlert;
    NSString* currentVitalsSortString;
    NSString* patientCityString;
    NSMutableArray* vitalsNamesArray;
    NSMutableArray* vitalsValuesArray;
    bool isVitalsSorted;
    NSInteger currentVitalsCount;
    NSInteger complaintsRecNatureId;
    NSInteger labReportRecNatureId;
    NSInteger pharmacyOrderRecNatureId;
    NSInteger labOrderRecNatureId;
    NSInteger doctorNoteRecNatureId;
    NSInteger currentVisitImageRecNatureId;
    NSInteger doctorCommentsRecNatureId;
    NSInteger referralsRecNatureId;
    NSInteger templateRecNatureId;
    NSInteger planRecNatureId;
    NSInteger currentSmsIndex;
    UIImage* previousNotesImageClicked;
    UIWebView* docView;
    UIViewController* pdfOrDocController;
    bool getDocDetails;
    BOOL isCurrentVisitImage;
    BOOL shouldReopenPdfPopover;
}

@property (nonatomic, retain) UIPopoverController *popover;
@property (nonatomic, retain) UserDetail* currLoggedInDoctor;
@property (nonatomic, retain) PatientContactDetails* currDocContact;
@property (nonatomic, retain) PatientAddress* currDocAddress;
@property (nonatomic, retain) UIImage* finalImageToBeSaved;
@property (nonatomic, retain) Response *res;
@property (nonatomic, retain) Schedule *sec;
@property (nonatomic, retain) NSMutableArray* vitalsArray;
@property (nonatomic, retain) NSMutableArray* healthArray;
@property (nonatomic, retain) NSMutableArray* allergiesArray;
@property (nonatomic, retain) NSMutableArray* pharmacyOrderArray;
@property (nonatomic, retain) ISActivityOverlayController *activityController;
@property (nonatomic, retain) _GMDocService *service;
@property (nonatomic, retain) Patdemographics *pat;
@property (nonatomic, retain) IBOutlet UILabel *lblName;
@property (nonatomic, retain) IBOutlet UILabel *lblAge;
@property (nonatomic, retain) IBOutlet UILabel *lblSex;
@property (nonatomic, retain) IBOutlet UILabel *lblNumber;
@property (nonatomic, retain) IBOutlet UILabel *lblDOB;
@property (nonatomic, retain) IBOutlet UIButton *profileImage;
@property (nonatomic, retain) IBOutlet UITableView *natureTblView;
@property (nonatomic, retain) IBOutlet UITableView *allergiesTblView;
@property (nonatomic, retain) IBOutlet UITableView *vitalsTblView;
@property (nonatomic, retain) IBOutlet UITableView *healthConditionTblView;
@property (nonatomic, retain) IBOutlet UITableView *severitiesTblView;
@property (nonatomic, retain) NSMutableArray *dateDtls;
@property (nonatomic, retain) NSMutableArray *nameDtls;
@property (nonatomic, retain) NSMutableArray *imageDtls;
@property (nonatomic, retain) NSMutableArray *capturedImages;
@property (nonatomic, retain) UIImagePickerController *imagePicker;
@property (nonatomic, assign) NSInteger currentColor;
@property (nonatomic, retain) NSString * mrno;
@property (nonatomic, retain) NSMutableArray* patMedRecordsArray;
@property (nonatomic, retain) NSMutableArray *doctorNamesArray;
@property (nonatomic, retain) NSMutableArray *severitiesArray;
@property (nonatomic, retain) PatientComplaint* currentComplaint;
@property (nonatomic, retain) NSMutableArray* phone;
@property (assign) NSInteger currentIndex;
@property (assign) bool hideNextPatientButton;
@property (nonatomic, retain) IBOutlet UIButton* nextPatientBtn;
@property (nonatomic, retain) NSString* currentDoctor;
@property (nonatomic, retain) NSString* patientCityString;
@property (nonatomic, retain) NSString* previousPatMob;
@property (nonatomic, retain) NSString* previousPatEmail;

-(void)back:(id)sender;
-(void)didTakePicture:(UIImage *)picture;
-(void)didFinishWithCamera;
-(void)setImageView;
-(void)showPharmacyOrder;
-(void)setupPatientData;
-(void)showGraphInPopup;
-(void)setPatientDetailsLabels:(Patdemographics*)pat;
-(void)PostUploadImage:(NSData*)_imgData;
-(void)SuccessToLoadTable:(NSString*)response;
-(void)SuccessToPostImage:(NSString*)response;
-(void)moviePlaybackComplete:(NSNotification *)notification;
-(void)showHelpView;
-(void)closeCurrImagery;
-(void)didOpenPharmacyOrder;
-(void)labOrderDidSubmit;
-(void)logoutUser;
-(void)checkOnlyPatient;
-(void)addRecord:(PatMedRecords*)record;
-(bool)arePoints:(CGPoint)pointA And:(CGPoint)pointB InsideViewFrame:(CGRect)frame;
-(UIImage*)resizeImage:(UIImage*) image size:(CGSize) size;
+(NSDate *)mfDateFromDotNetJSONString:(NSString *)string;
-(UIImage *)imageWithColor:(UIColor *)color;
-(NSString*)editExistsFrom:(NSString*)existsFrom;
+(NSString*)AgeFromString:(NSString*)dob;
-(void)selectLogout:(id)sender;
-(IBAction)viewUserReportOpen:(id)sender;
-(IBAction)addUserImageFromLibrary:(id)sender;
-(IBAction)cancelChanges;
-(IBAction)saveChanges;
-(IBAction)didOpenLabRecord:(id)sender;
-(IBAction)daysBtnPrsd;
-(IBAction)hrsBtnPrsd;
-(IBAction)monthsBtnPrsd;
-(IBAction)yrsBtnPrsd;
-(IBAction)progressionBtnPrsd;
-(IBAction)regressionBtnPrsd;
-(IBAction)submitComplianceEntry;
-(IBAction)cancelComplianceEntry;
-(IBAction)severitiesBtnPrssd;
-(IBAction)addComplaintBtnPrsd;
-(IBAction)addMoreComplaintBtnPrsd;
-(IBAction)takeVideo;
-(IBAction)nextPatient;
-(IBAction)searchPatient;
-(IBAction)addPatient;
-(IBAction)showAllElementsOfNatureTable;
-(IBAction)sortLabOrder;
-(IBAction)sortPharmacyOrder;
-(IBAction)showDrugView;
-(IBAction)showCurrentVisitsView;
-(IBAction)vitalsBtnClicked;
-(IBAction)unitsBtnClicked;
-(IBAction)closePharmacyOrderView;
-(IBAction)selectColor1;
-(IBAction)selectColor2;
-(IBAction)selectColor3;
-(IBAction)selectColor4;
-(IBAction)selectErase;
-(IBAction)openReferralView;
-(IBAction)addHealthCondition:(id)sender;
-(IBAction)addAllergy:(id)sender;
-(IBAction)addVital:(id)sender;

@end
