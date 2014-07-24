//
//  STPNDateViewController.h
//  3GMDoc

#import <UIKit/UIKit.h>

@protocol STPNTimeDelegate <NSObject>

- (void) closeFromTime:(NSString*)time;
- (void) closeToTime:(NSString*)time;

@end

@interface STPNDateViewController : UIViewController{
    id <STPNTimeDelegate> delegate;
}

@property (assign) id<STPNTimeDelegate> delegate;
@property (nonatomic, retain)IBOutlet UILabel *lblTime;
@property (nonatomic, retain)IBOutlet UILabel *lblMinute;
@property (nonatomic, retain)IBOutlet UILabel *lblPtime;
@property (nonatomic, retain)IBOutlet UISlider *sliderHr;
@property (nonatomic, retain)IBOutlet UISlider *sliderMin;
@property (nonatomic, retain)IBOutlet UIButton *btnDone;
@property (nonatomic, retain)IBOutlet UIButton *btnNow;
@property (nonatomic, assign)BOOL flag;
@property (nonatomic, assign)BOOL setExternalValue;
@property (nonatomic, assign)CGFloat minVal ;
@property (nonatomic, assign)CGFloat maxValue;
@property (nonatomic, retain)NSString *schMinHrs;
@property (nonatomic, retain)NSString *schMaxHrs;

-(IBAction)clickBtnDone:(id)sender;
-(IBAction)clickBtnNow:(id)sender;
-(IBAction)changeMinuteSlider:(id)sender;
-(IBAction)changeHoursSlider:(id)sender;


@end
