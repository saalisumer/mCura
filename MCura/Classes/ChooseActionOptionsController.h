//
//  ChooseActionOptionsController.h
//  mCura
//
//  Created by Aakash Chaudhary on 14/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STPNDateViewController.h"

@class ChooseActionOptionsController;
@protocol choiceDelegate <NSObject>

-(void)choicesMade:(bool[])choices;
-(void)closePopup;

@end

@interface ChooseActionOptionsController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIPopoverControllerDelegate,UINavigationControllerDelegate,STPNTimeDelegate>{
    UIPopoverController* popover;
    bool choices[3];
    NSMutableArray* listOfOptions;
    IBOutlet UIView* hideBtnsView;
}

@property (nonatomic,retain) IBOutlet UITableView* tblChoices;
@property (assign) NSInteger type;
@property (nonatomic,retain) id<choiceDelegate> delegate;

-(IBAction)selectAll;
-(IBAction)selectNone;
-(IBAction)doneBtnPressed;
-(IBAction)cancelBtnPressed;
-(IBAction)chooseTime:(id)sender;

@end
