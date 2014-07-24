//
//  SplashViewController.h
//  3GMDoc

#import <UIKit/UIKit.h>
#import "STPNLoggedIn.h"

@class _GMDocService;
@interface SplashViewController : UIViewController {
    _GMDocService *_service;
    
    UIActivityIndicatorView *activity;
    UILabel *loadingLabel;
    STPNLoggedIn *viewController;
    
}

@property (nonatomic, retain) _GMDocService *service;
@property (nonatomic, retain) IBOutlet UIImageView *splashImageView;

- (void)fadeScreen;
- (void)stop;
@end

