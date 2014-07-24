//
//  ReferralViewController.m
//  mCura
//
//  Created by Aakash Chaudhary on 16/04/12.
//  Copyright (c) 2012 aakash272@gmail.com. All rights reserved.
//

#import "ReferralViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <AVFoundation/AVFoundation.h>
#include <CoreMedia/CMBase.h>
#include <CoreMedia/CMTime.h>
#include <CoreFoundation/CoreFoundation.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import "STPNLoggedIn.h"
#import "Base64.h"
#import "NSData+Base64.h"
#import "_GMDocService.h"
#import "GetDoctorReferralInvocation.h"
#import "PharmacyViewController.h"
#import "DoctorDetails.h"

@interface ReferralViewController (private)<GetDoctorReferralInvocationDelegate>
@end

@implementation ReferralViewController
@synthesize mrNo,userRoleId,subTenId,activityController;
@synthesize service,mCurrentVisitController,patient,patientNumber;
@synthesize docAddress,docName,docNumber,patCity;

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
    noOfItemsToBeUploaded=0;
    currentDoctorSelected = -1;
    self.service = [[[_GMDocService alloc] init] autorelease];
    [self.service getDoctorReferralInvocation:self.userRoleId SubTenantId:self.subTenId delegate:self];
    self.activityController = [ISActivityOverlayController presentActivityOverViewController:self withLabel:@"Loading..."];
    drawImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, handwritingView.frame.size.width, handwritingView.frame.size.height)];
    [handwritingView addSubview:drawImage];
    patientNameLblT.text = self.patient.patName;
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
    lblPatCity.text = self.patCity;
    NSDateFormatter *df = [[[NSDateFormatter alloc] init] autorelease];
    [df setDateFormat:@"dd-MM-yyyy"];
    patientAgeLblT.text = [PharmacyViewController AgeFromString:[df stringFromDate:[PharmacyViewController mfDateFromDotNetJSONString:(![self.patient.patDOB isKindOfClass:[NSNull class]]?self.patient.patDOB:@"")]]];
    patientMobileLblT.text = patientNumber;
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(keyboardDidShow:) 
                                                 name:UIKeyboardDidShowNotification 
                                               object:self.view.window];
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(keyboardDidHide:) 
                                                 name:UIKeyboardDidHideNotification 
                                               object:self.view.window];
    [topTabBar setImage:[UIImage imageNamed:@"videoD.png"] forSegmentAtIndex:0];
    [topTabBar setImage:[UIImage imageNamed:@"keyboardD.png"] forSegmentAtIndex:1];
    [topTabBar setImage:[UIImage imageNamed:@"penD.png"] forSegmentAtIndex:2];
    keyboardView.layer.cornerRadius = 10;
    textInputView.layer.cornerRadius = 10;
    stylusScrollView.layer.cornerRadius = 10;
    tblDoctorNames.layer.cornerRadius = 10;
    scrollBG.layer.cornerRadius = 5;
    scrollFG.layer.cornerRadius = 5;
    [scrollFG addTarget:self action:@selector(wasDragged:withEvent:) forControlEvents:UIControlEventTouchDragInside];

    currentStylistPageIndex=0;
    arrayOfStylistImages = [[NSMutableArray alloc] init];
    [arrayOfStylistImages addObject:[[UIImage alloc] init]];
    drawImage.image = (UIImage*)[arrayOfStylistImages lastObject];
}

