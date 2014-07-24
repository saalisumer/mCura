//
//  ReferralViewController.h
//  mCura
//
//  Created by Aakash Chaudhary on 16/04/12.
//  Copyright (c) 2012 aakash272@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "_GMDocService.h"
#import "proAlertView.h"
#import "ISActivityOverlayController.h"
#import "CurrentVisitDetailViewController.h"
#import "ChooseActionOptionsController.h"

@interface ReferralViewController : UIViewController<NSURLConnectionDelegate,UIImagePickerControllerDelegate,UITextViewDelegate,UINavigationControllerDelegate,UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate,UIPrintInteractionControllerDelegate,NSURLConnectionDataDelegate,choiceDelegate,UIPopoverControllerDelegate,UINavigationControllerDelegate>{
    IBOutlet UITableView* tblDoctorNames;
    IBOutlet UIButton* btnDoctorName;
    _GMDocService *_service;
    NSInteger currentColor;
    IBOutlet UISegmentedControl* topTabBar;
    IBOutlet UIView* videoView;
    IBOutlet UIView* keyboardView;
    IBOutlet UIView* stylingView;
    IBOutlet UIImageView *handwritingView;
    IBOutlet UITextView* textInputView;
    IBOutlet UILabel* patientMobileLblT;
    IBOutlet UILabel* patientNameLblT;
    IBOutlet UILabel* patientAgeLblT;
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
    NSURLConnection *stylusPicConnection;
    NSURLConnection *videoConnection;
    NSMutableArray* arrayDoctorNames;
    CGPoint lastPoint;
    CGPoint secondLastPoint;
    UIImageView* drawImage;
    UIImage* finalImageToBeSaved;
    UIImagePickerController* imagePicker;
    proAlertView* closeAlertView;
    proAlertView* deleteAlertView;
    proAlertView* saveAlertView;
    proAlertView* stopVidPostAlertView;
    NSInteger noOfItemsToBeUploaded;
    NSInteger currentDoctorSelected;
    NSMutableArray* arrayOfStylistImages;
    NSInteger currentStylistPageIndex;
    NSData* videoData;
    UIPopoverController *popover;
}

@property (nonatomic, retain) _GMDocService *service;
@property (nonatomic, retain) CurrentVisitDetailViewController* mCurrentVisitController;
@property (nonatomic, retain) ISActivityOverlayController *activityController;
@property (nonatomic, retain) NSString* mrNo;
@property (nonatomic, retain) NSString* userRoleId;
@property (nonatomic, retain) NSString* subTenId;
@property (nonatomic, retain) Patdemographics* patient;
@property (nonatomic, retain) NSString* patientNumber;
@property (nonatomic, retain) NSString* docName;
@property (nonatomic, retain) NSString* docAddress;
@property (nonatomic, retain) NSString* docNumber;
@property (nonatomic, retain) NSString* patCity;

-(IBAction) beginVideoRecording;
-(IBAction) clickCancel:(id)sender;
-(IBAction) doSegmentSwitch:(id)sender;
-(IBAction) saveChanges;
-(IBAction) cancelChanges;
-(IBAction) selectColor1;
-(IBAction) selectColor2;
-(IBAction) selectColor3;
-(IBAction) selectColor4;
-(IBAction) selectErase;
-(IBAction) doctorNameBtnClicked;
//-(IBAction) postCurrVideo;
//-(IBAction) cancelCurrVideo;
-(IBAction)cancelCurrVideoPost;
//-(IBAction) sendSMSOptions;
-(void) offerChoices:(NSInteger)type;
-(void) loadAssetFromFile:(NSURL*)exportSession;
-(void) wasDragged:(UIButton *)button withEvent:(UIEvent *)event;
-(void) printdoc;
-(void) SuccessToLoadTable:(NSString*)response;
-(void) didFinishWithCamera;
-(void) PostUploadImage:(NSData*)_imgData;
-(void) PostUploadText:(NSString*)_textString;
-(void) PostUploadVideo:(NSData*)_imgData;
+ (NSDate *)mfDateFromDotNetJSONString:(NSString *)string;

@end
