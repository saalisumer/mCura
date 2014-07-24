//
//  HelpView.m
//  mCura
//
//  Created by Aakash Chaudhary on 16/05/12.
//  Copyright (c) 2012 aakash272@gmail.com. All rights reserved.
//

#import "HelpView.h"
#import <QuartzCore/QuartzCore.h>
#define numVideos 5

@implementation HelpView

@synthesize player1,player2,player3,player4,player5;

-(id)init{
    if ((self = [super init])) {
        NSArray * nib = [[NSBundle mainBundle] loadNibNamed: @"HelpView" owner: self options: nil];
        // prevent memory leak
        [self release];
        self = [[nib objectAtIndex:0] retain];
    }
    childNavBar.layer.cornerRadius = 5.0;
    
    //NSString *url = [[NSBundle mainBundle] pathForResource:@"movie" ofType:@"mov"];	
    //self.player1 = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL fileURLWithPath:url]];
    NSMutableArray* titles = [[NSMutableArray alloc] initWithObjects:@"How to add prescription",@"How to make lab order",@"How to make notes",@"How to make referral",@"How to compare images", nil];
    for (int i=0; i<numVideos; i++) {
        UILabel* lbl = [[UILabel alloc] initWithFrame:CGRectMake(704*(i/2)+74, (i%2==0?9:308), 487, 38)];
        [lbl setText:[titles objectAtIndex:i]];
        lbl.backgroundColor = [UIColor clearColor];
        [mainScrollView addSubview:lbl];
        UIImageView* imgView = [[UIImageView alloc] initWithFrame:CGRectMake(704*(i/2)+74, (i%2==0?57:354), 557, 223)];
        switch (i) {
            case 0:
//                imgView.image = [self.player1 thumbnailImageAtTime:1 timeOption:MPMovieTimeOptionExact];
                imgView.image = [UIImage imageNamed:@"thumb.png"];
                break;
            case 1:
//                imgView.image = [self.player1 thumbnailImageAtTime:2 timeOption:MPMovieTimeOptionExact];
                imgView.image = [UIImage imageNamed:@"thumb.png"];
                break;
            case 2:
//                imgView.image = [self.player1 thumbnailImageAtTime:3 timeOption:MPMovieTimeOptionExact];
                imgView.image = [UIImage imageNamed:@"thumb.png"];
                break;
            case 3:
//                imgView.image = [self.player1 thumbnailImageAtTime:4 timeOption:MPMovieTimeOptionExact];
                imgView.image = [UIImage imageNamed:@"thumb.png"];
                break;
            case 4:
//                imgView.image = [self.player1 thumbnailImageAtTime:5 timeOption:MPMovieTimeOptionExact];
                imgView.image = [UIImage imageNamed:@"thumb.png"];
                break;
            default:
                break;
        }
        imgView.tag = 200+i;
        [mainScrollView addSubview:imgView];
        UIButton* overlayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [overlayBtn addTarget:self action:@selector(playBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [overlayBtn setFrame:CGRectMake(704*(i/2)+74, (i%2==0?57:354), 557, 223)];
        overlayBtn.tag = 100+i;
        [overlayBtn setImage:[UIImage imageNamed:@"play-overlay.png"] forState:UIControlStateNormal];
        [mainScrollView addSubview:overlayBtn];
        [lbl release];
    }
    [self.player1 stop];
    [mainScrollView setContentSize:CGSizeMake(704*(numVideos+1)/2, 611)];
    return self;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [pageControl setCurrentPage:mainScrollView.contentOffset.x/704];
}

- (void) playBtnClicked:(id)sender{
    return;
    NSInteger btnIndex = [(UIButton*)sender tag] - 100;
    NSString *url = [[NSBundle mainBundle] pathForResource:@"movie" ofType:@"mov"];
    switch (btnIndex) {
        case 0:
            self.player1 = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL fileURLWithPath:url]];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieFinishedCallback:) name:MPMoviePlayerPlaybackDidFinishNotification object:self.player1];
            self.player1.view.frame = [mainScrollView viewWithTag:100].frame;
            self.player1.fullscreen = NO;
            [mainScrollView addSubview:self.player1.view];
            [self.player1 play];
            break;
        case 1:
            self.player2 = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL fileURLWithPath:url]];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieFinishedCallback:) name:MPMoviePlayerPlaybackDidFinishNotification object:self.player2];
            self.player2.view.frame = [mainScrollView viewWithTag:101].frame;
            self.player2.fullscreen = NO;
            [mainScrollView addSubview:self.player2.view];
            [self.player2 play];
            break;
        case 2:
            self.player3 = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL fileURLWithPath:url]];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieFinishedCallback:) name:MPMoviePlayerPlaybackDidFinishNotification object:self.player3];
            self.player3.view.frame = [mainScrollView viewWithTag:102].frame;
            self.player3.fullscreen = NO;
            [mainScrollView addSubview:self.player3.view];
            [self.player3 play];
            break;
        case 3:
            self.player4 = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL fileURLWithPath:url]];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieFinishedCallback:) name:MPMoviePlayerPlaybackDidFinishNotification object:self.player4];
            self.player4.view.frame = [mainScrollView viewWithTag:103].frame;
            self.player4.fullscreen = NO;
            [mainScrollView addSubview:self.player4.view];
            [self.player4 play];
            break;
        case 4:
            self.player5 = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL fileURLWithPath:url]];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieFinishedCallback:) name:MPMoviePlayerPlaybackDidFinishNotification object:self.player5];
            self.player5.view.frame = [mainScrollView viewWithTag:104].frame;
            self.player5.fullscreen = NO;
            [mainScrollView addSubview:self.player5.view];
            [self.player5 play];
            break;
        default:
            break;
    }
}

- (void) movieFinishedCallback:(NSNotification*)notification{
    MPMoviePlayerController *player = notification.object;
    [player.view removeFromSuperview];
}

@end
