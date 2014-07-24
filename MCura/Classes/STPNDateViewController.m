//
//  STPNDateViewController.m
//  3GMDoc

#import "STPNDateViewController.h"
#import "DataExchange.h"
#import "Schedule.h"

@implementation STPNDateViewController

@synthesize lblTime, sliderHr, sliderMin, btnDone, btnNow, delegate, flag, lblMinute, lblPtime, schMinHrs, schMaxHrs,setExternalValue;
@synthesize maxValue,minVal;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    Schedule *sec = [[DataExchange getSchedulerReponse] objectAtIndex:0];
    
    NSArray *mintime = [sec.from_time componentsSeparatedByString:@":"];
    NSArray *maxtime = [sec.to_time componentsSeparatedByString:@":"];
    
    self.lblTime.text = [[mintime objectAtIndex:0] stringByAppendingString:@":"];
    self.lblMinute.text = [mintime objectAtIndex:1];
    
    if(self.lblTime.text.length==0)
        self.lblTime.text = @"6";
    if(self.lblMinute.text.length==0)
        self.lblMinute.text = @"00";
    
    self.schMinHrs = [mintime objectAtIndex:0];
    
    self.schMaxHrs  = [maxtime objectAtIndex:0];
    if(setExternalValue){
        [self.sliderHr setValue:minVal+1];
        [self.sliderHr setMinimumValue:minVal];
        [self.sliderHr setMaximumValue:maxValue];
        if(minVal>=12){
            [lblPtime setText:@"pm"];
        }
    }
}

-(IBAction)clickBtnDone:(id)sender{

    NSString *time = [lblTime.text stringByReplacingOccurrencesOfString:@":" withString:@""];
    time = [time stringByAppendingString:@":"];
    time = [time stringByAppendingString:lblMinute.text];
    time = [time stringByAppendingString:@" "];
    time = [time stringByAppendingString:self.lblPtime.text];
    if(self.delegate != nil){
        if(flag)
            [self.delegate closeFromTime:time];
        else
            [self.delegate closeToTime:time];
    }
}


-(IBAction)clickBtnNow:(id)sender{
    if(self.delegate != nil){
        if(flag)
            [self.delegate closeFromTime:@""];
        else
            [self.delegate closeToTime:@""];
    }
}

-(IBAction)changeMinuteSlider:(id)sender{
    self.lblMinute.text = [NSString stringWithFormat:@"%.0f",self.sliderMin.value];
}

-(IBAction)changeHoursSlider:(id)sender{
    NSInteger sliderVal = self.sliderHr.value;
    if(sliderVal < 12){
        self.lblTime.text = [NSString stringWithFormat:@"%d:",sliderVal];
        self.lblPtime.text = @"am";
    }
    else if(sliderVal<13){
        self.lblTime.text = [NSString stringWithFormat:@"%d:",sliderVal];
        self.lblPtime.text = @"pm";
    }
    else{
        self.lblTime.text = [NSString stringWithFormat:@"%d:",sliderVal-12];
        self.lblPtime.text = @"pm";
    }
}

- (void)viewDidUnload{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    // return UIInterfaceOrientationIsLandscape(interfaceOrientation);
    return UIInterfaceOrientationLandscapeRight;
}

@end
