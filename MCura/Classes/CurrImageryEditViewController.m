//
//  LabOrderEditViewController.m
//  mCura
//
//  Created by Aakash Chaudhary on 15/06/12.
//  Copyright (c) 2012 aakash272@gmail.com. All rights reserved.
//

#import "CurrImageryEditViewController.h"
#import "Base64.h"
#import "DataExchange.h"
#import <QuartzCore/QuartzCore.h>

@implementation CurrImageryEditViewController
@synthesize firstImage,activityController,finalImageToBeSaved,mrno,userRoleId,mParent;

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

-(IBAction)selectColor1{
    currentColor = 0;
}

-(IBAction)selectColor2{
    currentColor = 1;
}

-(IBAction)selectColor3{
    currentColor = 2;
}

-(IBAction)selectColor4{
    currentColor = 3;
}

-(IBAction)selectErase{
    currentColor = 4;
    swipeWidth=4;
    hideColorsView.hidden = FALSE;
    btnErase.layer.borderWidth = 2;
    btnErase.layer.cornerRadius = 5;
    btnErase.layer.borderColor = [UIColor blueColor].CGColor;
}

- (CGFloat)distanceBetweenTwoPoints:(CGPoint)fromPoint toPoint:(CGPoint)toPoint {
    float x = toPoint.x - fromPoint.x;
    float y = toPoint.y - fromPoint.y;
    return sqrt(x * x + y * y);
}

-(bool)arePoints:(CGPoint)pointA And:(CGPoint)pointB InsideViewFrame:(CGRect)frame{
    if(CGRectContainsPoint(frame, pointA))
        if (CGRectContainsPoint(frame, pointB))
            return YES;
    return NO;
}

- (IBAction)btnXWasDragged:(UIButton *)button withEvent:(UIEvent *)event{
	// get the touch
	UITouch *touch = [[event touchesForView:button] anyObject];
	// get delta
	CGPoint previousLocation = [touch previousLocationInView:button];
	CGPoint location = [touch locationInView:button];
	CGFloat delta_x = location.x - previousLocation.x;
	// move button
    if(button.center.x + delta_x >= 136+button.frame.size.width/2 && button.center.x + delta_x <= 836-button.frame.size.width/2){
        button.center = CGPointMake(button.center.x + delta_x, button.center.y);
        CGRect frame = handwritingView.frame;
        frame.origin.x = -((btnX.frame.origin.x - 136) * (handwritingView.frame.size.width-originalSize.width))/(btnX.frame.size.width*2);
        [handwritingView setFrame:frame];
    }
}

