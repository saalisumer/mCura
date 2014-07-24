//
//  PriceObject.m
//  mCura
//
//  Created by Aakash Chaudhary on 21/07/12.
//  Copyright (c) 2012 aakash272@gmail.com. All rights reserved.
//

#import "PriceObject.h"

@implementation PriceObject

@synthesize DosageForm, PackSize, RetailPrice, Strength,PGenericId,PGenericName;

-(void)dealloc 
{
    self.DosageForm = nil;
    self.PackSize = nil;
    self.Strength = nil;
    self.RetailPrice = nil;
    self.PGenericId = nil;
    self.PGenericName=nil;
	[super dealloc];
}

@end
