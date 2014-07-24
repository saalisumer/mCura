//
//  STPNMoveAppointmentViewController.h
//  3GMDoc

#import <UIKit/UIKit.h>
#import "ISActivityOverlayController.h"

@protocol STPNMoveAppointmentDelegate <NSObject>

- (void) closePopup:(BOOL)reloadData;

@end

@class _GMDocService;

@interface STPNMoveAppointmentViewController : UIViewController <UITabBarDelegate, UITableViewDataSource>{

    CGPoint offset;
    UITextField *activeField;
    CGFloat animatedDistance;
    id <STPNMoveAppointmentDelegate> delegate;
    _GMDocService *_service;
    UIPopoverController * _popover;
    NSInteger currAvlSlotSelIndex;
}

@property (nonatomic, retain) UIPopoverController * popover;
@property (nonatomic, retain) _GMDocService *service;
@property (assign) id<STPNMoveAppointmentDelegate> delegate;
@property (nonatomic, retain) IBOutlet UILabel *lblSecName;
@property (nonatomic, retain) IBOutlet UILabel *lblSecTime;
@property (nonatomic, retain) IBOutlet UILabel *lblAppTime;
@property (nonatomic, retain) IBOutlet UIButton *btnAvlSlots;
@property (nonatomic, retain) IBOutlet UIButton *btnSubmit;
@property (nonatomic, retain) IBOutlet UIButton *btnCancel;
@property (nonatomic, retain) IBOutlet UITableView *tblAvlSlots;
@property (nonatomic, retain) NSMutableArray *avlSlotsArray;
@property (nonatomic, retain) ISActivityOverlayController *activityController;
@property (nonatomic, retain) NSNumber *selectedIndex;
@property (nonatomic, assign) NSInteger selectedScheduleIndex;

-(IBAction) closePopup:(id)sender;
-(IBAction) clickAvlSlots:(id)sender;
-(IBAction) clickCancel:(id)sender;
-(IBAction) clickSubmit:(id)sender;

@end
