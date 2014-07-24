//
//  CompareImagePopupVC.h
//  mCura
//
//  Created by Aakash Chaudhary on 28/06/12.
//  Copyright (c) 2012 aakash272@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PatMedRecords.h"

@protocol CompareImgPopoverDelegate <NSObject>

@optional
-(void) optionSelected:(NSString*)cellValue;
@end

@interface CompareImagePopupVC : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    IBOutlet UITableView* mTableView;
    id<CompareImgPopoverDelegate>delegate;
}

@property (nonatomic,retain) id <CompareImgPopoverDelegate> delegate;
@property (nonatomic,retain) NSMutableArray* listOfOptions;
@property (nonatomic, retain) NSMutableArray *dateDtls;
@property (nonatomic, retain) NSMutableArray *doctorNamesArray;
@property (nonatomic, retain) NSMutableArray *imageDtls;

@end
