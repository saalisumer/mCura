//
//  STPNDisclaimer.h
//  3GMDoc

#import <UIKit/UIKit.h>

@interface STPNDisclaimer : UIViewController{

}

@property (nonatomic, retain) IBOutlet UIButton *disclaimerAgree;
@property (nonatomic, retain) IBOutlet UIButton *diclaimerDisagree;
@property (nonatomic, retain) NSString *disclaimerStr; 

-(IBAction)discalaimer:(id)sender;

@end
