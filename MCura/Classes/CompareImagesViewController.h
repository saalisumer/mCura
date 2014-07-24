//
//  CompareImagesViewController.h
//  mCura
//
//  Created by Aakash Chaudhary on 30/03/12.
//  Copyright (c) 2012 aakash272@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "proAlertView.h"

@interface CompareImagesViewController : UIViewController<UIScrollViewDelegate,UIAlertViewDelegate>{
    IBOutlet UIImageView* firstImageView;
    IBOutlet UIImageView* secondImageView;
    IBOutlet UIScrollView* firstScrollView;
    IBOutlet UIScrollView* secondScrollView;
    IBOutlet UIButton* lockBtn;
    bool zoomTogether;
    //first image view
    CGFloat currentZoom1;
    CGFloat initialDist1;
    CGRect initialFrame1;
    // second image view
    CGFloat currentZoom2;
    CGFloat initialDist2;
    CGRect initialFrame2;
    
    proAlertView* closeAlertView;
}

@property (nonatomic, retain) UIImage* firstImage;
@property (nonatomic, retain) UIImage* secondImage;

-(IBAction)closePopup;
-(IBAction) toggleZoomTogether:(id)sender;
-(CGFloat)distanceBetweenTwoPoints:(CGPoint)fromPoint toPoint:(CGPoint)toPoint;
-(bool)arePoints:(CGPoint)pointA And:(CGPoint)pointB InsideViewFrame:(CGRect)frame;

@end
