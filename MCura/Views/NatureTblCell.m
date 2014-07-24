//
//  NatureTblCell.m
//  3GMDoc
//
//  Created by sandeep agrawal on 14/01/12.
//  Copyright (c) 2012 student.san1986@gmail.com. All rights reserved.
//

#import "NatureTblCell.h"
#import "CAVNSArrayTypeCategory.h"

@implementation NatureTblCell

@synthesize lblAppTime, lblName, imgView;

+(NatureTblCell*) createTextRowWithOwner:(NSObject*)owner{
	NSArray* wired = [[NSBundle mainBundle] loadNibNamed:@"NatureTblCell" owner:owner options:nil];
	NatureTblCell* cell = (NatureTblCell*)[wired firstObjectWithClass:[NatureTblCell class]];
	
	return cell;
}

- (void)dealloc {
    self.lblAppTime = nil;
    self.lblName = nil;
    self.imgView = nil;
    [super dealloc];
}



@end
