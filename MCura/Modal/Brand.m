//
//  Brand.m
//  3GMDoc
//
//  Created by sandeep agrawal on 18/01/12.
//  Copyright (c) 2012 student.san1986@gmail.com. All rights reserved.
//

#import "Brand.h"

@implementation Brand
@synthesize BrandId,BrandName,arrayPrices,BrandDosage,BrandComposition,BrandManufacturer,arrayGeneric;

-(void)dealloc 
{
    self.BrandId = nil;
    self.BrandName = nil;
  
    self.arrayPrices = nil;
    self.arrayGeneric=nil;
	[super dealloc];
}
@end
