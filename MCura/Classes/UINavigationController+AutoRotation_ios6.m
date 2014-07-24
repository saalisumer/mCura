//
//  UINavigationController+AutoRotation_ios6.m
//  mCura
//
//  Created by Aakash Chaudhary on 03/11/12.
//  Copyright (c) 2012 aakash272@gmail.com. All rights reserved.
//

#import "UINavigationController+AutoRotation_ios6.h"

@implementation UINavigationController (AutoRotation_ios6)

#if IOS_NEWER_OR_EQUAL_TO_6
-(BOOL)shouldAutorotate
{
    return YES;
}

-(NSUInteger)supportedInterfaceOrientations
{
   // return UIInterfaceOrientationMaskLandscape;
    return UIInterfaceOrientationLandscapeRight;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationMaskLandscape;
}
#endif

@end