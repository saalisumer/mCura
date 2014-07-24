//
//  PharmacyOrder+Parse.h
//  3GMDoc
//
//  Created by Aakash Chaudhary on 15/02/12.
//  Copyright (c) 2012 aakash272@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PharmacyOrder.h"

@interface PharmacyOrder (Parse)

+(PharmacyOrder*) PharmacyOrderFromDictionary:(NSDictionary*)PharmacyOrderD;
+(NSArray*) PharmacyOrderFromArray:(NSArray*) PharmacyOrderA;

+(PharmacyOrder*) PharmacyOrderTemplateFromDictionary:(NSDictionary*)PharmacyOrderD;
+(NSArray*) PharmacyOrderTemplateFromArray:(NSArray*) PharmacyOrderA;

@end
