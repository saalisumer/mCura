//
//  _GMDocAppDelegate.h
//  3GMDoc

#import <UIKit/UIKit.h>
#import "CustomStatusBar.h"

@interface _GMDocAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    UINavigationController *navigationController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
@property (nonatomic, retain) CustomStatusBar* csb;
@property (nonatomic, assign) int profileimagevalue;

- (void)initializeCustomStatusBar;
- (void)showCSMMsg;
- (void)showCSMPercentage:(NSInteger)percentage;

@end

