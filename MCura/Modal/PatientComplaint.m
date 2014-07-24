//
//  PatientComplaint.m
//  3GMDoc
//
//  Created by Aakash Chaudhary on 05/02/12.
//  Copyright (c) 2012 aakash272@gmail.com. All rights reserved.
//

#import "PatientComplaint.h"

@implementation PatientComplaint
@synthesize associatedSymptoms,cheifComp,complaintId,duration;
@synthesize episodesInPast,onset,otherSymptoms,progression,regression,severityId;

-(void)dealloc 
{
    self.associatedSymptoms=nil;
    self.cheifComp=nil;
    self.complaintId=nil;
    self.duration=nil;
    self.episodesInPast=nil;
    self.onset=nil;
    self.otherSymptoms=nil;
    self.progression=nil;
    self.regression=nil;
    self.severityId = nil;
	[super dealloc];
}

@end
