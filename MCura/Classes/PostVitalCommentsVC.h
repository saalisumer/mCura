//
//  PostVitalCommentsVC.h
//  mCura
//
//  Created by Aakash Chaudhary on 30/10/12.
//  Copyright (c) 2012 aakash272@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PostVitalCommentsVC;
@protocol PostVitalCommentsVCDelegate <NSObject>

-(void)closePostVitalsPopup;

@end

@interface PostVitalCommentsVC : UIViewController<NSURLConnectionDelegate>{
    IBOutlet UITextView* commentsTxtView;
}

@property (nonatomic,retain) id<PostVitalCommentsVCDelegate> delegate;
@property (nonatomic,assign) NSInteger vitalsId;

-(IBAction)submitBtnPressed;
-(IBAction)cancelBtnPressed;

@end
