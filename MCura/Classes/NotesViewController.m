//
//  NotesViewController.m
//  mCura
//
//  Created by Aakash Chaudhary on 30/03/12.
//  Copyright (c) 2012 aakash272@gmail.com. All rights reserved.
//

#import "NotesViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "STPNLoggedIn.h"
#import "Base64.h"
#import "NSData+Base64.h"
#import "PharmacyViewController.h"
#import <AVFoundation/AVFoundation.h>
#include <CoreMedia/CMBase.h>
#include <CoreMedia/CMTime.h>
#include <CoreFoundation/CoreFoundation.h>
#import <MobileCoreServices/UTCoreTypes.h>

@interface NotesViewController (private)
@end

@implementation NotesViewController

@synthesize mrNo,userRoleId,patient,patientNumber;
@synthesize activityController,mCurrentVisitController,viewIndex;
@synthesize docAddress,docName,docNumber,patCity,currentRecNatureId;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    noOfItemsToBeUploaded=0;
    arrayOfStylistImages = [[NSMutableArray alloc] init];
    drawImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, handwritingView.frame.size.width, handwritingView.frame.size.height)];
    CGRect frame;
    switch (self.viewIndex) {//0 for doctor advice, 1 for plan, 2 for complaint
        case 0:
            topLabel.text = @"Doctor Advice";
            break;
        case 1:
            topLabel.text = @"Plan";
            sendMsgView.hidden = true;
            frame = videoView.frame;
            frame.size.height = 544;
            [videoView setFrame:frame];
            [keyboardView setFrame:frame];
            [stylingView setFrame:frame];
            
            break;
        case 2:
            topLabel.text = @"Patient Complaint";
            sendMsgView.hidden = true;
            frame = videoView.frame;
            frame.size.height = 544;
            [videoView setFrame:frame];
            [keyboardView setFrame:frame];
            [stylingView setFrame:frame];
            break;
        default:
            topLabel.text = @"Doctor Advice";
            break;
    }
    printBtn.hidden = TRUE;
    [handwritingView addSubview:drawImage];
    if([DataExchange getDocDisplayData].count==4){
        lblDocAddress.text = [NSString stringWithFormat:@"%@",[[DataExchange getDocDisplayData] objectAtIndex:1]];
        lblDocName.text = [NSString stringWithFormat:@"%@",[[DataExchange getDocDisplayData] objectAtIndex:0]];
        lblDocNumber.text = [NSString stringWithFormat:@"%@",[[DataExchange getDocDisplayData] objectAtIndex:2]];
        lblDocRow4.text = [NSString stringWithFormat:@"%@",[[DataExchange getDocDisplayData] objectAtIndex:3]];
    }else{
        lblDocAddress.text = docAddress;
        lblDocName.text = docName;
        lblDocNumber.text = docNumber;
    }
    patientNameLblT.text = self.patient.patName;
    NSDateFormatter *df = [[[NSDateFormatter alloc] init] autorelease];
    [df setDateFormat:@"dd-MM-yyyy"];
    patientAgeLblT.text = [PharmacyViewController AgeFromString:[df stringFromDate:[PharmacyViewController mfDateFromDotNetJSONString:(![self.patient.patDOB isKindOfClass:[NSNull class]]?self.patient.patDOB:@"")]]];
    patientMobileLblT.text = patientNumber;
    lblPatCity.text = self.patCity;
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(keyboardDidShow:) 
                                                 name:UIKeyboardDidShowNotification 
                                               object:self.view.window];
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(keyboardDidHide:) 
                                                 name:UIKeyboardDidHideNotification 
                                               object:self.view.window];
    keyboardView.layer.cornerRadius = 10;
    textInputView.layer.cornerRadius = 10;
    stylusScrollView.layer.cornerRadius = 10;
    scrollBG.layer.cornerRadius = 5;
    scrollFG.layer.cornerRadius = 5;
    [scrollFG addTarget:self action:@selector(wasDragged:withEvent:) forControlEvents:UIControlEventTouchDragInside];
    
    [topTabBar setImage:[UIImage imageNamed:@"videoD.png"] forSegmentAtIndex:0];
    [topTabBar setImage:[UIImage imageNamed:@"keyboardD.png"] forSegmentAtIndex:1];
    [topTabBar setImage:[UIImage imageNamed:@"penD.png"] forSegmentAtIndex:2];
    
    currentStylistPageIndex=0;
    [arrayOfStylistImages addObject:[[UIImage alloc] init]];
