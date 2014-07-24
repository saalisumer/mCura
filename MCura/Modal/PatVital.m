//
//  PatVital.m
//  mCura
//
//  Created by Aakash Chaudhary on 02/04/12.
//  Copyright (c) 2012 aakash272@gmail.com. All rights reserved.
//

#import "PatVital.h"

@implementation PatVital

@synthesize Date_, Units, VitalName, VitalNatureId, PatReadingsId, PatVitalId, Mrno,Reading;

-(void)dealloc 
{
    self.Date_ = nil;
    self.Units = nil;
    self.VitalName = nil;
    self.VitalNatureId = nil;
    self.PatReadingsId = nil;
    self.PatVitalId = nil;
    self.Mrno = nil;
    self.Reading = nil;
	[super dealloc];
}

@end
