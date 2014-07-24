//
//  STPNAddPatientViewController.h
//  3GMDoc

#import <UIKit/UIKit.h>

@protocol STPNAddPatientDelegate <NSObject>

- (void) closeAddPatientPopup;

@end

@class _GMDocService;
@class ISActivityOverlayController;

@interface STPNAddPatientViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate,UIAlertViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,NSURLConnectionDelegate,UIPopoverControllerDelegate>{
    _GMDocService *_service;
    BOOL keyboardVisible;
    CGPoint offset;
    UITextField *activeField;
    CGFloat animatedDistance;
    UIPopoverController * _popover;
    IBOutlet UIButton* profilePicView;
    IBOutlet UIScrollView* mainScrollView;
    UIPopoverController* popover;
    NSInteger pendingConnections;
    UIImage* profileImg;
    NSInteger patDemoId;
    NSURLConnection* patImgPostConnection;
    NSMutableString *Dobstr;
}

@property(nonatomic, retain)id<STPNAddPatientDelegate>delegate;
@property(nonatomic, retain)UIPopoverController * popover;
@property(nonatomic, retain)_GMDocService *service;
@property(nonatomic, retain)IBOutlet UITextField *txtName;
@property(nonatomic, retain)IBOutlet UITextField *txtDob;
@property(nonatomic, retain)IBOutlet UITextField *txtMobile1;
@property(nonatomic, retain)IBOutlet UITextField *txtEmail;
@property(nonatomic, retain)IBOutlet UITextField *txtAddress1;
@property(nonatomic, retain)IBOutlet UITextField *txtAddress2;
@property(nonatomic, retain)IBOutlet UITextField *txtZipcode;
@property(nonatomic, retain)IBOutlet UIButton *btnArea;
@property(nonatomic, retain)IBOutlet UIButton *btnGender;
@property(nonatomic, retain)IBOutlet UIButton *btnCity;
@property(nonatomic, retain)IBOutlet UIButton *btnState;
@property(nonatomic, retain)IBOutlet UIButton *btnCountry;
@property(nonatomic, retain)UIImagePickerController *imagePicker;
@property(nonatomic, retain)IBOutlet UIButton *btnSubmit;
@property(nonatomic, retain)IBOutlet UIButton *btnCancel;
@property(nonatomic, retain)NSMutableArray *arrayages;
@property(nonatomic, retain)NSMutableArray *genders;
@property(nonatomic, retain)NSMutableArray *areas;
@property(nonatomic, retain)NSMutableArray *arrayCities;
@property(nonatomic, retain)NSMutableArray *areaIds;
@property(nonatomic, retain)NSMutableArray *arrayCityIds;
@property(nonatomic, retain)NSMutableArray *arrayCountries;
@property(nonatomic, retain)NSMutableArray *arrayState;
@property(nonatomic, retain)NSMutableArray *arrayStateIds;
@property(nonatomic, retain)IBOutlet UITableView *tblages;
@property(nonatomic, retain)IBOutlet UITableView *tblGenders;
@property(nonatomic, retain)IBOutlet UITableView *tblAreas;
@property(nonatomic, retain)IBOutlet UITableView *tblCity;
@property(nonatomic, retain)IBOutlet UITableView *tblCountry;
@property(nonatomic, retain)IBOutlet UITableView *tblStates;
@property(nonatomic, retain)ISActivityOverlayController *activityController;
@property(nonatomic, retain)NSString *areaId;
@property(nonatomic, assign)NSInteger docCityId;
@property(nonatomic, assign)NSInteger docStateId;

-(IBAction) clickCancel:(id)sender;
-(IBAction) clickAreaBtn:(id)sender;
-(IBAction) clickCityBtn:(id)sender;
-(IBAction) clickStateBtn:(id)sender;
-(IBAction) clickCountryBtn:(id)sender;
-(IBAction) clickAreaBtn:(id)sender;
-(IBAction) clickSubmit:(id)sender;
-(IBAction) clickFromDOB:(id)sender;
-(IBAction) clickProfileImageBtn;
-(NSInteger) daysBetweenDate:(NSDate *)firstDate andDate:(NSDate *)secondDate;
-(void)didFinishWithCamera;
-(void)didTakePicture:(UIImage *)picture;
-(void)SuccessToPostImage:(NSString*)response;
-(void)postImage;

@end
