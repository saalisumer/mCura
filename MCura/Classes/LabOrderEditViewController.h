//
//  LabOrderEditViewController.h
//  mCura
//
//  Created by Aakash Chaudhary on 15/06/12.
//  Copyright (c) 2012 aakash272@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "proAlertView.h"
#import "ISActivityOverlayController.h"
#import "CurrentVisitDetailViewController.h"

@interface LabOrderEditViewController : UIViewController<UIAlertViewDelegate,NSURLConnectionDelegate>{
    IBOutlet UIView* bgView;
    IBOutlet UIImageView *handwritingView;
    IBOutlet UIView* hideControlsView;
    CGPoint lastPoint;
    CGPoint secondLastPoint;
    UIImageView* drawImage;
    UIImage* finalImageToBeSaved;
    CGSize originalSize;
    //first image view
    CGFloat currentZoom1;
    CGFloat initialDist1;
    CGRect initialFrame1;
    NSInteger currentColor;
    proAlertView* saveLabReportChangesAlert;
    proAlertView* closeChangesAlert;
    proAlertView* cancelChangesAlert;
    IBOutlet UIButton* btnX;
    IBOutlet UIButton* btnY;
    IBOutlet UIButton* btnErase;
    IBOutlet UISegmentedControl* topTabBar;
    NSInteger swipeWidth;
    BOOL isWriteMode;
}

@property (nonatomic, retain) ISActivityOverlayController *activityController;
@property (nonatomic, retain) CurrentVisitDetailViewController* mParent;
@property (nonatomic, retain) UIImage* firstImage;
@property (nonatomic, retain) UIImage* finalImageToBeSaved;
@property (nonatomic, retain) NSString * userRoleId;
@property (nonatomic, retain) NSString * mrno;

-(IBAction) selectColor1;
-(IBAction) selectColor2;
-(IBAction) selectColor3;
-(IBAction) selectColor4;
-(IBAction) selectErase;
-(IBAction) toggleWrite;
-(IBAction) closePopup;
-(IBAction) saveChanges;
-(IBAction) cancelChanges;
-(IBAction) btnXWasDragged:(UIButton *)button withEvent:(UIEvent *)event;
-(IBAction) btnYWasDragged:(UIButton *)button withEvent:(UIEvent *)event;
-(CGFloat) distanceBetweenTwoPoints:(CGPoint)fromPoint toPoint:(CGPoint)toPoint;
-(bool) arePoints:(CGPoint)pointA And:(CGPoint)pointB InsideViewFrame:(CGRect)frame;
-(UIImage *)imageWithColor:(UIColor *)color;
-(void) SuccessToLoadTable:(NSString*)response;
-(void) PostUploadImage:(NSData*)_imgData;

@end
