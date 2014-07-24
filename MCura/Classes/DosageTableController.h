//
//  DosageTableController.h
//  mCura
//
//  Created by Aakash Chaudhary on 18/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DosageTableController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    IBOutlet UITableView* mainTbl;
}

@property (nonatomic, retain) NSMutableArray* arrBrands;

-(IBAction)closeView;

@end
