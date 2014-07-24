//
//  PriorityObject.m
//  mCura
//
//  Created by Aakash Chaudhary on 09/06/12.
//  Copyright (c) 2012 aakash272@gmail.com. All rights reserved.
//

#import "PriorityObject.h"

@implementation PriorityObject
@synthesize priorityId,priorityName,appDuration,appSlotId;

-(void)dealloc 
{
    self.priorityId = nil;
    self.priorityName = nil;
    self.appDuration = nil;
    self.appSlotId = nil;
    [super dealloc];
}

@end
