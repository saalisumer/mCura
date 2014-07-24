//
//  Generic+Parse.h
//  3GMDoc
//
//  Created by sandeep agrawal on 18/01/12.
//  Copyright (c) 2012 student.san1986@gmail.com. All rights reserved.
//

#import "Generic.h"

@interface Generic (Parse)

+(Generic*) GenericsFromDictionary:(NSDictionary*)Genericsd;
+(NSArray*) PGenericsFromArray:(NSArray*) GenericsA;

@end
