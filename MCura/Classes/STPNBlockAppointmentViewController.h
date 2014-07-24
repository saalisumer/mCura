//
//  STPNBlockAppointmentViewController.h
//  3GMDoc

#import <UIKit/UIKit.h>
#import "ISActivityOverlayController.h"

@protocol STPNBlockAppointmentDelegate <NSObject>

- (void) closePopup:(BOOL)reloadData;

@end

@class _GMDocService;
@class Appointment;
@interface STPNBlockAppointmentViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>{
    
    id <STPNBlockAppointmentDelegate> delegate;
    _GMDocService *_service;
}

@property (nonatomic, retain)  Appointment *appoint;
@property (nonatomic, retain) _GMDocService *service;
@property (assign) id<STPNBlockAppointmentDelegate> delegate;
@property (nonatomic, retain) IBOutlet UITableView *tblNature;
@property (nonatomic, retain) IBOutlet UIButton *btnNature;
@property (nonatomic, retain) IBOutlet UILabel *lblSecName;
@property (nonatomic, retain) IBOutlet UILabel *lblSecTime;
@property (nonatomic, retain) IBOutlet UITextField *txtOthDtl;
@property (nonatomic, retain) IBOutlet UIButton *btnSubmit;
@property (nonatomic, retain) IBOutlet UIButton *btnCancel;
@property (nonatomic, retain) NSArray *natures;
@property (nonatomic, retain) NSArray *status;
@property (nonatomic, retain) ISActivityOverlayController *activityController;
@property (nonatomic, retain) NSNumber *selectedIndex;
@property (nonatomic, retain) NSString *hospitalName;
@property (nonatomic, assign) NSInteger selectedScheduleIndex;

-(IBAction) closePopup:(id)sender;
-(IBAction) clickNaturePatient:(id)sender;
-(IBAction) clickCancel:(id)sender;
-(IBAction) clickSubmit:(id)sender;

@end
