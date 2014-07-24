//
//  BusinessPairingView.h
//  mCura
//
//  Created by Aakash Chaudhary on 02/07/12.
//  Copyright (c) 2012 aakash272@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ISActivityOverlayController.h"
#import "UserAccountViewController.h"
#import "_GMDocService.h"
#import "GetScheduleInvocation.h"

@interface BusinessPairingView : UIView<UITableViewDataSource,UITableViewDelegate,GetScheduleInvocationDelegate>{
    IBOutlet UITableView* tblSchedules;
}

@property (nonatomic, retain) ISActivityOverlayController *activityController;
@property (nonatomic, retain) _GMDocService *service;
@property (nonatomic, retain) UserAccountViewController* mParentController;
@property (nonatomic, retain) NSMutableArray* arrSchedules;

-(id)initWithParent:(UserAccountViewController*)parent;

@end