//    drawImage.image = (UIImage*)[arrayOfStylistImages lastObject];
}

-(IBAction) sendSMSOptions{
    switch (viewIndex) {//0 for doctor advice, 1 for plan, 2 for complaint
        case 0:
            if(!videoView.isHidden)
                [self offerChoices:11];
            else if(!keyboardView.isHidden)
                [self offerChoices:12];
            else if(!stylingView.isHidden)
                [self offerChoices:13];
            break;
        case 1:
            //[self offerChoices:13];
            break;
        case 2:
            //[self offerChoices:13];
            break;
        default:
            //[self offerChoices:3];
            break;
    }
    
}

-(void) offerChoices:(NSInteger)type{
    ChooseActionOptionsController* controller = [[ChooseActionOptionsController alloc] initWithNibName:@"ChooseActionOptionsController" bundle:nil];
    controller.delegate = self;
    controller.type = type;
    [self.view addSubview:controller.view];
    popover = [[UIPopoverController alloc] initWithContentViewController:controller];
    popover.popoverContentSize = CGSizeMake(320, 414);
    [popover presentPopoverFromRect:CGRectMake(500, 700, 20, 20) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
    [controller release];
}

-(void)choicesMade:(_Bool [])choices{
    [[self.view viewWithTag:911] removeFromSuperview];
    [popover dismissPopoverAnimated:YES];
}

-(void)closePopup{
    [popover dismissPopoverAnimated:YES];
}

- (void)keyboardDidHide:(NSNotification *)n{
    CGRect viewFrame = textInputView.frame;
    viewFrame.size.height += 320;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    //do some animation
    [textInputView setFrame:viewFrame];
    [UIView commitAnimations]; 
}

- (void)keyboardDidShow:(NSNotification *)n {
    CGRect viewFrame = textInputView.frame;
    viewFrame.size.height -= 320;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    //do some animation
    [textInputView setFrame:viewFrame];
    [UIView commitAnimations];
}


-(IBAction)beginVideoRecording{
    imagePicker = [[[UIImagePickerController alloc] init] autorelease];
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePicker.mediaTypes =[[NSArray alloc] initWithObjects: (NSString *)kUTTypeMovie, nil];
    imagePicker.videoQuality=UIImagePickerControllerQualityTypeLow;
    imagePicker.delegate = self;
    imagePicker.allowsEditing = NO;
    [imagePicker startVideoCapture];
    [self presentModalViewController:imagePicker animated:YES];
}

-(IBAction) clickCancel:(id)sender{
    if(drawImage.image!=NULL || textInputView.text.length>0){
        closeAlertView= [[proAlertView alloc] initWithTitle:@"Close Screen!" message:@"Proceed?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"YES",nil];
        [closeAlertView setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
        [closeAlertView show];
    }else{
        closeAlertView= [[proAlertView alloc] initWithTitle:@"Close Screen!" message:@"Proceed?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"YES",nil];
        [closeAlertView setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
        [closeAlertView show];
    }
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
}

- (void)wasDragged:(UIButton *)button withEvent:(UIEvent *)event{
	// get the touch
	UITouch *touch = [[event touchesForView:button] anyObject];
	// get delta
	CGPoint previousLocation = [touch previousLocationInView:button];
	CGPoint location = [touch locationInView:button];
	CGFloat delta_y = location.y - previousLocation.y;
	// move button
    if(button.center.y + delta_y >= 80 && button.center.y + delta_y <= (viewIndex==0?404:461))
        button.center = CGPointMake(button.center.x, button.center.y + delta_y);
    [stylusScrollView setContentOffset:CGPointMake(0, 720.0*(button.center.y-80)/(viewIndex==0?324:381)) animated:NO];
}

- (IBAction)doSegmentSwitch:(id)sender {
    UISegmentedControl *segmentedControl = (UISegmentedControl *) sender;
    NSInteger selectedSegment = segmentedControl.selectedSegmentIndex;
    switch (selectedSegment) {
        case 0:
            videoView.hidden = false;
            keyboardView.hidden = true;
            stylingView.hidden = true;
            if (self.viewIndex==0) {
                printBtn.hidden = TRUE;
            }
            break;
        case 1:
            videoView.hidden = true;
            keyboardView.hidden = false;
            stylingView.hidden = true;
            if (self.viewIndex==0) {
                printBtn.hidden = FALSE;
            }
            break;
        case 2:
            videoView.hidden = true;
            keyboardView.hidden = true;
            stylingView.hidden = false;
            if (self.viewIndex==0) {
                printBtn.hidden = FALSE;
            }
            break;
        default:
            break;
    }
}

#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)info {
	[self didFinishWithCamera];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if([mediaType isEqualToString:@"public.image"]){
        proAlertView *alert = [[proAlertView alloc] initWithTitle:@"Sorry!" message:@"Please switch to video mode and try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
        [alert show];
        [alert release];
        [self didFinishWithCamera];
        return;
    }
    else if ([mediaType isEqualToString:@"public.movie"]){
 #if 1	       
        NSURL *videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        
        NSFileManager *manager = [NSFileManager defaultManager];
        
        NSString *outputURL = [documentsDirectory stringByAppendingPathComponent:@"output"] ;
        [manager createDirectoryAtPath:outputURL withIntermediateDirectories:YES attributes:nil error:nil];
        
        outputURL = [outputURL stringByAppendingPathComponent:@"output.mp4"];
        // Remove Existing File
        [manager removeItemAtPath:outputURL error:nil];
        
        AVURLAsset *videoAsset = [AVURLAsset URLAssetWithURL:videoURL options:nil]; 
        
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:videoAsset presetName:AVAssetExportPresetHighestQuality];
        exportSession.outputURL = [NSURL fileURLWithPath:outputURL];
        exportSession.outputFileType = AVFileTypeQuickTimeMovie;
        exportSession.shouldOptimizeForNetworkUse = YES;
        
        CMTime start = CMTimeMakeWithSeconds(1.0, 600);
        CMTime duration = CMTimeMakeWithSeconds(30.0, 600);
        
        
        CMTimeRange timeRange = CMTimeRangeMake(start, duration);
        exportSession.timeRange = timeRange;
        
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            switch (exportSession.status) {
                case AVAssetExportSessionStatusCompleted:
                    // Custom method to import the Exported Video
                    [self loadAssetFromFile:exportSession.outputURL];
                    break;
                case AVAssetExportSessionStatusFailed:
                    //
                    NSLog(@"Failed:%@",exportSession.error);
                    break;
                case AVAssetExportSessionStatusCancelled:
                    //
                    NSLog(@"Canceled:%@",exportSession.error);
                    break;
                default:
                    break;
            }
        }];
#endif 
    }
}

-(void)loadAssetFromFile:(NSURL*)exportSession{
    NSString *pathToVideo = [exportSession path];
    UISaveVideoAtPathToSavedPhotosAlbum(pathToVideo, self, @selector(video:didFinishSavingWithError:contextInfo:), NULL);
}

- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSURL *videoURL=[NSURL fileURLWithPath:videoPath];
    videoData = [[NSData alloc] initWithContentsOfURL:videoURL];    
    [self didFinishWithCamera];
    [self PostUploadVideo:videoData];
    postVideoView.hidden = false;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self didFinishWithCamera];
}

