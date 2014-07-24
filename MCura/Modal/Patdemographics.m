//
//  Patdemographics.m
//  3GMDoc

#import "Patdemographics.h"

@implementation Patdemographics

@synthesize patDemoID, contactID, addressID, genderID, patDOB, patName;

-(void)dealloc 
{
    self.patDemoID = nil;
    self.contactID = nil;
    self.addressID = nil;
    self.genderID = nil;
    self.patDOB = nil;
    self.patName = nil;
	[super dealloc];
}

@end