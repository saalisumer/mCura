//
//  DocCurrVisitViewController.m
//  mCura
//
//  Created by Aakash Chaudhary on 05/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DocCurrVisitViewController.h"
#import "Base64.h"
#import "NSData+Base64.h"
#import "GetNotesInvocation.h"
#import "GetCurrentVisitFileInvocation.h"
#import "GetLabReportInvocation.h"
#import "proAlertView.h"
#import "PharmacyViewController.h"
#import "LabReport.h"
#import <AVFoundation/AVFoundation.h>
#include <CoreMedia/CMBase.h>
#include <CoreMedia/CMTime.h>
#include <CoreFoundation/CoreFoundation.h>
#import <MobileCoreServices/UTCoreTypes.h>

@interface DocCurrVisitViewController(private) <GetCurrentVisitFileInvocationDelegate,GetNotesInvocationDelegate,GetLabReportInvocationDelegate>
@end

@implementation DocCurrVisitViewController
@synthesize docAddress,docName,docNumber,patient,patientNumber,labReportRecNatureIndex,currVisitRecNatureIndex,mParentController;
@synthesize userRoleId,mrNo,activityController,listOfRecords,service,patCity,dateDtls,doctorNamesArray,imageDtls,currentImagePath;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.service = [[[_GMDocService alloc] init] autorelease];
    zoomTogether = false;
    [topTabBar setImage:[UIImage imageNamed:@"photoD.png"] forSegmentAtIndex:0];
    [topTabBar setImage:[UIImage imageNamed:@"videoD.png"] forSegmentAtIndex:1];
    [topTabBar setImage:[UIImage imageNamed:@"comparisonD.png"] forSegmentAtIndex:2];
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
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    if(scrollView==firstScrollView){
        return firstImgBtn;
    }
    else{
        return secondImgBtn;
    }
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
    if(zoomTogether){
        if(scrollView==firstScrollView){
            secondScrollView.zoomScale = firstScrollView.zoomScale;
        }
        else{
            firstScrollView.zoomScale = secondScrollView.zoomScale;
        }
    }
}

