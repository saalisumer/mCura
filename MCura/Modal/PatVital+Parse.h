//
//  PatVital+Parse.h
//  mCura
//
//  Created by Aakash Chaudhary on 02/04/12.
//  Copyright (c) 2012 aakash272@gmail.com. All rights reserved.
//

#import "PatVital.h"

@interface PatVital (Parse)

+(PatVital*) PatVitalsFromDictionary:(NSDictionary*)PatVitalsd;
+(NSArray*) PatVitalsFromArray:(NSArray*) PatVitalsA;

@end