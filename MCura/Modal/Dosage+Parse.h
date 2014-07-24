//
//  Dosage+Parse.h
//  3GMDoc
//
//  Created by sandeep agrawal on 17/01/12.
//  Copyright (c) 2012 student.san1986@gmail.com. All rights reserved.
//

#import "Dosage.h"

@interface Dosage (Parse)

+(Dosage*) DosagesFromDictionary:(NSDictionary*)Dosagesd;
+(NSArray*) DosagesFromArray:(NSArray*) DosagesA;

@end
