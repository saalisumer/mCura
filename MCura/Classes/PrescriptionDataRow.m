//
//  PrescriptionDataRow.m
//  mCura
//
//  Created by Aakash Chaudhary on 21/10/12.
//  Copyright (c) 2012 aakash272@gmail.com. All rights reserved.
//

#import "PrescriptionDataRow.h"
#import <QuartzCore/QuartzCore.h>

@implementation PrescriptionDataRow

@synthesize genericStr,brandStr,instructionStr,dosageStr,dosageFrmStr,followUpStr;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    
    return self;
}

-(void)reloadView
{
    [lblBrand setBackgroundColor:[UIColor whiteColor]];
    [lblDosage setBackgroundColor:[UIColor whiteColor]];
    [lblDosageForm setBackgroundColor:[UIColor whiteColor]];
    [lblGeneric setBackgroundColor:[UIColor whiteColor]];
    [lblFollowUp setBackgroundColor:[UIColor whiteColor]];
    [lblInstruction setBackgroundColor:[UIColor whiteColor]];
    lblBrand.text = brandStr;
    lblDosage.text = dosageStr;
    lblDosageForm.text = dosageFrmStr;
    lblFollowUp.text = followUpStr;
    lblGeneric.text = genericStr;
    lblInstruction.text = instructionStr;
}

-(UIImage*)imageForView
{
    self.layer.borderWidth = 2;
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    UIGraphicsBeginImageContextWithOptions(self.frame.size,YES,0.0f);
    CGContextRef contextT = UIGraphicsGetCurrentContext();
    [self.layer renderInContext:contextT];
    UIImage *viewSnapshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return viewSnapshot;
}

@end
