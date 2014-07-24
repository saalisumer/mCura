//
//  ChangePasswordController.h
//  mCura
//
//  Created by Aakash Chaudhary on 02/06/12.
//  Copyright (c) 2012 aakash272@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ISActivityOverlayController.h"

@class ChangePasswordController;
@protocol ChangePasswordDelegate <NSObject>

- (void) closePopUpPassword;

@end

@interface ChangePasswordController : UIViewController<UITextFieldDelegate,NSURLConnectionDelegate>{
    IBOutlet UITextField* oldPswdTxtField;
    IBOutlet UITextField* newPswdTxtField;
    IBOutlet UITextField* newConfirmPswdTxtField;
    IBOutlet UILabel* lblOld;
    IBOutlet UILabel* lblNew;
    IBOutlet UILabel* lblConfirm;
    IBOutlet UINavigationBar* navBar;
    id <ChangePasswordDelegate> delegate;
}

@property (nonatomic, assign) BOOL isChangePswd;
@property (nonatomic, retain) UIButton* btnToBeUsed;
@property (nonatomic, retain) ISActivityOverlayController *activityController;
@property (assign) id<ChangePasswordDelegate> delegate;

-(IBAction)clickBtnDone:(id)sender;
-(IBAction)clickBtnCancel:(id)sender;

@end
