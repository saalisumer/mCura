//
//  Brand+Parse.h
//  3GMDoc
//
//  Created by sandeep agrawal on 18/01/12.
//  Copyright (c) 2012 student.san1986@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Brand.h"

@interface Brand (Parse)

+(Brand*) BrandsFromDictionary:(NSDictionary*)Brandsd;
+(NSArray*) BrandsFromArray:(NSArray*) BrandsA;

@end