- (IBAction)btnYWasDragged:(UIButton *)button withEvent:(UIEvent *)event{
	// get the touch
	UITouch *touch = [[event touchesForView:button] anyObject];
	// get delta
	CGPoint previousLocation = [touch previousLocationInView:button];
	CGPoint location = [touch locationInView:button];
	CGFloat delta_y = location.y - previousLocation.y;
	// move button
    if(button.center.y + delta_y >= 73+button.frame.size.height/2 && button.center.y + delta_y <= 683-button.frame.size.height/2){
        button.center = CGPointMake(button.center.x, button.center.y + delta_y);
        CGRect frame = handwritingView.frame;
        frame.origin.y = -((btnY.frame.origin.y - 73) * (handwritingView.frame.size.height-originalSize.height))/(btnY.frame.size.height*2);
        [handwritingView setFrame:frame];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch1 = [[touches allObjects] objectAtIndex:0];
    UITouch *touch2;
    int count = [[touches allObjects] count];
    if(count==1 && isWriteMode){
        UITouch *touch = [touches anyObject];
        lastPoint = [touch locationInView:handwritingView];
        secondLastPoint = lastPoint;
    }
    else if(count==2 && !isWriteMode){
        handwritingView.center = CGPointMake(420, 334);
        touch2 = [[touches allObjects] objectAtIndex:1];
        if([self arePoints:[touch1 locationInView:handwritingView] And:[touch2 locationInView:handwritingView] InsideViewFrame:handwritingView.frame]){
            initialDist1 = [self distanceBetweenTwoPoints:[touch1 locationInView:handwritingView] toPoint:[touch2 locationInView:handwritingView]];
            initialFrame1 = handwritingView.frame;
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch1 = [[touches allObjects] objectAtIndex:0];
    UITouch *touch2;
    int count = [[touches allObjects] count];
    if(count==1 && isWriteMode){
        UITouch *touch = [touches anyObject];	
        CGPoint currentPoint = [touch locationInView:handwritingView];
        UIGraphicsBeginImageContext(handwritingView.frame.size);
        [drawImage.image drawInRect:CGRectMake(0, 0, handwritingView.frame.size.width, handwritingView.frame.size.height)];
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 2.0);
        switch (currentColor) {
            case 0:
                CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 0.0, 1.0, 0.0, 1.0);
                break;
            case 1:
                CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 0.0, 0.0, 1.0, 1.0);
                break;
            case 2:
                CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 1.0, 0.0, 0.0, 1.0);
                break;
            case 3:
                CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 0.5, 0.2, 0.3, 1.0);
                break;
            case 4:
                CGContextSetLineWidth(UIGraphicsGetCurrentContext(), swipeWidth*6.0*(handwritingView.frame.size.height/667.0));
                CGContextSetBlendMode(UIGraphicsGetCurrentContext(),kCGBlendModeClear); 
                CGContextSetStrokeColorWithColor(UIGraphicsGetCurrentContext(),[UIColor clearColor].CGColor);
                break;
            default:
                break;
        }
        CGPoint mid1 = CGPointMake((lastPoint.x+secondLastPoint.x)/2, (lastPoint.y+secondLastPoint.y)/2);
        CGPoint mid2 = CGPointMake((lastPoint.x+currentPoint.x)/2, (lastPoint.y+currentPoint.y)/2);
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), mid1.x, mid1.y);
        CGContextAddQuadCurveToPoint(UIGraphicsGetCurrentContext(),lastPoint.x, lastPoint.y,mid2.x,mid2.y);
        CGContextStrokePath(UIGraphicsGetCurrentContext());
        drawImage.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        secondLastPoint = lastPoint;
        lastPoint = currentPoint;
    }
    else if(count==2 && !isWriteMode){
        touch2 = [[touches allObjects] objectAtIndex:1];
        if([self arePoints:[touch1 locationInView:bgView] And:[touch2 locationInView:bgView] InsideViewFrame:bgView.frame]){
            CGFloat current = [self distanceBetweenTwoPoints:[touch1 locationInView:handwritingView] toPoint:[touch2 locationInView:handwritingView]];
            if(initialDist1>0)
                currentZoom1 = current/initialDist1;
            else
                currentZoom1 = 1.0;
            CGRect frame = handwritingView.frame;
            frame.size.height = initialFrame1.size.height*currentZoom1;
            frame.size.width = initialFrame1.size.width*currentZoom1;
            
            if(frame.size.width > originalSize.width*3.0){
                frame.size.height = originalSize.height*3.0;
                frame.size.width = originalSize.width*3.0;
            }
            else if(frame.size.width < originalSize.width){
                frame.size.height = originalSize.height;
                frame.size.width = originalSize.width;
            }
            
            [btnX setFrame:CGRectMake(btnX.frame.origin.x, btnX.frame.origin.y, (700.0*originalSize.width)/frame.size.width, btnX.frame.size.height)];
            [btnY setFrame:CGRectMake(btnY.frame.origin.x, btnY.frame.origin.y, btnY.frame.size.width, (610.0*originalSize.width)/frame.size.width)];
            btnY.center = CGPointMake(33.0, 378.0);
            btnX.center = CGPointMake(486.0, 731.0);
            
            frame.origin.x = initialFrame1.origin.x - (frame.size.width - initialFrame1.size.width)/2.0;
            frame.origin.y = initialFrame1.origin.y - (frame.size.height - initialFrame1.size.height)/2.0;
            handwritingView.frame = frame;
        }
    }
}

-(IBAction)toggleWrite{
    NSInteger selectedSegment = topTabBar.selectedSegmentIndex;
    switch (selectedSegment){
        case 0:
            isWriteMode = TRUE;
            hideColorsView.hidden = TRUE;
            currentColor = 0;
            swipeWidth=1;
            btnErase.layer.borderWidth = 0;
            break;
        case 1:
            isWriteMode = FALSE;
            hideColorsView.hidden = false;
            break;
        default:
            break;
    }
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    swipeWidth=1;
    isWriteMode = YES;
    drawImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, handwritingView.frame.size.width, handwritingView.frame.size.height)];
    drawImage.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    handwritingView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [handwritingView addSubview:drawImage];
    handwritingView.image = self.firstImage;
    originalSize = handwritingView.frame.size;
    initialDist1 = 150;
    initialFrame1 = handwritingView.frame;
    currentColor = 0;
    btnErase.layer.borderColor = [UIColor blueColor].CGColor;
    [topTabBar setImage:[UIImage imageNamed:@"pen.png"] forSegmentAtIndex:0];
    [topTabBar setImage:[UIImage imageNamed:@"search_icon.png"] forSegmentAtIndex:1];
}