- (IBAction)doSegmentSwitch:(id)sender {
    UISegmentedControl *segmentedControl = (UISegmentedControl *) sender;
    NSInteger selectedSegment = segmentedControl.selectedSegmentIndex;
    switch (selectedSegment) {
        case 0:
            photoView.hidden = false;
            videoView.hidden = true;
            comparisonView.hidden = true;
            break;
        case 1:
            photoView.hidden = true;
            videoView.hidden = false;
            comparisonView.hidden = true;
            break;
        case 2:
            photoView.hidden = true;
            videoView.hidden = true;
            comparisonView.hidden = false;
            break;
        default:
            break;
    }
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

-(IBAction) takePhoto{
    imagePicker = [[[UIImagePickerController alloc] init] autorelease];
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePicker.mediaTypes =[UIImagePickerController availableMediaTypesForSourceType:imagePicker.sourceType];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = NO;
    [imagePicker takePicture];
    [self presentModalViewController:imagePicker animated:YES];
}

-(IBAction)choosePhotoA:(id)sender{
    currBtnIndex = 1;
    currBtnTapped = (UIButton*)sender;
    if(listOfRecords.count==0){
        proAlertView *alert = [[proAlertView alloc] initWithTitle:nil message:@"Sorry, no results found!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
        [alert show];
        [alert release];
    }else
        [self ShowPopover];
}

-(IBAction) toggleZoomTogether:(id)sender{
    zoomTogether = !zoomTogether;
    if (zoomTogether) {
        [lockBtn setBackgroundImage:[UIImage imageNamed:@"lock.png"] forState:UIControlStateNormal];
    }
    else{
        [lockBtn setBackgroundImage:[UIImage imageNamed:@"unlock.png"] forState:UIControlStateNormal];
    }
}

-(IBAction)choosePhotoB:(id)sender{
    currBtnIndex = 2;
    currBtnTapped = (UIButton*)sender;
    if(listOfRecords.count==0){
        proAlertView *alert = [[proAlertView alloc] initWithTitle:nil message:@"Sorry, no results found!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
        [alert show];
        [alert release];
    }else
        [self ShowPopover];
}

-(void) ShowPopover{
    CompareImagePopupVC* controller = [[CompareImagePopupVC alloc] initWithNibName:@"CompareImagePopupVC" bundle:nil];
    controller.listOfOptions = listOfRecords;
    controller.delegate = self;
    controller.dateDtls = self.dateDtls;
    controller.imageDtls = self.imageDtls;
    controller.doctorNamesArray = self.doctorNamesArray;
    popover = [[UIPopoverController alloc] initWithContentViewController:controller];
    [controller release];
    [popover setPopoverContentSize:CGSizeMake(275, 300)];
    CGRect frame;
    if(currBtnIndex==1){
        frame = CGRectMake(127, 441, 20, 20);
        [popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
    }
    else{
        frame = CGRectMake(827, 441, 20, 20);
        [popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
    }
}

-(void) optionSelected:(NSString*)cellValue{
    self.activityController = [ISActivityOverlayController presentActivityOverViewController:self withLabel:@"Downloading..."];
    if([[(PatMedRecords*)[listOfRecords objectAtIndex:[cellValue integerValue]] RecNatureId] integerValue]==currVisitRecNatureIndex){
        [self.service getNotesInvocation:self.userRoleId RecordId:[(PatMedRecords*)[listOfRecords objectAtIndex:[cellValue integerValue]] RecordId] delegate:self];
    }
    else{
        [self.service getLabReportInvocation:self.userRoleId RecordId:[(PatMedRecords*)[listOfRecords objectAtIndex:[cellValue integerValue]] RecordId] delegate:self];
    }
    [popover dismissPopoverAnimated:YES];
}

-(void) GetLabReportInvocationDidFinish:(GetLabReportInvocation *)invocation 
                         withLabReports:(NSArray *)LabReports 
                              withError:(NSError *)error{
    if(!error&&LabReports.count>0){
        UIImage* tempImage = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@/%@",[DataExchange getDomainUrl],[LabReports objectAtIndex:0]]]]];
        [currBtnTapped setTitle:@"" forState:UIControlStateNormal];
        [currBtnTapped setBackgroundImage:tempImage forState:UIControlStateNormal];
    }
    if (self.activityController) {
        [self.activityController dismissActivity];
        self.activityController = nil;
    }
}

-(void)GetCurrentVisitFileInvocationDidFinish:(GetCurrentVisitFileInvocation *)invocation 
                         withCurrentVisitFile:(id)file 
                                    withError:(NSError *)error{
    if(!error){
        [currBtnTapped setTitle:@"" forState:UIControlStateNormal];
        [currBtnTapped setBackgroundImage:(UIImage*)file forState:UIControlStateNormal];
    }
    if (self.activityController) {
        [self.activityController dismissActivity];
        self.activityController = nil;
    }
}

-(void)GetNotesInvocationDidFinish:(GetNotesInvocation *)invocation 
                withNotesDataArray:(NSArray *)notesArray 
                         withError:(NSError *)error{
    if(!error && notesArray.count>0){
        [currBtnTapped setTitle:@"" forState:UIControlStateNormal];
        [currBtnTapped setBackgroundImage:[notesArray objectAtIndex:0] forState:UIControlStateNormal];
    }
    if (self.activityController) {
        [self.activityController dismissActivity];
        self.activityController = nil;
    }
}

#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)info {
	[self didFinishWithCamera];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if([mediaType isEqualToString:@"public.image"]){
        currentImage = [info valueForKey:UIImagePickerControllerOriginalImage];
        [self PostUploadImage:UIImageJPEGRepresentation(currentImage,1.0)];
        postStylusView.hidden = false;
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

-(void)SuccessToLoadTable:(NSString*)response{
    self.currentImagePath = response;
    NSString* dataToPost = [NSString stringWithFormat:@"{\"Mrno\":%@,\"UserRoleID\":%@,\"filename\":%@}",self.mrNo,userRoleId,response];
    NSURL* myUrl = [[[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://%@PostDoctorCurrentVisit_file",[DataExchange getbaseUrl]]] autorelease];
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
    [request setURL:myUrl];
    [request setHTTPMethod:@"POST"];
    [request setAllHTTPHeaderFields:[[[NSDictionary alloc] initWithObjects:[[[NSArray alloc] initWithObjects:@"application/json",@"utf-8",[DataExchange getDomainUrl],[NSString stringWithFormat:@"%d",dataToPost.length], nil] autorelease] forKeys:[[[NSArray alloc] initWithObjects:@"Content-Type",@"charset",@"Host",@"Content-Length", nil]autorelease]]autorelease]];
    [request setHTTPBody:[NSData dataWithBytes:[dataToPost UTF8String] length:[dataToPost lengthOfBytesUsingEncoding:NSUTF8StringEncoding]]]; 
    postFileConnection=[[[NSURLConnection alloc] initWithRequest:request delegate:self] autorelease];
    if (!postFileConnection) {
        proAlertView *alert = [[proAlertView alloc] initWithTitle:@"No Internet Connection!" message:@"Please Try Again Later" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
        [alert show];
        [alert release];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    NSString *newStr = [[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    NSLog(@"---%@",newStr);
    if(connection==videoConnection || connection==stylusPicConnection){
        [self SuccessToLoadTable:newStr];
    }
    NSDictionary* temp = [newStr JSONValue];
    if(connection==postFileConnection)
        if([temp objectForKey:@"status"] && ([self.currentImagePath rangeOfString:@".png"].location!=NSNotFound || [self.currentImagePath rangeOfString:@".jpg"].location!=NSNotFound)){
            PatMedRecords* tempRec = [[PatMedRecords alloc] init];
            tempRec.EntryTypeId = [NSNumber numberWithInt:7];
            tempRec.Mrno = self.mrNo;
            tempRec.RecNatureId = [NSString stringWithFormat:@"%d",self.currVisitRecNatureIndex];
            tempRec.RecordId = [NSString stringWithFormat:@"%d",[(NSString*)[temp objectForKey:@"ID"] integerValue]];
            tempRec.UserRoleId = self.userRoleId;
            tempRec.ImagePath = self.currentImagePath;
            
            [doctorNamesArray insertObject:docName atIndex:0];
            [self.dateDtls insertObject:[NSDate date] atIndex:0];
            [self.listOfRecords insertObject:tempRec atIndex:0];
            if([[tempRec RecNatureId] integerValue]==currVisitRecNatureIndex)
                [self.imageDtls insertObject:@"current-visit.png" atIndex:0];
            else
                [self.imageDtls insertObject:@"laboratory.png" atIndex:0];
            
            [mParentController addRecord:tempRec];
        }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    if(connection==postFileConnection){
        postStylusView.hidden = TRUE;
    }
    if (self.activityController) {
        [self.activityController dismissActivity];
        self.activityController = Nil;
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	proAlertView *alert = [[proAlertView alloc] initWithTitle:@"Something Went Wrong" message:@"Please Try Again" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
    [alert setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
    [alert show];
	[alert release];
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
        if(totalBytesWritten==totalBytesExpectedToWrite){
            [stylusProgressLbl setText:@"Finishing"];
        }
    }
}

-(IBAction)cancelCurrVideoPost{
    stopVidPostAlertView= [[proAlertView alloc] initWithTitle:@"Cancel Post?" message:@"Some progress has been made. Proceed?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes",nil];
    [stopVidPostAlertView setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
    [stopVidPostAlertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex==1){
        if(alertView==deleteImageAlertView){
            currentImage = nil;
        }else if(alertView==deleteVideoAlertView){
            videoData = nil;
        }else if(alertView==closeAlertView){
            [self dismissModalViewControllerAnimated:YES];
        }else if(alertView==stopVidPostAlertView){
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
            }else if(![photoView isHidden]){
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

#pragma mark - View lifecycle

-(IBAction)closePopup{
    closeAlertView= [[proAlertView alloc] initWithTitle:@"Close Screen!" message:@"Proceed?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"YES",nil];
    [closeAlertView setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
    [closeAlertView show];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
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
