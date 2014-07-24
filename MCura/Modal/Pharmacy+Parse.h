//
//  Pharmacy+Parse.h
//  3GMDoc
//
//  Created by sandeep agrawal on 18/01/12.
//  Copyright (c) 2012 student.san1986@gmail.com. All rights reserved.
//

#import "Pharmacy.h"

@interface Pharmacy (Parse)

+(Pharmacy*) PharmacysFromDictionary:(NSDictionary*)Pharmacysd;
+(NSArray*) PharmacysFromArray:(NSArray*) PharmacysA;

@end
