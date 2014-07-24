//
//  DocCurrVisitViewController.h
//  mCura
//
//  Created by Aakash Chaudhary on 05/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ISActivityOverlayController.h"
#import "CompareImagePopupVC.h"
#import "PatMedRecords.h"
#import "_GMDocService.h"
#import "Patdemographics.h"
#import "proAlertView.h"
#import "CurrentVisitDetailViewController.h"

@interface DocCurrVisitViewController : UIViewController<NSURLConnectionDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate,CompareImgPopoverDelegate,UIPopoverControllerDelegate,UIScrollViewDelegate,NSURLConnectionDataDelegate,UIPrintInteractionControllerDelegate>{
    
    _GMDocService *_service;
    UIPopoverController *popover;
    IBOutlet UIView* photoView;
    IBOutlet UIView* videoView;
    IBOutlet UIView* comparisonView;
    IBOutlet UIButton* firstImgBtn;
    IBOutlet UIButton* secondImgBtn;
    IBOutlet UIButton* lockBtn;
    IBOutlet UIScrollView* firstScrollView;
    IBOutlet UIScrollView* secondScrollView;
    IBOutlet UISegmentedControl* topTabBar;
    IBOutlet UILabel* lblDocName;
    IBOutlet UILabel* lblDocAddress;
    IBOutlet UILabel* lblDocNumber;
    IBOutlet UILabel* lblDocRow4;
    IBOutlet UILabel* patientMobileLblT;
    IBOutlet UILabel* patientNameLblT;
    IBOutlet UILabel* patientAgeLblT;
    IBOutlet UIView* postVideoView;
    IBOutlet UILabel* lblPatCity;
    IBOutlet UIView* videoPostProgressBar;
    IBOutlet UILabel* progressLbl;
    IBOutlet UIView* postStylusView;
    IBOutlet UIView* stylusProgressBar;
    IBOutlet UILabel* stylusProgressLbl;
    NSURLConnection *stylusPicConnection;
    NSURLConnection *videoConnection;
    NSURLConnection* postFileConnection;
    UIImagePickerController* imagePicker;
    proAlertView* deleteVideoAlertView;
    proAlertView* deleteImageAlertView;
    proAlertView* closeAlertView;
    proAlertView* stopVidPostAlertView;
    NSInteger currBtnIndex;
    UIButton* currBtnTapped;
    bool zoomTogether;
    NSData* videoData;
    UIImage* currentImage;
}

@property (nonatomic, retain) CurrentVisitDetailViewController* mParentController;
@property (nonatomic, retain) ISActivityOverlayController *activityController;
@property (nonatomic, retain) _GMDocService *service;
@property (nonatomic, retain) NSString* mrNo;
@property (nonatomic, retain) NSString* userRoleId;
@property (nonatomic, retain) NSMutableArray* listOfRecords;
@property (nonatomic, retain) Patdemographics* patient;
@property (nonatomic, retain) NSString* patientNumber;
@property (nonatomic, retain) NSString* docName;
@property (nonatomic, retain) NSString* docAddress;
@property (nonatomic, retain) NSString* docNumber;
@property (nonatomic, assign) NSInteger labReportRecNatureIndex;
@property (nonatomic, assign) NSInteger currVisitRecNatureIndex;
@property (nonatomic, retain) NSString* patCity;
@property (nonatomic, retain) NSMutableArray *dateDtls;
@property (nonatomic, retain) NSMutableArray *doctorNamesArray;
@property (nonatomic, retain) NSMutableArray *imageDtls;
@property (nonatomic, retain) NSString* currentImagePath;

-(IBAction) beginVideoRecording;
-(IBAction) takePhoto;
-(IBAction) doSegmentSwitch:(id)sender;
-(IBAction) closePopup;
-(IBAction) toggleZoomTogether:(id)sender;
-(IBAction) choosePhotoA:(id)sender;
-(IBAction) choosePhotoB:(id)sender;
-(IBAction) cancelCurrVideoPost;
-(void) loadAssetFromFile:(NSURL*)exportSession;
-(void) ShowPopover;
-(void) SuccessToLoadTable:(NSString*)response;
-(void) didFinishWithCamera;
-(void) PostUploadImage:(NSData*)_imgData;
-(void) PostUploadVideo:(NSData*)_vidData;

@end
