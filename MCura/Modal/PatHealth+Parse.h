//
//  PatHealth+Parse.h
//  mCura
//
//  Created by Aakash Chaudhary on 02/04/12.
//  Copyright (c) 2012 aakash272@gmail.com. All rights reserved.
//

#import "PatHealth.h"

@interface PatHealth (Parse)

+(PatHealth*) PatHealthsFromDictionary:(NSDictionary*)PatHealthsd;
+(NSArray*) PatHealthsFromArray:(NSArray*) PatHealthsA;

@end