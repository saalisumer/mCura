//
//  ScheduleView.h
//  mCura
//
//  Created by Aakash Chaudhary on 07/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomPopoverViewController.h"
#import "STPNDatePickerViewController.h"
#import "STPNDateViewController.h"
#import "UserAccountViewController.h"
#import "ISActivityOverlayController.h"
#import "_GMDocService.h"

@class UserAccountViewController;
@interface ScheduleView : UIView<UIPopoverControllerDelegate,UINavigationControllerDelegate,STPNDatePickerDelegate,PopoverResponseClassDelegate,STPNTimeDelegate,UITableViewDataSource,UITabBarDelegate,NSURLConnectionDelegate,UIAlertViewDelegate,GetScheduleInvocationDelegate,GetSubtenIdInvocationDelegate>{
    IBOutlet UISegmentedControl* topBar;
    IBOutlet UISegmentedControl* specificSegmentControl;
    IBOutlet UISegmentedControl* hrsMinSegCtrl;
    IBOutlet UIView* newScheduleView;
    IBOutlet UIView* moreActionsView;
    IBOutlet UIView* selectDaysView;
    IBOutlet UIView* hideSpecificView;
    IBOutlet UIView* hideSpecificDaysBtnView;
    IBOutlet UITableView* tblSelectPriority;
    IBOutlet UITableView* tblSelectDays;
    IBOutlet UITableView* tblMoreSchedules;
    IBOutlet UIButton* btnFromDate;
    IBOutlet UIButton* btnToDate;
    IBOutlet UIButton* btnFromTime;
    IBOutlet UIButton* btnToTime;
    IBOutlet UIButton* btnFacility;
    IBOutlet UIButton* btnNature;
    IBOutlet UIButton* btnDuration;
    IBOutlet UIButton* btnDays;
    IBOutlet UITextField* txtScheduleName;
    IBOutlet UINavigationBar* childNavBar;
    IBOutlet UIButton* btnMoreActionsFromDate;
    IBOutlet UIButton* btnMoreActionsToDate;
    IBOutlet UIButton* btnEditSchHider;
    NSURLConnection* getPriorityConnection;
    NSURLConnection* getAppIdsConnection;
    NSMutableArray* arrDurationMin;
    NSMutableArray* arrDurationHrs;
    NSMutableArray* arrDays;
    NSMutableArray* arrDaysSmall;
    UIPopoverController *popover;
    NSInteger currSubTenIndex;
    bool isFromDate;
    bool hrsNotMinutes;
    bool todayNotSpecific;
    bool subTenIsSelected[100];
    bool dayIsSelected[100];
    bool isSchEditMode;
    NSInteger priorityIdArray[100];
    NSInteger facilityIdArray[100];
    NSMutableArray* prioritiesArray;
    NSMutableArray* appIdsArray;
    NSMutableArray* prioritiesNamesArray;
    NSInteger facilityId;
    NSInteger priorityId;
    NSInteger editScheduleId;
    NSInteger intDuration;
    int subTenCount;
}

@property (nonatomic, retain) UserAccountViewController* mParentController;
@property (nonatomic, retain) ISActivityOverlayController *activityController;
@property (nonatomic, retain) _GMDocService *service;
@property (nonatomic, retain) UIPopoverController * popover;
@property (nonatomic, retain) NSMutableArray* arraySubTenants;
@property (nonatomic, retain) NSMutableArray* arrPharmaPlusLab;
@property (nonatomic, retain) NSMutableArray* prioritiesArray;
@property (nonatomic, retain) NSMutableArray* appIdsArray;
@property (nonatomic, retain) NSMutableArray* prioritiesNamesArray;
@property (nonatomic, retain) NSMutableArray* arraySubTenantIds;
@property (nonatomic, retain) NSMutableArray* arrayMoreActionScheduleList;

- (id)initWithParent:(UserAccountViewController*)parent;
- (void)reloadDataOfFacility;
- (void)clickEditSchedule:(id)sender;
- (NSInteger)daysBetweenDate:(NSDate*)firstDate andDate:(NSDate*) secondDate;
- (NSString*)militaryToTwelveHr:(NSString*)time;
- (BOOL)isDate:(NSString*)firstDate lessThan:(NSString*)secondDate;
- (IBAction)selectAll;
- (IBAction)selectNone;
- (IBAction)doneBtnPressed;
- (IBAction)cancelBtnPressed;
- (IBAction)doSegmentSwitch:(id)sender;
- (IBAction)btnFacilityClicked;
- (IBAction)btnDurationClicked;
- (IBAction)btnDayslicked;
- (IBAction)btnNatureClicked;
- (IBAction)btnMoreActionstoDateClicked:(id)sender;
- (IBAction)btnMoreActionsFromDateClicked:(id)sender;
- (IBAction)btntoDateClicked:(id)sender;
- (IBAction)btnFromDateClicked:(id)sender;
- (IBAction)btnToTimeClicked:(id)sender;
- (IBAction)btnFromTimeClicked:(id)sender;
- (IBAction)submitBtnClicked;
- (IBAction)cancelBtnClicked;
- (IBAction)searchBtnClicked;
- (IBAction)editDateBtnClicked;

@end
