//
//  STPNFixAppointmentViewController.h
//  3GMDoc

#import <UIKit/UIKit.h>
#import "ISActivityOverlayController.h"

@protocol STPNFixAppointmentDelegate <NSObject>

- (void) closePopup:(BOOL)reloadData;
- (void) closePopupFromAddBtn;

@end

@class _GMDocService;
@interface STPNFixAppointmentViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>{
    
    id <STPNFixAppointmentDelegate> delegate;
    _GMDocService *_service;
}

@property (nonatomic, retain) _GMDocService *service;
@property (assign) id<STPNFixAppointmentDelegate> delegate;
@property (nonatomic, retain) IBOutlet UITableView *tblNature;
@property (nonatomic, retain) IBOutlet UIButton *btnNature;
@property (nonatomic, retain) IBOutlet UITextField *txtPatient;
@property (nonatomic, retain) IBOutlet UIButton *btnPatSearch;
@property (nonatomic, retain) IBOutlet UIButton *btnPatAdd;
@property (nonatomic, retain) IBOutlet UILabel *lblSecName;
@property (nonatomic, retain) IBOutlet UILabel *lblSecTime;
@property (nonatomic, retain) IBOutlet UIButton *btnSubmit;
@property (nonatomic, retain) IBOutlet UIButton *btnCancel;
@property (nonatomic, retain) IBOutlet UITableView *tblPatients;
@property (nonatomic, retain) NSArray *patients;
@property (nonatomic, retain) NSArray *natures;
@property (nonatomic, retain) ISActivityOverlayController *activityController;
@property (nonatomic, assign) int selectedPatIndex;
@property (nonatomic, retain) NSNumber *selectedIndex;
@property (nonatomic, assign) NSInteger selectedScheduleIndex;

-(IBAction) closePopup:(id)sender;
-(IBAction) clickSearchPatient:(id)sender;
-(IBAction) clickNaturePatient:(id)sender;
-(IBAction) clickCancel:(id)sender;
-(IBAction) clickAdd:(id)sender;
-(IBAction) clickSubmit:(id)sender;
-(void) setSelectedCell:(NSInteger)index;
@end
