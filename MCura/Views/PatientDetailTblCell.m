//
//  PatientDetailTblCell.m
//  3GMDoc
//
//  Created by sandeep agrawal on 20/01/12.
//  Copyright (c) 2012 student.san1986@gmail.com. All rights reserved.
//

#import "PatientDetailTblCell.h"
#import "CAVNSArrayTypeCategory.h"

@implementation PatientDetailTblCell

@synthesize lblName, lblType, lblExistsFrom;

+(PatientDetailTblCell*) createTextRowWithOwner:(NSObject*)owner{
	NSArray* wired = [[NSBundle mainBundle] loadNibNamed:@"PatientDetailTblCell" owner:owner options:nil];
	PatientDetailTblCell* cell = (PatientDetailTblCell*)[wired firstObjectWithClass:[PatientDetailTblCell class]];
	
	return cell;
}

- (void)dealloc {
    self.lblName = nil;
    self.lblType = nil;
    self.lblExistsFrom = nil;
    
    [super dealloc];
}



@end

