//
//  CustomPopoverViewController.h
//  mCura
//
//  Created by Aakash Chaudhary on 02/04/12.
//  Copyright (c) 2012 aakash272@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol PopoverResponseClassDelegate <NSObject>

@optional
-(void) optionSelected:(NSString*)cellValue;
-(void) optionSelected:(NSString*)cellValue ForButton:(UIButton*)btn AndIndex:(NSInteger)index;
@end


@interface CustomPopoverViewController : UITableViewController {
	NSMutableArray* listOfOptions;
	id<PopoverResponseClassDelegate>delegate;
	NSInteger type;
}
@property (nonatomic,retain) NSMutableArray* listOfOptions;
@property (nonatomic,retain) NSMutableArray* listOfDetailOptions;
@property (nonatomic,retain) id <PopoverResponseClassDelegate> delegate;
@property (nonatomic,retain) UIButton* btn;
@property (nonatomic,assign) NSInteger type;

@end
