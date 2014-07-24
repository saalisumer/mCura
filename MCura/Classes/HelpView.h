//
//  HelpView.h
//  mCura
//
//  Created by Aakash Chaudhary on 16/05/12.
//  Copyright (c) 2012 aakash272@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface HelpView : UIView<UIScrollViewDelegate>{
    IBOutlet UINavigationBar* childNavBar;
    IBOutlet UIScrollView* mainScrollView;
    IBOutlet UIPageControl* pageControl;
}

@property (nonatomic,retain) MPMoviePlayerController* player1;
@property (nonatomic,retain) MPMoviePlayerController* player2;
@property (nonatomic,retain) MPMoviePlayerController* player3;
@property (nonatomic,retain) MPMoviePlayerController* player4;
@property (nonatomic,retain) MPMoviePlayerController* player5;

- (void) movieFinishedCallback:(NSNotification*)notification;
- (void) playBtnClicked:(id)sender;

@end
