#import "CustomStatusBar.h"
#define kStatusBarHeight 20
// width of the screen in portrait-orientation
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
// height of the screen in portrait-orientation
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
@implementation CustomStatusBar

-(id)initWithFrame:(CGRect)frame
{
	if ((self = [super initWithFrame:frame]))
	{
		// Place the window on the correct level & position
		self.windowLevel = UIWindowLevelStatusBar + 1.0f;
		//self.frame = [UIApplication sharedApplication].statusBarFrame;
        self.frame = CGRectMake(0, 0, 1024, 20);
		// Create an image view with an image to make it look like the standard grey status bar
		UIImageView* backgroundImageView = [[UIImageView alloc] initWithFrame:self.frame];
		backgroundImageView.image = [[UIImage imageNamed:@"statusbar_background.png"] stretchableImageWithLeftCapWidth:2 topCapHeight:0];
		[self addSubview:backgroundImageView];
		[backgroundImageView release];
		
		_indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		_indicator.frame = (CGRect){.origin.x = 2.0f, .origin.y = 3.0f, .size.width = self.frame.size.height - 6, .size.height = self.frame.size.height - 6};
		_indicator.hidesWhenStopped = YES;
		[self addSubview:_indicator];
		
		_statusLabel = [[UILabel alloc] initWithFrame:(CGRect){.origin.x = 0.0f, .origin.y = 0.0f, .size.width = self.frame.size.width, .size.height = self.frame.size.height}];
		_statusLabel.backgroundColor = [UIColor clearColor];
        _statusLabel.textAlignment = UITextAlignmentCenter;
		_statusLabel.textColor = [UIColor blackColor];
		_statusLabel.font = [UIFont boldSystemFontOfSize:12.0f];
		[self addSubview:_statusLabel];
        
        _percentLabel = [[UILabel alloc] initWithFrame:(CGRect){.origin.x = 0.0f, .origin.y = 0.0f, .size.width = self.frame.size.width-20, .size.height = self.frame.size.height}];
		_percentLabel.backgroundColor = [UIColor clearColor];
        _percentLabel.textAlignment = UITextAlignmentRight;
		_percentLabel.textColor = [UIColor blackColor];
		_percentLabel.font = [UIFont boldSystemFontOfSize:12.0f];
		[self addSubview:_percentLabel];
        lastOrientation = [UIApplication sharedApplication].statusBarOrientation;

        if (lastOrientation == UIInterfaceOrientationLandscapeRight) {
            self.transform = CGAffineTransformMakeRotation(M_PI * (90) / 180.0);
            self.frame = CGRectMake(kScreenWidth - kStatusBarHeight,0, kStatusBarHeight, kScreenHeight);
        }else if (lastOrientation == UIInterfaceOrientationLandscapeLeft) {
            self.transform = CGAffineTransformMakeRotation(M_PI * (-90) / 180.0);
            self.frame = CGRectMake(0,0, kStatusBarHeight, kScreenHeight);
        }
	}
	return self;
}

-(void)showWithPercentageStatus:(NSMutableString*)per{
    
    if (!per)
        return;
    _percentLabel.text=per;
    self.hidden=NO;
}


-(void)dealloc
{
	[_statusLabel release];
	[_indicator release];
	[super dealloc];
}

-(void)showWithStatusMessage:(NSString*)msg
{
	if (!msg)
		return;
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (orientation != lastOrientation) {
        self.transform = CGAffineTransformMakeRotation(M_PI);
        lastOrientation = orientation;
    }
    
	_statusLabel.text = msg;
	[_indicator startAnimating];
	self.hidden = NO;
}

-(void)hide
{
	[_indicator stopAnimating];
	self.hidden = YES;
}

@end