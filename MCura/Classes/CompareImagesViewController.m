//
//  CompareImagesViewController.m
//  mCura
//
//  Created by Aakash Chaudhary on 30/03/12.
//  Copyright (c) 2012 aakash272@gmail.com. All rights reserved.
//

#import "CompareImagesViewController.h"

@implementation CompareImagesViewController
@synthesize firstImage,secondImage;

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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch1 = [[touches allObjects] objectAtIndex:0];
    UITouch *touch2;
    int count = [[touches allObjects] count];
    if(count==2){
        touch2 = [[touches allObjects] objectAtIndex:1];
        if([self arePoints:[touch1 locationInView:firstImageView] And:[touch2 locationInView:firstImageView] InsideViewFrame:firstImageView.frame]){
            initialDist1 = [self distanceBetweenTwoPoints:[touch1 locationInView:firstImageView] toPoint:[touch2 locationInView:firstImageView]];
            initialFrame1 = firstImageView.frame;
        }
        else if([self arePoints:[touch1 locationInView:secondImageView] And:[touch2 locationInView:secondImageView] InsideViewFrame:secondImageView.frame]){
            initialDist2 = [self distanceBetweenTwoPoints:[touch1 locationInView:secondImageView] toPoint:[touch2 locationInView:secondImageView]];
            initialFrame2 = secondImageView.frame;
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch1 = [[touches allObjects] objectAtIndex:0];
    UITouch *touch2;
    int count = [[touches allObjects] count];
	if(count==2){
        touch2 = [[touches allObjects] objectAtIndex:1];
        if([self arePoints:[touch1 locationInView:firstImageView] And:[touch2 locationInView:firstImageView] InsideViewFrame:firstImageView.frame]){
            CGFloat current = [self distanceBetweenTwoPoints:[touch1 locationInView:firstImageView] toPoint:[touch2 locationInView:firstImageView]];
            currentZoom1 = current/initialDist1;
            CGRect frame = firstImageView.frame;
            frame.size.height = initialFrame1.size.height*currentZoom1;
            frame.size.width = initialFrame1.size.width*currentZoom1;
            frame.origin.x = initialFrame1.origin.x - (frame.size.width - initialFrame1.size.width)/2;
            frame.origin.y = initialFrame1.origin.y - (frame.size.height - initialFrame1.size.height)/2;
            firstImageView.frame = frame;
        }
        else if([self arePoints:[touch1 locationInView:secondImageView] And:[touch2 locationInView:secondImageView] InsideViewFrame:secondImageView.frame]){
            CGFloat current = [self distanceBetweenTwoPoints:[touch1 locationInView:secondImageView] toPoint:[touch2 locationInView:secondImageView]];
            currentZoom1 = current/initialDist1;
            CGRect frame = secondImageView.frame;
            frame.size.height = initialFrame2.size.height*currentZoom2;
            frame.size.width = initialFrame2.size.width*currentZoom2;
            frame.origin.x = initialFrame2.origin.x - (frame.size.width - initialFrame2.size.width)/2;
            frame.origin.y = initialFrame2.origin.y - (frame.size.height - initialFrame2.size.height)/2;
            firstImageView.frame = frame;
        }
    }
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    if(scrollView==firstScrollView){
        return firstImageView;
    }
    else{
        return secondImageView;
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

-(IBAction) toggleZoomTogether:(id)sender{
    zoomTogether = !zoomTogether;
    if (zoomTogether) {
        [lockBtn setBackgroundImage:[UIImage imageNamed:@"lock.png"] forState:UIControlStateNormal];
    }
    else{
        [lockBtn setBackgroundImage:[UIImage imageNamed:@"unlock.png"] forState:UIControlStateNormal];
    }
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    zoomTogether = false;
    firstImageView.image = firstImage;
    secondImageView.image = secondImage;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex==1 && alertView==closeAlertView){
        firstImage = nil;
        secondImage = nil;
        [self dismissModalViewControllerAnimated:YES];
    }
}

-(IBAction)closePopup{
    closeAlertView= [[proAlertView alloc] initWithTitle:@"Close Screen!" message:@"Proceed?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"YES",nil];
    [closeAlertView setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
    [closeAlertView show];
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
