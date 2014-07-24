//
//  UserAccountViewController.h
//  mCura
//
//  Created by Aakash Chaudhary on 02/04/12.
//  Copyright (c) 2012 aakash272@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScheduleView.h"

@class ReportsView;
@class ScheduleView;
@class Patdemographics;
@class _GMDocService;
@class ISActivityOverlayController;
@class ProfileSetingsView;
@class TemplatesView;
@interface UserAccountViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>{
    _GMDocService *_service;
    Patdemographics *pat;
    IBOutlet UIView* currentSettingsView;
    NSMutableArray* arrayOfSubTenants;
    IBOutlet UINavigationBar* masterNavBar;
    NSMutableArray* arrSubtenIds;
}

@property (nonatomic, retain) ScheduleView* sch;
@property (nonatomic, retain) ReportsView* repView;
@property (nonatomic, retain) ProfileSetingsView* profSetView;
@property (nonatomic, retain) TemplatesView* templatesView;
@property (nonatomic, retain) ISActivityOverlayController *activityController;
@property (nonatomic, retain) _GMDocService *service;
@property (nonatomic, retain) Patdemographics *pat;
@property (nonatomic, retain) IBOutlet UITableView *tblView;
@property (nonatomic, retain) NSMutableArray* arrPharmaPlusLab;

-(void)selectLogout:(id)sender;
-(void)back:(id)sender;

@end