- (void)didFinishWithCamera {
    [self dismissModalViewControllerAnimated:YES];
}

-(void)PostUploadVideo:(NSData*)_videoData{
    NSString *urlString = [NSString stringWithFormat:@"http://%@UploadOrderVedio",[DataExchange getbaseUrl]];
    //set up the request body
    NSMutableData *body = [[NSMutableData alloc] init];
    NSString* firstStr = @"{\"fileStream\":\"";
    NSString* lastStr = @"\"}";
    // add image data
   [body appendData:[firstStr dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[Base64 encode:_videoData] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[lastStr dataUsingEncoding:NSUTF8StringEncoding]];
    // setting up the request object now
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    [request setAllHTTPHeaderFields:[[NSDictionary alloc] initWithObjects:[[NSArray alloc] initWithObjects:@"application/json",@"utf-8",[DataExchange getDomainUrl],[NSString stringWithFormat:@"%d",body.length], nil] forKeys:[[NSArray alloc] initWithObjects:@"Content-Type",@"charset",@"Host",@"Content-Length", nil]]];
    [request setHTTPBody:body];
    videoConnection = [[[NSURLConnection alloc] initWithRequest:request delegate:self] autorelease];
}

-(void)PostUploadImage:(NSData*)_imgData{
//    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSString *urlString = [NSString stringWithFormat:@"http://%@UploadOrderImage",[DataExchange getbaseUrl]];
    //set up the request body
    NSMutableData *body = [[NSMutableData alloc] init];
    NSString* firstStr = @"{\"fileStream\":\"";
    NSString* lastStr = @"\"}";
    // add image data
    [body appendData:[firstStr dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[Base64 encode:_imgData] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[lastStr dataUsingEncoding:NSUTF8StringEncoding]];
    // setting up the request object now
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    [request setAllHTTPHeaderFields:[[NSDictionary alloc] initWithObjects:[[NSArray alloc] initWithObjects:@"application/json",@"utf-8",[DataExchange getDomainUrl],[NSString stringWithFormat:@"%d",body.length], nil] forKeys:[[NSArray alloc] initWithObjects:@"Content-Type",@"charset",@"Host",@"Content-Length", nil]]];
    
    [request setHTTPBody:body];
    stylusPicConnection = [[[NSURLConnection alloc] initWithRequest:request delegate:self] autorelease];
}

-(void)PostUploadText:(NSString*)_textString{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSString *urlString = [NSString stringWithFormat:@"http://%@UploadOrderText",[DataExchange getbaseUrl]];
    //set up the request body
    NSMutableData *body = [[NSMutableData alloc] init];
    NSString* firstStr = @"{\"fileStream\":\"";
    NSString* lastStr = @"\"}";
    // add image data
    [body appendData:[firstStr dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[Base64 encode:[_textString dataUsingEncoding:NSUTF8StringEncoding]] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[lastStr dataUsingEncoding:NSUTF8StringEncoding]];
    // setting up the request object now
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    [request setAllHTTPHeaderFields:[[NSDictionary alloc] initWithObjects:[[NSArray alloc] initWithObjects:@"application/json",@"utf-8",[DataExchange getDomainUrl],[NSString stringWithFormat:@"%d",body.length], nil] forKeys:[[NSArray alloc] initWithObjects:@"Content-Type",@"charset",@"Host",@"Content-Length", nil]]];
    [request setHTTPBody:body];
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	
	NSString *response= [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding];
    [pool release];
    if([response rangeOfString:@"Request"].location == NSNotFound){
        [self performSelectorOnMainThread:@selector(SuccessToLoadTable:) withObject:response waitUntilDone:NO];
    }
}

-(void)SuccessToLoadTable:(NSString*)response{
    if(![textInputView isHidden]){
        textInputView.text = @"";
    }
    NSString* dataToPost = dataToPost = [NSString stringWithFormat:@"{\"Mrno\":%@,\"RecNatureId\":%d,\"UserRoleID\":%@,\"filename\":%@}",self.mrNo,self.currentRecNatureId,userRoleId,response];
    NSURL* myUrl = [[[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://%@PostPatientFile",[DataExchange getbaseUrl]]] autorelease];
    NSLog(@"%@,%@",dataToPost,myUrl);
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
    [request setURL:myUrl];
    [request setHTTPMethod:@"POST"];
    [request setAllHTTPHeaderFields:[[[NSDictionary alloc] initWithObjects:[[[NSArray alloc] initWithObjects:@"application/json",@"utf-8",[DataExchange getDomainUrl],[NSString stringWithFormat:@"%d",dataToPost.length], nil] autorelease] forKeys:[[[NSArray alloc] initWithObjects:@"Content-Type",@"charset",@"Host",@"Content-Length", nil]autorelease]]autorelease]];
    [request setHTTPBody:[NSData dataWithBytes:[dataToPost UTF8String] length:[dataToPost lengthOfBytesUsingEncoding:NSUTF8StringEncoding]]]; 
    NSURLConnection *theConnection=[[[NSURLConnection alloc] initWithRequest:request delegate:self] autorelease];
    if (!theConnection) {
        proAlertView *alert = [[proAlertView alloc] initWithTitle:@"No Internet Connection" message:@"Please Try Again Later" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
        [alert show];
        [alert release];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    NSString *newStr = [[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    NSLog(@"---%@",newStr);
    postStylusView.hidden = true;
    if(connection==videoConnection || connection==stylusPicConnection){
        [self SuccessToLoadTable:newStr];
    }
}

- (void)connection:(NSURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite{
    if(connection==videoConnection){
        CGRect frame = videoPostProgressBar.frame;
        frame.size.width = (totalBytesWritten*461/totalBytesExpectedToWrite);
        [videoPostProgressBar setFrame:frame];
        [progressLbl setText:[NSString stringWithFormat:@"%d kB of %d kB sent (%d%%)",totalBytesWritten/1000,totalBytesExpectedToWrite/1000,(totalBytesWritten*100/totalBytesExpectedToWrite)]];
        if(totalBytesWritten==totalBytesExpectedToWrite)
            postVideoView.hidden = true;
    }else if(connection==stylusPicConnection){
        CGRect frame = stylusProgressBar.frame;
        frame.size.width = (totalBytesWritten*461/totalBytesExpectedToWrite);
        [stylusProgressBar setFrame:frame];
        [stylusProgressLbl setText:[NSString stringWithFormat:@"%d kB of %d kB sent (%d%%)",totalBytesWritten/1000,totalBytesExpectedToWrite/1000,(totalBytesWritten*100/totalBytesExpectedToWrite)]];
        if(totalBytesWritten==totalBytesExpectedToWrite)
            [stylusProgressLbl setText:@"Finishing"];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    if (self.activityController) {
        [self.activityController dismissActivity];
        self.activityController = nil;
    }
    if(connection==stylusPicConnection){
        drawImage.image = NULL;
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	proAlertView *alert = [[proAlertView alloc] initWithTitle:@"Something Went Wrong" message:@"Please Try Again" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
    [alert setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
	[alert show];
	[alert release];
	return;
}

-(IBAction)cancelCurrVideoPost{
    stopVidPostAlertView= [[proAlertView alloc] initWithTitle:@"Cancel Post?" message:@"Some progress has been made. Proceed?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes",nil];
    [stopVidPostAlertView setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
    [stopVidPostAlertView show];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSArray *allTouches = [touches allObjects];
    int count = [allTouches count];
	if(count==1){
        UITouch *touch = [touches anyObject];
        lastPoint = [touch locationInView:handwritingView];
        secondLastPoint = lastPoint;
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    NSArray *allTouches = [touches allObjects];
    int count = [allTouches count];
	if(count==1){
        UITouch *touch = [touches anyObject];	
        CGPoint currentPoint = [touch locationInView:handwritingView];
        UIGraphicsBeginImageContext(handwritingView.frame.size);
        if(drawImage.image!=NULL)
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
                CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 6.0*(handwritingView.frame.size.height/350));
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
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    if(drawImage.image!=NULL)
        [arrayOfStylistImages replaceObjectAtIndex:currentStylistPageIndex withObject:drawImage.image];
}

-(IBAction) saveChanges{
    if(drawImage.image!=nil && ![stylingView isHidden]){
        noOfItemsToBeUploaded++;
        CGSize newSize = CGSizeMake(drawImage.image.size.width, drawImage.image.size.height*arrayOfStylistImages.count);
        UIGraphicsBeginImageContext(newSize);
        
        for(int i=0;i<arrayOfStylistImages.count;i++){
            [[arrayOfStylistImages objectAtIndex:i] drawInRect:CGRectMake(0,drawImage.image.size.height*i,newSize.width,drawImage.image.size.height)];
        }
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        NSData *imageData=UIImageJPEGRepresentation(newImage,1.0);
        UIGraphicsEndImageContext();
        [self PostUploadImage:imageData];
        postStylusView.hidden = false;
    }
    if(textInputView.text.length!=0 && ![keyboardView isHidden]){
        noOfItemsToBeUploaded++;
        self.activityController = [ISActivityOverlayController presentActivityOverViewController:self withLabel:@"Uploading Text entry..."];
        [NSThread detachNewThreadSelector:@selector(PostUploadText:) toTarget:self withObject:textInputView.text];
    }
    if(drawImage.image==nil && textInputView.text.length==0){
        proAlertView* alert= [[proAlertView alloc] initWithTitle:nil message:@"No files to upload!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
        [alert show];
        [alert release];
        if (self.activityController) {
            [self.activityController dismissActivity];
            self.activityController = Nil;
        }
    } 
}

-(IBAction)cancelChanges{
    if(![keyboardView isHidden] && textInputView.text.length>0){
        deleteAlertView= [[proAlertView alloc] initWithTitle:@"Delete?" message:@"Proceed?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"YES",nil];
        [deleteAlertView setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
        deleteAlertView.tag = 12;
        [deleteAlertView show];
    }else if(![stylingView isHidden] && drawImage.image!=NULL){
        deleteAlertView= [[proAlertView alloc] initWithTitle:@"Delete?" message:@"Proceed?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"YES",nil];
        [deleteAlertView setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
        deleteAlertView.tag = 13;
        [deleteAlertView show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex==1){
        if(alertView==deleteAlertView){
            switch (alertView.tag) {
                case 12:
                    textInputView.text = @"";
                    break;
                case 13:
                    drawImage.image = nil;
                    break;
                case 15:
                    videoData = nil;
                    //postVideoButtonView.hidden = true;
                    break;
                default:
                    break;
            }
        }
        else if(alertView == closeAlertView){
            [textInputView resignFirstResponder];
            [self dismissModalViewControllerAnimated:YES];
        }
        else if(alertView==stopVidPostAlertView){
            if(![videoView isHidden]){
                [videoConnection cancel];
                CGRect frame = videoPostProgressBar.frame;
                frame.size.width = 461;
                [videoPostProgressBar setFrame:frame];
                [progressLbl setText:@"Sending cancelled!"];
                [UIView beginAnimations:nil context:NULL];
                [UIView setAnimationDelay:1.0];
                [UIView setAnimationDuration:0.1];
                //do some animation
                postVideoView.hidden = true;
                [UIView commitAnimations];
            }else if(![stylingView isHidden]){
                [stylusPicConnection cancel];
                CGRect frame = stylusProgressBar.frame;
                frame.size.width = 461;
                [stylusProgressBar setFrame:frame];
                [stylusProgressLbl setText:@"Sending cancelled!"];
                [UIView beginAnimations:nil context:NULL];
                [UIView setAnimationDelay:1.0];
                [UIView setAnimationDuration:0.1];
                //do some animation
                postStylusView.hidden = true;
                [UIView commitAnimations];
            }
        }
    }
}

#pragma mark print

-(void)printdoc{
    // create top header
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(1024, 748),YES,0.0f);
    CGContextRef contextT = UIGraphicsGetCurrentContext();
    [self.view.layer renderInContext:contextT];
    UIImage *viewSnapshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(1024, 119),YES,0.0f);
    [viewSnapshot drawInRect:CGRectMake(0, -44, 1024, 748)];
    UIImage *topHeader = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImage* finalImage=nil;
    switch (topTabBar.selectedSegmentIndex) {
        case 1:
            if(textInputView.text.length>0){
                UIGraphicsBeginImageContextWithOptions(CGSizeMake(1024, 1448),YES,0.0f);// A4 size
                CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(), [[UIColor whiteColor] CGColor]);
                CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, 1024, 1448));
                CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(), [[UIColor blackColor] CGColor]);
                [topHeader drawInRect:CGRectMake(0, 20, 1024, 119)];
                [textInputView.text drawInRect:CGRectMake(40, 200, 944, 1000) withFont:[UIFont boldSystemFontOfSize:18.0] lineBreakMode:UILineBreakModeWordWrap];
                finalImage = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
            }
            else{
                proAlertView* alert= [[proAlertView alloc] initWithTitle:@"Alert!" message:@"Please enter some text to print." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [alert setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
                [alert show];
                [alert release];
            }
            break;
        case 2:
            if (drawImage.image){
                UIGraphicsBeginImageContextWithOptions(CGSizeMake(1024, 1448),YES,0.0f);// A4 size
                CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(), [[UIColor whiteColor] CGColor]);
                CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, 1024, 1448));
                [topHeader drawInRect:CGRectMake(0, 20, 1024, 119)];
                [drawImage.image drawInRect:CGRectMake(114, 140, 800, 1100)];
                finalImage = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
            }
            else{
                proAlertView* alert= [[proAlertView alloc] initWithTitle:@"Alert!" message:@"Please write some text to print." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [alert setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
                [alert show];
                [alert release];
            }
            break;
        default:
            break;
    }

    NSData * imageData = UIImageJPEGRepresentation(finalImage,1.0);
    UIPrintInteractionController *pic = [UIPrintInteractionController sharedPrintController];
    if  (pic && [UIPrintInteractionController canPrintData:imageData] ) {
        pic.delegate = self;
        UIPrintInfo *printInfo = [UIPrintInfo printInfo];
        printInfo.outputType = UIPrintInfoOutputGeneral;
        printInfo.jobName = @"mCura Doctor Note";
        printInfo.duplex = UIPrintInfoDuplexNone;
        pic.printInfo = printInfo;
        pic.showsPageRange = YES;
        pic.printingItem = imageData;
        void (^completionHandler)(UIPrintInteractionController *, BOOL, NSError *) =
        ^(UIPrintInteractionController *pic, BOOL completed, NSError *error) {
            if (!completed && error)
                NSLog(@"FAILED! due to error in domain %@ with error code %u",
                      error.domain, error.code);
        };
        // iPad only printing
        [pic presentAnimated:YES completionHandler:completionHandler];
    }
    else{
        proAlertView* alert= [[proAlertView alloc] initWithTitle:@"Sorry!" message:@"Printer unavailable! Please connect to a printer and try again." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
        [alert show];
        [alert release];
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