-(IBAction)saveChanges{
    saveCurrImageryChangesAlert = [[proAlertView alloc] initWithTitle:nil message:@"Are you sure you want to submit changes?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes",nil];
    [saveCurrImageryChangesAlert setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
    [saveCurrImageryChangesAlert show];
}

-(IBAction)closePopup{
    closeChangesAlert = [[proAlertView alloc] initWithTitle:nil message:@"Are you sure you want to cancel changes and close screen?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes",nil];
    [closeChangesAlert setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
    [closeChangesAlert show];
}

-(IBAction) cancelChanges{
    cancelChangesAlert = [[proAlertView alloc] initWithTitle:nil message:@"Are you sure you want to cancel changes?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes",nil];
    [cancelChangesAlert setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
    [cancelChangesAlert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex==1){
        if(alertView==saveCurrImageryChangesAlert){
            self.activityController = [ISActivityOverlayController presentActivityOverViewController:self withLabel:@"Uploading Image..."];
            CGSize newSize = handwritingView.frame.size;
            UIGraphicsBeginImageContext(newSize);
            [[self imageWithColor:[UIColor whiteColor]] drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
            [firstImage drawInRect:CGRectMake((newSize.width-(firstImage.size.width*newSize.height)/firstImage.size.height)/2,0,(firstImage.size.width*newSize.height)/firstImage.size.height ,newSize.height)];
            [drawImage.image drawInRect:CGRectMake(0,0,newSize.width,newSize.height) blendMode:kCGBlendModeNormal alpha:1.0];
            self.finalImageToBeSaved = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            [NSThread detachNewThreadSelector:@selector(PostUploadImage:) toTarget:self withObject:UIImageJPEGRepresentation(self.finalImageToBeSaved,1.0)];
        }
        else if(alertView == closeChangesAlert){
            firstImage = nil;
            [self.mParent closeCurrImagery];
        }
        else if(alertView == cancelChangesAlert){
            drawImage.image = nil;
        }
    }
}

-(void)PostUploadImage:(NSData*)_imgData{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSString *urlString = [NSString stringWithFormat:@"http://%@UploadOrderImage",[DataExchange getbaseUrl]];
    //set up the request body
    NSMutableData *body = [[[NSMutableData alloc] init] autorelease];
    NSString* firstStr = @"{\"fileStream\":\"";
    NSString* lastStr = @"\"}";
    // add image data
    [body appendData:[firstStr dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[Base64 encode:_imgData] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[lastStr dataUsingEncoding:NSUTF8StringEncoding]];
    NSString* length = [NSString stringWithFormat:@"%d",body.length];
    // setting up the request object now
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    [request setAllHTTPHeaderFields:[[NSDictionary alloc] initWithObjects:[[NSArray alloc] initWithObjects:@"application/json",@"utf-8",[DataExchange getDomainUrl],[NSString stringWithFormat:@"%@",length], nil] forKeys:[[NSArray alloc] initWithObjects:@"Content-Type",@"charset",@"Host",@"Content-Length", nil]]];
    [request setHTTPBody:body];
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	
	NSString *response= [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding];
    [pool release];
    if([response rangeOfString:@"Request"].location == NSNotFound)
        [self performSelectorOnMainThread:@selector(SuccessToLoadTable:) withObject:response waitUntilDone:NO];    
}

-(void)SuccessToLoadTable:(NSString*)response{
    NSString* dataToPost = [NSString stringWithFormat:@"{\"Mrno\":%@,\"UserRoleID\":%@,\"filename\":%@}",self.mrno,self.userRoleId,response];
    NSURL* myUrl = [[[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://%@PostDoctorComments_file",[DataExchange getbaseUrl]]] autorelease];
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
    [request setURL:myUrl];
    [request setHTTPMethod:@"POST"];
    [request setAllHTTPHeaderFields:[[[NSDictionary alloc] initWithObjects:[[[NSArray alloc] initWithObjects:@"application/json",@"utf-8",[DataExchange getDomainUrl],[NSString stringWithFormat:@"%d",dataToPost.length], nil] autorelease] forKeys:[[[NSArray alloc] initWithObjects:@"Content-Type",@"charset",@"Host",@"Content-Length", nil]autorelease]]autorelease]];
    [request setHTTPBody:[NSData dataWithBytes:[dataToPost UTF8String] length:[dataToPost lengthOfBytesUsingEncoding:NSUTF8StringEncoding]]]; 
    NSURLConnection *theConnection=[[[NSURLConnection alloc] initWithRequest:request delegate:self] autorelease];
    if (!theConnection) {
        proAlertView *alert = [[proAlertView alloc] initWithTitle:@"No Internet Connection" message:@"Please Try Again Later" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
        [alert show];
        [alert release];
    }
    if (self.activityController) {
        [self.activityController dismissActivity];
        self.activityController = nil;
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    NSString *newStr = [[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    if([newStr rangeOfString:@"true"].length != NSNotFound){
        proAlertView *alert = [[proAlertView alloc] initWithTitle:@"Success!" message:@"Image posted successfully." delegate:Nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
        [alert show];
        [alert release];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    if (self.activityController) {
        [self.activityController dismissActivity];
        self.activityController = nil;
    }
    [self.mParent closeCurrImagery];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	proAlertView *alert = [[proAlertView alloc] initWithTitle:@"Something Went Wrong" message:@"Please Try Again" delegate:Nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
	[alert show];
	[alert release];
	return;
}

- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 100.0f, 100.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // return UIInterfaceOrientationIsLandscape(interfaceOrientation);
    return UIInterfaceOrientationLandscapeRight;
}

@end
