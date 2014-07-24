//
//  DrugIndex.m
//  mCura
//
//  Created by Aakash Chaudhary on 20/07/12.
//  Copyright (c) 2012 aakash272@gmail.com. All rights reserved.
//

#import "DrugIndex.h"

@implementation DrugIndex

@synthesize Crossreaction,Id,DrugBrands,Modeofaction,Safety,Sideeffect,Name;

-(void) dealloc{
    self.Crossreaction = nil;
    self.Id = nil;
    self.DrugBrands = nil;
    self.Modeofaction = nil;
    self.Safety = nil;
    self.Sideeffect = nil;
    self.Name = nil;
    [super dealloc];
}

@end
