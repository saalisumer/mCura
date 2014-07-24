//
//  ProfileSetingsView.h
//  mCura
//
//  Created by Aakash Chaudhary on 09/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "_GMDocService.h"
#import "ISActivityOverlayController.h"
#import "STPNDatePickerViewController.h"
#import "UserAccountViewController.h"
#import "ChangePasswordController.h"

@interface ProfileSetingsView : UIView<UIPopoverControllerDelegate,UINavigationControllerDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,STPNDatePickerDelegate,ChangePasswordDelegate,GetStringInvocationDelegate>{
    IBOutlet UINavigationBar* childNavBar;
    CGFloat animatedDistance;
    NSURLConnection* getUserConn;
    NSURLConnection* getAddressConn;
    NSURLConnection* getContactDetailsConn;
    NSURLConnection* getAreaConn;
    NSURLConnection* getCityFromAreaIdConn;
    NSURLConnection* getStateConn;
    NSURLConnection* getCountryConn;
    NSURLConnection* postAddrConn;
    NSURLConnection* postContactConn;
    NSURLConnection* finalPostConn;
    NSInteger postStatus;
    NSInteger addressId;
    NSInteger contactId;
    NSInteger statusStr;
    NSInteger areaId;
    NSInteger printSettingsId;
    NSInteger displaySettingsId;
    NSInteger pendingConnections;
}

@property(nonatomic, retain)NSString* zipcodeStr;
@property(nonatomic, retain)UserAccountViewController* mParentController;
@property(nonatomic, retain)UIPopoverController * popover;
@property(nonatomic, retain)_GMDocService *service;
@property(nonatomic, retain)IBOutlet UITextField *txtName;
@property(nonatomic, retain)IBOutlet UITextField *txtDob;
@property(nonatomic, retain)IBOutlet UITextField *txtMobile;
@property(nonatomic, retain)IBOutlet UITextField *txtEmail;
@property(nonatomic, retain)IBOutlet UITextField *txtAddress;
@property(nonatomic, retain)IBOutlet UITextField *txtAddress2;
@property(nonatomic, retain)IBOutlet UITextField *txtExtension;
@property(nonatomic, retain)IBOutlet UITextField *txtOptMobile;
@property(nonatomic, retain)IBOutlet UITextField *txtSkypeId;
@property(nonatomic, retain)IBOutlet UITextField *txtFixedLine;
@property(nonatomic, retain)IBOutlet UITextField *txtOptEmail;
@property(nonatomic, retain)IBOutlet UILabel *lblName;
@property(nonatomic, retain)IBOutlet UILabel *lblDob;
@property(nonatomic, retain)IBOutlet UILabel *lblMobile;
@property(nonatomic, retain)IBOutlet UILabel *lblEmail;
@property(nonatomic, retain)IBOutlet UILabel *lblAddress;
@property(nonatomic, retain)IBOutlet UILabel *lblAddress2;
@property(nonatomic, retain)IBOutlet UILabel *lblExtension;
@property(nonatomic, retain)IBOutlet UILabel *lblOptMobile;
@property(nonatomic, retain)IBOutlet UILabel *lblSkypeId;
@property(nonatomic, retain)IBOutlet UILabel *lblFixedLine;
@property(nonatomic, retain)IBOutlet UILabel *lblOptEmail;
@property(nonatomic, retain)IBOutlet UIButton *btnArea;
@property(nonatomic, retain)IBOutlet UIButton *btnGender;
@property(nonatomic, retain)IBOutlet UIButton *btnCity;
@property(nonatomic, retain)IBOutlet UIButton *btnState;
@property(nonatomic, retain)IBOutlet UIButton *btnCountry;
@property(nonatomic, retain)NSMutableArray *genders;
@property(nonatomic, retain)NSMutableArray *areas;
@property(nonatomic, retain)NSMutableArray *arrayCities;
@property(nonatomic, retain)NSMutableArray *areaIds;
@property(nonatomic, retain)NSMutableArray *arrayCityIds;
@property(nonatomic, retain)NSMutableArray *arrayCountries;
@property(nonatomic, retain)NSMutableArray *arrayState;
@property(nonatomic, retain)NSMutableArray *arrayStateIds;
@property(nonatomic, retain)NSMutableArray *arrayPrintSettings;
@property(nonatomic, retain)NSMutableArray *arrayDisplaySettings;
@property(nonatomic, retain)IBOutlet UITableView *tblGenders;
@property(nonatomic, retain)IBOutlet UITableView *tblAreas;
@property(nonatomic, retain)IBOutlet UITableView *tblCity;
@property(nonatomic, retain)IBOutlet UITableView *tblCountry;
@property(nonatomic, retain)IBOutlet UITableView *tblStates;
@property(nonatomic, retain)IBOutlet UITableView *tblDocCredo;
@property(nonatomic, retain)IBOutlet UITableView *tblPrintSettings;
@property(nonatomic, retain)IBOutlet UITableView *tblDisplaySettings;
@property(nonatomic, retain)IBOutlet UIView* staticOverlayView;
@property(nonatomic, retain)ISActivityOverlayController *activityController;
@property(nonatomic, assign)NSInteger docCityId;
@property(nonatomic, assign)NSInteger docStateId;

-(id)initWithParent:(UserAccountViewController*)parent;
-(void) clickChangePassword:(id)sender;
-(void) clickChangePin:(id)sender;
-(IBAction) clickAreaBtn:(id)sender;
-(IBAction) clickCityBtn:(id)sender;
-(IBAction) clickStateBtn:(id)sender;
-(IBAction) clickCountryBtn:(id)sender;
-(IBAction) clickAreaBtn:(id)sender;
-(IBAction) clickSubmit:(id)sender;
-(IBAction) clickFromDOB:(id)sender;
-(IBAction) clickEdit;
+(NSString *)mfDateFromDotNetJSONString:(NSString *)string;
-(NSInteger) daysBetweenDate:(NSDate *)firstDate andDate:(NSDate *)secondDate;

@end
