//
//  ISActivityOverlayController.h
//  IdeaScale
//
//  Created by Jeremy Przasnyski on 12/4/09.
//  Copyright 2009 Cavoort, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ISActivityOverlayController : NSObject {
	UIViewController* _container;
	UIView* _view;
	UILabel* _label;
	UIActivityIndicatorView* _activity;
	UIImageView* _resultIcon;
	
	id _target;
	SEL _selector;
    UIImageView *_imgContainer;
    UIProgressView *_progressView;
}
@property (nonatomic,retain) IBOutlet UIProgressView *progressView;

@property (nonatomic,retain) IBOutlet UIViewController* container;
@property (nonatomic,retain) IBOutlet UIView* view;
@property (nonatomic,assign) IBOutlet UILabel* label;
@property (nonatomic,retain) IBOutlet UIActivityIndicatorView* activity;
@property (nonatomic,retain) IBOutlet UIImageView* resultIcon;
@property(nonatomic,retain) IBOutlet UIImageView *imgContainer;

+(ISActivityOverlayController*)presentActivityOverViewController:(UIViewController*)viewController withLabel:(NSString*)label;
-(void)presentActivityWithLabel:(NSString*)label;
-(void)dismissActivityWithTarget:(id <NSObject>)target usingSelector:(SEL)selector withLabel:(NSString*)label completedOK:(BOOL)ok;
-(void)dismissActivity; // dismisses the activity view without animation, without results shown
-(void)updateLabel:(NSString*)label;
@end
