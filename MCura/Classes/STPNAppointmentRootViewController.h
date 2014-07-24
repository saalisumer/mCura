//
//  STPNAppointmentRootViewController.h
//  3GMDoc

#import <UIKit/UIKit.h>
#import "ScheduleTableCell.h"
#import "AppointmentViewController.h"
#import "ISActivityOverlayController.h"
#import "SubTenantsViewcontroller.h"
#import "Constants.h"

@class _GMDocService;
@class ImageCache;
@interface STPNAppointmentRootViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, ScheduleTableCellDelegate,UITabBarControllerDelegate,SubTenantsChoiceDelegate>{
    
    NSMutableArray *phone;
    Response *res;
    NSIndexPath *_indexPath;
    NSMutableString *currDate;
    _GMDocService *_service;
    ScheduleTableCell *cell;
    ImageCache* _iconDownloader;
    NSMutableString *imgUrl;
    UIPopoverController * _popover;
    AppointmentViewController *appointmentController;
    NSInteger currentDayIndex;
    NSString* currentDayString;
    Boolean showAll;
    NSIndexPath *currIndexPath;
    bool isSectionCompressed[100];
    IBOutlet UIButton* hospitalBtn;
    UIPopoverController* popover;
    NSInteger weekday;
    NSInteger addPatSelectedIndex;
    NSInteger addPatSelectedScheduleIndex;
}

@property (nonatomic, retain) NSIndexPath *currIndexPath;
@property (nonatomic, retain) UIBarButtonItem* previousButton;
@property (nonatomic, retain) UIBarButtonItem* nextButton;
@property (nonatomic, retain) UIBarButtonItem* doctorNameButton;
@property (nonatomic, retain) NSDate* previousDate;
@property (nonatomic, retain) NSDate* nextDate;
@property (nonatomic, retain) UIPopoverController * popover;
@property (nonatomic, retain) NSMutableString *imgUrl;
@property (nonatomic, retain) _GMDocService *service;
@property (nonatomic, retain) NSIndexPath *_indexPath;
@property (nonatomic, retain) NSMutableString *currDate;
@property (nonatomic, retain) NSMutableArray *phone;
@property (nonatomic, retain) IBOutlet UIButton *btnShowAll;
@property (nonatomic, retain) IBOutlet UITableView *schedulerTable;
@property (nonatomic, retain) IBOutlet UIImageView *imgView;
@property (nonatomic, retain) ISActivityOverlayController *activityController;
@property (nonatomic, retain) NSString *selectedDate;
@property (nonatomic, retain) NSNumber *selectedIndex;

-(UIImage*)resizedImage:(UIImage *)inImage andRect:(CGRect)thumbRect;
-(NSString*)processString:(NSString *)_string;
-(void)stopImageCache;
-(void)loadImage:(NSString *)imgUrl;
-(void)previous:(id)sender;
-(void)next:(id)sender;
-(void)loadDataView;
-(void)selectLogout:(id)sender;
-(void)toggleSection:(id)sender;
-(void)refreshView;
-(IBAction)showMondaySchedules;
-(IBAction)showTuesdaySchedules;
-(IBAction)showWednesdaySchedules;
-(IBAction)showThursdaySchedules;
-(IBAction)showFridaySchedules;
-(IBAction)showSaturdaySchedules;
-(IBAction)showSundaySchedules;
-(IBAction)showAllSchedules;
-(IBAction)hospitalBtnPressed;
+(NSDate *)mfDateFromDotNetJSONString:(NSString *)string;

@end
