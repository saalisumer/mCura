//
//  LabOrderViewController.h
//  mCura
//
//  Created by Aakash Chaudhary on 02/04/12.
//  Copyright (c) 2012 aakash272@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetLabInvocation.h"
#import "GetLabGroupTestInvocation.h"
#import "GetLabPackageInvocation.h"
#import "GetLabTestListInvocation.h"
#import "_GMDocService.h"
#import "ISActivityOverlayController.h"
#import "GetSubtenIdInvocation.h"
#import "GetScheduleInvocation.h"
#import "proAlertView.h"
#import "Patdemographics.h"

@protocol LabOrderViewControllerDelegate <NSObject>

- (void) labOrderDidSubmit;
- (void) closePopup;

@end

@interface LabOrderViewController : UIViewController<UITableViewDataSource, UITableViewDelegate,NSURLConnectionDelegate,NSURLConnectionDataDelegate,GetLabInvocationDelegate,UIPopoverControllerDelegate,GetLabPackageInvocationDelegate,GetLabGroupTestInvocationDelegate,GetLabTestListInvocationDelegate,GetSubtenIdInvocationDelegate,UITextViewDelegate,UINavigationControllerDelegate,UIAlertViewDelegate,GetScheduleInvocationDelegate,UIPrintInteractionControllerDelegate,GetStringInvocationDelegate>{
    
    _GMDocService *_service;
    id<LabOrderViewControllerDelegate> delegate;
    CGFloat animatedDistance;
    NSMutableArray* labsArray;
    NSMutableArray* packagesArray;
    NSMutableArray* groupsArray;
    NSMutableArray* arrayOfGroupsArrays;
    NSMutableArray* arrayOfPackageTestsArray;
    NSMutableArray* testListArray;
    NSInteger currentFacilitySelectedIndex;
    UIDatePicker  *datePicker;
    NSDate* dateObject;
    UIPopoverController* popover;
    NSInteger currentPackageSelectedIndex;
    NSInteger currentGroupSelectedIndex;
    NSInteger currentTestSelectedIndex;
    IBOutlet UISegmentedControl* topTabBar;
    IBOutlet UIView* dataView;
    IBOutlet UIView* keyboardView;
    IBOutlet UIView* stylingView;
    IBOutlet UIButton* btnFacility;
    IBOutlet UIButton* dateBtn;
    IBOutlet UILabel* patientNameLbl;
    IBOutlet UILabel* patientMobileLblT;
    IBOutlet UILabel* patientAgeLblT;
    IBOutlet UILabel* lblPatCity;
    IBOutlet UIImageView *handwritingView;
    IBOutlet UITextView* textInputView;
    IBOutlet UILabel* lblDocName;
    IBOutlet UILabel* lblDocAddress;
    IBOutlet UILabel* lblDocNumber;
    IBOutlet UILabel* lblDocRow4;
    IBOutlet UIImageView* scrollBG;
    IBOutlet UIButton* scrollFG;
    IBOutlet UIScrollView* stylusScrollView;
    IBOutlet UIView* postStylusView;
    IBOutlet UIView* stylusProgressBar;
    IBOutlet UILabel* stylusProgressLbl;
    NSURLConnection *stylusPicConnection;
    NSURLConnection* postOrderConnection;
    CGPoint lastPoint;
    CGPoint secondLastPoint;
    UIImageView* drawImage;
    UIImage* finalImageToBeSaved;
    NSInteger currentViewIndex;
    NSMutableData *receivedData;
    NSInteger currentColor;
    bool packagesSelectedArray[100];
    bool groupsSelectedArray[100];
    bool testsSelectedArray[100];
    bool packagesExpandedArray[100];
    proAlertView* closeAlertView;
    proAlertView* closeOrderAlertView;
    proAlertView* deleteAlertView;
    proAlertView* deleteCurrentPageAlertView;
    proAlertView* saveAlertView;
    proAlertView* stopStylusPostAlertView;
    NSInteger currentDay;
    NSInteger currentMonth;
    NSInteger currentYear;
    NSString* subTenIdString;
    NSMutableArray* schedulesArray;
    NSInteger currentSchedule;
    NSInteger oldExpandedIndex;
    NSMutableArray* arrayOfStylistImages;
    NSInteger currentStylistPageIndex;
    NSString* lastPackageId;
    NSInteger expandedGroupTableIndexPath;
}

@property (nonatomic, retain) NSIndexPath* expandedGroupIndexPath;
@property (nonatomic, retain) NSString* lastPackageId;
@property (nonatomic, retain) ISActivityOverlayController *activityController;
@property (assign) NSString* mrNo;
@property (assign) NSString* userRoleId;
@property (assign) id<LabOrderViewControllerDelegate> delegate;
@property (nonatomic, retain) Patdemographics* patient;
@property (nonatomic, retain) IBOutlet UITableView *tblFacility;
@property (nonatomic, retain) IBOutlet UITableView *tblPackages;
@property (nonatomic, retain) IBOutlet UITableView *tblGroups;
@property (nonatomic, retain) IBOutlet UITableView *tblTestList;
@property (nonatomic, retain) NSString* patientNumber;
@property (nonatomic, retain) NSString* docName;
@property (nonatomic, retain) NSString* docAddress;
@property (nonatomic, retain) NSString* docNumber;
@property (nonatomic, retain) NSString* patCity;

-(IBAction) closePopup:(id)sender;
-(IBAction) clickCancel:(id)sender;
-(IBAction) facilityBtnPressed;
-(IBAction) submitOrder;
-(IBAction) timePopupBtnPressed;
-(IBAction) doSegmentSwitch:(id)sender;
-(IBAction) saveChanges;
-(IBAction) cancelChanges;
-(IBAction) selectColor1;
-(IBAction) selectColor2;
-(IBAction) selectColor3;
-(IBAction) selectColor4;
-(IBAction) selectErase;
-(IBAction) cancelCurrStylusPost;
-(void)wasDragged:(UIButton *)button withEvent:(UIEvent *)event;
-(void)PostUploadImage:(NSData*)_imgData;
-(void)PostUploadText:(NSString*)_textString;
-(void)SuccessToLoadTable:(NSString*)response;
-(void)dateChanged;
-(void)toggleSectionPackages:(id)sender;
-(void)toggleGroupTblTests:(id)sender;

@end
