//
//  Brand+Parse.m
//  3GMDoc
//
//  Created by sandeep agrawal on 18/01/12.
//  Copyright (c) 2012 student.san1986@gmail.com. All rights reserved.
//

#import "Brand+Parse.h"
#import "JSON.h"
#import "PriceObject.h"

@implementation Brand (Parse)

+(Brand*) BrandsFromDictionary:(NSDictionary*)Brandsd{
	if (!Brandsd) {
		return Nil;
	}
	
	Brand *app = [[[Brand alloc] init] autorelease];
    app.BrandId = [Brandsd objectForKey:@"Id"];
    app.BrandName = [Brandsd objectForKey:@"Name"];
    app.BrandComposition = [Brandsd objectForKey:@"Composition"];
    app.BrandDosage = [Brandsd objectForKey:@"Dosage"];
    app.BrandManufacturer = [Brandsd objectForKey:@"CompanyName"];
    NSArray* temp = [Brandsd objectForKey:@"Pricing"];
    {
    NSMutableArray* pricingArray = [[NSMutableArray alloc] init];
    for (int i=0; i<temp.count; i++) {
        NSDictionary* tempD = [temp objectAtIndex:i];
        PriceObject* priceObj = [[PriceObject alloc] init];
        priceObj.DosageForm = [tempD objectForKey:@"DosageForm"];
        priceObj.PackSize = [tempD objectForKey:@"PackSize"];
        priceObj.Strength = [tempD objectForKey:@"Strength"];
        priceObj.RetailPrice = [tempD objectForKey:@"RetailPrice"];
        [pricingArray addObject:priceObj];
    }
    app.arrayPrices = pricingArray;
    }
    
    NSArray *temp1 = [Brandsd objectForKey:@"formulation"];
    {
        NSMutableArray* GenericArray = [[NSMutableArray alloc] init];
        for (int i=0; i<temp1.count; i++) {
            NSDictionary* tempD = [temp1 objectAtIndex:i];
            PriceObject* priceObj = [[PriceObject alloc] init];
            priceObj.PGenericId = [tempD objectForKey:@"Id"];
            priceObj.PGenericName = [tempD objectForKey:@"Name"];
            [GenericArray addObject:priceObj];
            
        }
     
        app.arrayGeneric = GenericArray;
    }
	return app;
    
}

+(NSArray*) BrandsFromArray:(NSArray*) BrandsA{
	if (!BrandsA || [BrandsA isKindOfClass:[NSNull class]]) {
		return Nil;
	}
	if ([BrandsA isKindOfClass:[NSDictionary class]]) {
        NSMutableArray *brands = [[[NSMutableArray alloc] init] autorelease];
        Brand *sch = [Brand BrandsFromDictionary: (NSDictionary *)BrandsA];
        if (sch) {
            [brands addObject:sch];
        }
        return brands;
    }

    else{
	NSMutableArray *brands = [[[NSMutableArray alloc] init] autorelease];
    for (int i = 0; i < BrandsA.count; i++) {
        Brand *sch = [Brand BrandsFromDictionary:[BrandsA objectAtIndex:i]];
        if (sch) {
            [brands addObject:sch];
        }
    }
	
	return brands;
    }
}

@end
