@interface CustomStatusBar : UIWindow
{
@private
	/// Text information
	UILabel* _statusLabel;
	/// Activity indicator
	UIActivityIndicatorView* _indicator;
    UILabel *_percentLabel;
    UIInterfaceOrientation lastOrientation;
}
-(void)showWithStatusMessage:(NSString*)msg;
-(void)showWithPercentageStatus:(NSMutableString*)per;
-(void)hide;

@end