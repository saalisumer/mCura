//
//  NotesViewController.h
//  mCura
//
//  Created by Aakash Chaudhary on 30/03/12.
//  Copyright (c) 2012 aakash272@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ISActivityOverlayController.h"
#import "CurrentVisitDetailViewController.h"
#import "proAlertView.h"
#import "Patdemographics.h"
#import "ChooseActionOptionsController.h"

@class _GMDocService;
@class CurrentVisitDetailViewController;
@interface NotesViewController : UIViewController<NSURLConnectionDelegate,UIImagePickerControllerDelegate,UITextViewDelegate,UINavigationControllerDelegate,UIAlertViewDelegate,UIPrintInteractionControllerDelegate,NSURLConnectionDataDelegate,choiceDelegate,UIPopoverControllerDelegate,UINavigationControllerDelegate>{
    _GMDocService *_service;
    NSInteger currentColor;
    IBOutlet UISegmentedControl* topTabBar;
    IBOutlet UIToolbar* printBtn;
    IBOutlet UIView* videoView;
    IBOutlet UIView* keyboardView;
    IBOutlet UIView* stylingView;
    IBOutlet UIImageView *handwritingView;
    IBOutlet UITextView* textInputView;
    IBOutlet UILabel* topLabel;
    IBOutlet UILabel* patientMobileLblT;
    IBOutlet UILabel* patientNameLblT;
    IBOutlet UILabel* patientAgeLblT;
    IBOutlet UILabel* lblDocName;
    IBOutlet UILabel* lblDocAddress;
    IBOutlet UILabel* lblDocNumber;
    IBOutlet UILabel* lblDocRow4;
    IBOutlet UILabel* lblPatCity;
    IBOutlet UIImageView* scrollBG;
    IBOutlet UIButton* scrollFG;
    IBOutlet UIScrollView* stylusScrollView;
    IBOutlet UIView* postVideoView;
    IBOutlet UIView* videoPostProgressBar;
    IBOutlet UILabel* progressLbl;
    IBOutlet UIView* postStylusView;
    IBOutlet UIView* stylusProgressBar;
    IBOutlet UILabel* stylusProgressLbl;
    IBOutlet UIView* sendMsgView;
    NSURLConnection *stylusPicConnection;
    NSURLConnection *videoConnection;
    CGPoint lastPoint;
    CGPoint secondLastPoint;
    UIImageView* drawImage;
    UIImagePickerController* imagePicker;
    proAlertView* closeAlertView;
    proAlertView* deleteAlertView;
    proAlertView* deleteCurrentPageAlertView;
    proAlertView* saveAlertView;
    proAlertView* stopVidPostAlertView;
    NSInteger noOfItemsToBeUploaded;
    NSMutableArray* arrayOfStylistImages;
    NSInteger currentStylistPageIndex;
    NSData* videoData;
    UIPopoverController *popover;
}

@property (nonatomic, retain) CurrentVisitDetailViewController* mCurrentVisitController;
@property (nonatomic, retain) ISActivityOverlayController *activityController;
@property (nonatomic, retain) Patdemographics* patient;
@property (nonatomic, retain) NSString* patientNumber;
@property (nonatomic, retain) NSString* mrNo;
@property (nonatomic, retain) NSString* userRoleId;
@property (assign) NSInteger viewIndex;//0 for doctor advice, 1 for plan, 2 for complaint
@property (nonatomic, retain) NSString* docName;
@property (nonatomic, retain) NSString* docAddress;
@property (nonatomic, retain) NSString* docNumber;
@property (nonatomic, retain) NSString* patCity;
@property (nonatomic, assign) NSInteger currentRecNatureId;

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
-(IBAction) cancelCurrVideoPost;
-(IBAction) printdoc;
-(IBAction) sendSMSOptions;
-(void) offerChoices:(NSInteger)type;
-(void) loadAssetFromFile:(NSURL*)exportSession;
-(void) wasDragged:(UIButton *)button withEvent:(UIEvent *)event;
-(void) SuccessToLoadTable:(NSString*)response;
-(void) didFinishWithCamera;
-(void) PostUploadImage:(NSData*)_imgData;
-(void) PostUploadText:(NSString*)_textString;
-(void) PostUploadVideo:(NSData*)_imgData;

@end
