//
//  STPNHomeScreen.h
//  3GMDoc

#import <UIKit/UIKit.h>

@class _GMDocService;

@interface STPNHomeScreen : UIViewController{
    _GMDocService *_service;
}

@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activity;
@property (nonatomic, retain) _GMDocService *service;

-(void)getScheduleURL;
-(void)fetchImageNameURL;
-(void) fillGenericsTable:(NSMutableArray*)response;
-(void) fillBrandsTable:(NSMutableArray*)response;

@end