//
//  ISActivityOverlayController.m
//  IdeaScale
//
//  Created by Jeremy Przasnyski on 12/4/09.
//  Copyright 2009 Cavoort, LLC. All rights reserved.
//
#import "ISActivityOverlayController.h"
#import "CAVNSArrayTypeCategory.h"

@interface ISActivityOverlayController (private)
-(void)showAnimationDidFinish;
-(void)hideAnimationDidFinish;
@end

@implementation ISActivityOverlayController
@synthesize container = _container;
@synthesize view = _view;
@synthesize label = _label;
@synthesize activity = _activity;
@synthesize resultIcon = _resultIcon;
@synthesize imgContainer = _imgContainer;
@synthesize progressView = _progressView;

+(ISActivityOverlayController*)presentActivityOverViewController:(UIViewController*)viewController 
													   withLabel:(NSString*)label {
	   
    
	NSArray* wired = [[NSBundle mainBundle] loadNibNamed:@"Activity" owner:viewController options:nil];
	ISActivityOverlayController* controller = [wired firstObjectWithClass:[ISActivityOverlayController class]];
	[controller presentActivityWithLabel:label];
	//[controller release]; // Not entirely sure why this line is needed. Am I missing a retain/release combo somewhere?
	return controller;
}

-(id)retain {

	return [super retain];
}

- (oneway void) release {
	
	[super release];
}

-(void)dealloc {
	
	[self setContainer:nil];
	[self setView:nil];
	[self setActivity:nil];
	[self setResultIcon:nil];
	[_target release]; _target = nil;
	_selector = nil;
	[super dealloc];
}

-(void)presentActivityWithLabel:(NSString*)label {

    
   /* if(isIphone())
    {
        
        UIImage *img = [UIImage imageNamed:@"activity-overlay_iPhoneNew.png"];
        
        if(img != nil)
        {
        _imgContainer.image = [UIImage imageNamed:@"activity-overlay_iPhoneNew.png"];
        
        } 
        */
       _label.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
     //   _label.frame = CGRectMake(_label.frame.origin.x, _label.frame.origin.y-30, _label.frame.size.width, _label.frame.size.height);
  //  }
   
    [_label setText:label];
	[_view setAlpha:0.0f];
	_view.center = _container.view.center;
	[_container.view addSubview:_view];
	[UIView beginAnimations:@"presenting" context:self];
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(showAnimationDidFinish)];
	[_view setAlpha:1.0f];
	[UIView commitAnimations];
}

-(void)showAnimationDidFinish {
	
}

-(void)dismissActivity {
	[_view removeFromSuperview];
	[_activity removeFromSuperview];
	if (_target) {
		[_target release];
		_target = Nil;
	}
}

-(void)dismissActivityWithTarget:(id <NSObject>)target usingSelector:(SEL)selector withLabel:(NSString*)label completedOK:(BOOL)ok {
	_target = [target retain];
	_selector = selector;
	[self setResultIcon:[[[UIImageView alloc] init] autorelease]];
	[_resultIcon setFrame:[_activity frame]];
	[_resultIcon setImage:[UIImage imageNamed:ok?@"activity-icons-result-ok.png":@"activity-icons-result-problem.png"]];
	[_label setText:label];
	[_activity removeFromSuperview];
	[_view addSubview:_resultIcon];
	[UIView beginAnimations:@"dismissing" context:self];
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(hideAnimationDidFinish)];
	[_view setAlpha:0.0f];
	[UIView commitAnimations];
}

-(void)hideAnimationDidFinish {
	
	[_view removeFromSuperview];
	if (_target) {
		if (_selector) {
			[_target performSelector:_selector];
		}
		[_target release];
		_target = nil;
	}
}

-(void)updateLabel:(NSString*)label {
	[_label setText:label];
}

@end
