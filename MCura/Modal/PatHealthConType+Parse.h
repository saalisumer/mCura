//
//  PatHealthConType+Parse.h
//  mCura
//
//  Created by Aakash Chaudhary on 24/04/12.
//  Copyright (c) 2012 aakash272@gmail.com. All rights reserved.
//

#import "PatHealthConType.h"

@interface PatHealthConType (Parse)

+(PatHealthConType*) PatHealthConTypesFromDictionary:(NSDictionary*)PatHealthsd;
+(NSArray*) PatHealthsFromArray:(NSArray*) PatHealthsA;

@end
