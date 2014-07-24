//
//  OtherDrugTableController.h
//  mCura
//
//  Created by Aakash Chaudhary on 18/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OtherDrugTableController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    IBOutlet UITableView* mainTbl;
    IBOutlet UILabel* lbl1;
    IBOutlet UILabel* lbl2;
    IBOutlet UIView* divider;
    IBOutlet UINavigationBar* navBar;
}

@property (nonatomic, retain) NSMutableArray* arrSafetyNames;
@property (nonatomic, retain) NSMutableArray* arrSafetyStatus;
@property (nonatomic, retain) NSMutableArray* arrSideEffects;
@property (nonatomic, assign) NSInteger type;

-(IBAction)closeView;

@end
