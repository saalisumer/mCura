//
//  DeviceDeatils.m
//  3GMDoc

#import "DeviceDeatils.h"

@implementation DeviceDeatils

@synthesize ActivationDate, ActivationId, Make, Os, SerialNo, TabletId, TabletOwnerType, TabletOwnerTypeId;


-(void)dealloc 
{
    self.ActivationDate = nil;
    self.ActivationId = nil;
    self.Make = nil;
    self.Os = nil;
    self.SerialNo = nil;
    self.TabletId = nil;
    self.TabletOwnerType = nil;
    self.TabletOwnerTypeId = nil;
	[super dealloc];
}

@end

