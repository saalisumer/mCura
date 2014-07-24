//
//  AppointmentTblCell.m
//  mCura
//
//  Created by Aakash Chaudhary on 02/04/12.
//  Copyright (c) 2012 aakash272@gmail.com. All rights reserved.
//

#import "AppointmentTblCell.h"
#import "CAVNSArrayTypeCategory.h"

@implementation AppointmentTblCell

@synthesize lblMobNo, lblName, lblMrno, lblAge, lblSex, imgView;

+(AppointmentTblCell*) createTextRowWithOwner:(NSObject*)owner{
	NSArray* wired = [[NSBundle mainBundle] loadNibNamed:@"AppointmentTblCell" owner:owner options:nil];
	AppointmentTblCell* cell = (AppointmentTblCell*)[wired firstObjectWithClass:[AppointmentTblCell class]];
	
	return cell;
}

- (void)dealloc {
    self.lblMobNo = nil;
    self.lblName = nil;
    self.lblMrno = nil;
    self.lblAge = nil;
    self.lblSex = Nil;
	self.imgView = nil;
    [super dealloc];
}

@end