-(IBAction) sendSMSOptions{
    [self offerChoices:3];
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

- (void)wasDragged:(UIButton *)button withEvent:(UIEvent *)event{
	// get the touch
	UITouch *touch = [[event touchesForView:button] anyObject];
	// get delta
	CGPoint previousLocation = [touch previousLocationInView:button];
	CGPoint location = [touch locationInView:button];
	CGFloat delta_y = location.y - previousLocation.y;
	// move button
    if(button.center.y + delta_y >= 80 && button.center.y + delta_y <= 444)
        button.center = CGPointMake(button.center.x, button.center.y + delta_y);
    [stylusScrollView setContentOffset:CGPointMake(0, 720.0*(button.center.y-80)/364) animated:NO];
}

-(IBAction)beginVideoRecording{
    if(currentDoctorSelected<0){
        proAlertView *alert = [[proAlertView alloc] initWithTitle:@"Warning" message:@"Please select a doctor before proceeding" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
        [alert show];
        [alert release];
    }else{
        imagePicker = [[[UIImagePickerController alloc] init] autorelease];
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.mediaTypes =[[NSArray alloc] initWithObjects: (NSString *)kUTTypeMovie, nil];
        imagePicker.videoQuality=UIImagePickerControllerQualityTypeLow;
        imagePicker.delegate = self;
        imagePicker.allowsEditing = NO;
        [imagePicker startVideoCapture];
        [self presentModalViewController:imagePicker animated:YES];
    }
}

-(IBAction) clickCancel:(id)sender{
    closeAlertView= [[proAlertView alloc] initWithTitle:@"Close Screen!" message:@"Proceed?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"YES",nil];
    [closeAlertView setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
    [closeAlertView show];
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

- (IBAction)doSegmentSwitch:(id)sender {
    UISegmentedControl *segmentedControl = (UISegmentedControl *) sender;
    NSInteger selectedSegment = segmentedControl.selectedSegmentIndex;
    switch (selectedSegment) {
        case 0:
            videoView.hidden = false;
            keyboardView.hidden = true;
            stylingView.hidden = true;
            break;
        case 1:
            videoView.hidden = true;
            keyboardView.hidden = false;
            stylingView.hidden = true;
            break;
        case 2:
            videoView.hidden = true;
            keyboardView.hidden = true;
            stylingView.hidden = false;
            break;
        default:
            break;
    }
}

-(void)GetDoctorReferralInvocationDidFinish:(GetDoctorReferralInvocation *)invocation 
                    withDoctorReferralArray:(NSArray *)doctReferArray 
                                  withError:(NSError *)error{
    if(!error){
        arrayDoctorNames = [[NSMutableArray alloc] initWithArray:doctReferArray];
        [tblDoctorNames reloadData];
    }
    if (self.activityController) {
		[self.activityController dismissActivity];
		self.activityController = Nil;
	}
}

-(IBAction)doctorNameBtnClicked{
    tblDoctorNames.hidden = false;
}

+ (NSDate *)mfDateFromDotNetJSONString:(NSString *)string{
    static NSRegularExpression *dateRegEx = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateRegEx = [[NSRegularExpression alloc] initWithPattern:@"^\\/date\\((-?\\d++)(?:([+-])(\\d{2})(\\d{2}))?\\)\\/$" options:NSRegularExpressionCaseInsensitive error:nil];
    });
    NSTextCheckingResult *regexResult = [dateRegEx firstMatchInString:string options:0 range:NSMakeRange(0, [string length])];
    
    if (regexResult) {
        // milliseconds
        NSTimeInterval seconds = [[string substringWithRange:[regexResult rangeAtIndex:1]] doubleValue] / 1000.0;
        // timezone offset
        if ([regexResult rangeAtIndex:2].location != NSNotFound) {
            NSString *sign = [string substringWithRange:[regexResult rangeAtIndex:2]];
            // hours
            seconds += [[NSString stringWithFormat:@"%@%@", sign, [string substringWithRange:[regexResult rangeAtIndex:3]]] doubleValue] * 60.0 * 60.0;
            // minutes
            seconds += [[NSString stringWithFormat:@"%@%@", sign, [string substringWithRange:[regexResult rangeAtIndex:4]]] doubleValue] * 60.0;
        }
        return [NSDate dateWithTimeIntervalSince1970:seconds];
    }
    return nil;
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrayDoctorNames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    NSDateFormatter *df = [[[NSDateFormatter alloc] init] autorelease];
    [df setDateFormat:@"dd-MM-yyyy"];
    UITableViewCell *cell = [tblDoctorNames dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    cell.textLabel.text = [(DoctorDetails*)[arrayDoctorNames objectAtIndex:indexPath.row] Uname];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"D.O.B.- %@",[df stringFromDate:[ReferralViewController mfDateFromDotNetJSONString:[(DoctorDetails*)[arrayDoctorNames objectAtIndex:indexPath.row] Dob]]]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    btnDoctorName.titleLabel.text = cell.textLabel.text;
    tblDoctorNames.hidden = true;
    currentDoctorSelected = indexPath.row;
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
        NSLog(@"found a video");
        NSURL *videoURL    = [info objectForKey:UIImagePickerControllerMediaURL];
        NSLog(@"%@",videoURL);
        
        NSString *pathToVideo = [videoURL path];
        NSLog(@"pathToVideo=%@",pathToVideo);
        
        NSNumber *startN = [info objectForKey:@"_UIImagePickerControllerVideoEditingStart"];
        NSNumber *endN = [info objectForKey:@"_UIImagePickerControllerVideoEditingEnd"];
        
        int startMilliseconds = ([startN doubleValue] * 1000);
        int endMilliseconds = ([endN doubleValue] * 1000);
        NSLog(@"startVideo=%d,endVideo=%d",startMilliseconds,endMilliseconds);
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        
        NSFileManager *manager = [NSFileManager defaultManager];
        
        NSString *outputURL = [documentsDirectory stringByAppendingPathComponent:@"output"] ;
        [manager createDirectoryAtPath:outputURL withIntermediateDirectories:YES attributes:nil error:nil];
        
        outputURL = [outputURL stringByAppendingPathComponent:@"output.mp4"];
        NSLog(@"outputURL=%@",outputURL);
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
    NSLog(@"exportSession=%@",exportSession);
    NSString *pathToVideo = [exportSession path];
    UISaveVideoAtPathToSavedPhotosAlbum(pathToVideo, self, @selector(video:didFinishSavingWithError:contextInfo:), NULL);
}

- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSLog(@"didFinishSavingWithError");
    NSLog(@"videoPath=%@",videoPath);
    NSURL *videoURL=[NSURL fileURLWithPath:videoPath];
    videoData = [[NSData alloc] initWithContentsOfURL:videoURL];
    [self didFinishWithCamera];
    [self PostUploadVideo:videoData];
    postVideoView.hidden = false;
}

-(IBAction)postCurrVideo{
    
}

-(IBAction)cancelCurrVideo{
    deleteAlertView= [[proAlertView alloc] initWithTitle:@"Delete video?" message:@"Proceed?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"YES",nil];
    [deleteAlertView setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
    deleteAlertView.tag = 15;
    [deleteAlertView show];
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
    if([response rangeOfString:@"Request"].location == NSNotFound)
        [self performSelectorOnMainThread:@selector(SuccessToLoadTable:) withObject:response waitUntilDone:NO];    
}

-(void)SuccessToLoadTable:(NSString*)response{
    NSString* dataToPost = [NSString stringWithFormat:@"{\"Mrno\":%@,\"UserRoleID\":%@,\"subtenantid\":%@,\"RefrealDoctor_UserRoleID\":%@,\"filename\":%@}",self.mrNo,self.userRoleId,self.subTenId,[[(DoctorDetails*)[arrayDoctorNames objectAtIndex:currentDoctorSelected] UserId] stringValue],response];
    NSURL* myUrl = [[[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://%@PostRefreal",[DataExchange getbaseUrl]]] autorelease];
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
    
    //VINAY.....
    if (self.activityController) {
        [self.activityController dismissActivity];
        self.activityController = nil;
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

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    noOfItemsToBeUploaded--;
    if(noOfItemsToBeUploaded==0){
        if (self.activityController) {
            [self.activityController dismissActivity];
            self.activityController = nil;
        }
        [mCurrentVisitController labOrderDidSubmit];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
	proAlertView *alert = [[proAlertView alloc] initWithTitle:@"Something Went Wrong" message:@"Please Try Again" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
    [alert setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
	[alert show];
	[alert release];
	return;
}

- (void)connection:(NSURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite{
    if(connection==videoConnection){
        CGRect frame = videoPostProgressBar.frame;
        frame.size.width = (totalBytesWritten*461/totalBytesExpectedToWrite);
        [videoPostProgressBar setFrame:frame];
        [progressLbl setText:[NSString stringWithFormat:@"%d kB of %d kB sent (%d%%)",totalBytesWritten/1000,totalBytesExpectedToWrite/1000,(totalBytesWritten*100/totalBytesExpectedToWrite)]];
        if(totalBytesWritten==totalBytesExpectedToWrite)
            postVideoView.hidden = true;
    }
    else if(connection==stylusPicConnection){
        CGRect frame = stylusProgressBar.frame;
        frame.size.width = (totalBytesWritten*461/totalBytesExpectedToWrite);
        [stylusProgressBar setFrame:frame];
        [stylusProgressLbl setText:[NSString stringWithFormat:@"%d kB of %d kB sent (%d%%)",totalBytesWritten/1000,totalBytesExpectedToWrite/1000,(totalBytesWritten*100/totalBytesExpectedToWrite)]];
        if(totalBytesWritten==totalBytesExpectedToWrite)
            [stylusProgressLbl setText:@"Finishing"];
    }
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
    tblDoctorNames.hidden = true;
    [arrayOfStylistImages replaceObjectAtIndex:currentStylistPageIndex withObject:drawImage.image];
}

-(IBAction) saveChanges{
    if(currentDoctorSelected<0){
        proAlertView *alert = [[proAlertView alloc] initWithTitle:@"Close screen!" message:@"Proceed?" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
        [alert show];
        [alert release];
        return;
    }
    if(drawImage.image!=nil && ![stylingView isHidden]){
        noOfItemsToBeUploaded++;
        CGSize newSize = CGSizeMake(drawImage.image.size.width, drawImage.image.size.height*arrayOfStylistImages.count);
        UIGraphicsBeginImageContext(newSize);
        for(int i=0;i<arrayOfStylistImages.count;i++){
            [[arrayOfStylistImages objectAtIndex:i] drawInRect:CGRectMake(0,drawImage.image.size.height*i,newSize.width,newSize.height)];
        }
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        NSData *imageData=UIImageJPEGRepresentation(newImage,1.0);
        UIGraphicsEndImageContext();
        [self PostUploadImage:imageData];
        postStylusView.hidden = false;
    }
    if(textInputView.text.length!=0){
        noOfItemsToBeUploaded++;
        self.activityController = [ISActivityOverlayController presentActivityOverViewController:self withLabel:@"Uploading notes..."];
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
    deleteAlertView= [[proAlertView alloc] initWithTitle:@"Close Screen!" message:@"Proceed?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"YES",nil];
    [deleteAlertView setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
    [deleteAlertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex==1){
        if(alertView==deleteAlertView){
            switch (alertView.tag) {
                case 15:
                    videoData = nil;
                    break;
                default:
                    drawImage.image = nil;
                    textInputView.text = @"";
                    break;
            }
        }
        else if(alertView == closeAlertView){
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

-(IBAction)printdoc{
    
    NSData * imageData = UIImageJPEGRepresentation([arrayOfStylistImages lastObject],1.0);
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
