//
//  STPNLoggedIn.h
//  3GMDoc
//

#import <UIKit/UIKit.h>
#import "ISActivityOverlayController.h"
@class DeviceDeatils;
@class _GMDocService;
@interface STPNLoggedIn : UIViewController <UITextFieldDelegate>{

    NSArray *deviceDtls;
    CGFloat animatedDistance;
    DeviceDeatils *device;
    _GMDocService *_service;
    UIPopoverController* popover;
}

@property (nonatomic, retain) NSMutableArray* subTenIdArray;
@property (nonatomic, retain) DeviceDeatils *device;
@property (nonatomic, retain) NSArray *deviceDtls;
@property (nonatomic, retain) IBOutlet UILabel *lblUsername;
@property (nonatomic, retain) IBOutlet UILabel *lblPassword;
@property (nonatomic, retain) IBOutlet UITextField *txtUsername;
@property (nonatomic, retain) IBOutlet UITextField *txtPassword;
@property (nonatomic, retain) IBOutlet UIButton *btnLogin;
@property (nonatomic, retain) ISActivityOverlayController *activityController;
@property (nonatomic, retain) _GMDocService *service;

-(void)getLoginURL;
-(void)getRoleID_URL;

@end
