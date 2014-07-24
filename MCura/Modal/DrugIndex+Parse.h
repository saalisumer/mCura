//
//  DrugIndex+Parse.h
//  mCura
//
//  Created by Aakash Chaudhary on 20/07/12.
//  Copyright (c) 2012 aakash272@gmail.com. All rights reserved.
//

#import "DrugIndex.h"

@interface DrugIndex (Parse)

+(DrugIndex*) DrugIndicesFromDictionary:(NSDictionary*)DrugIndicesD;
+(NSArray*) DrugIndicesFromArray:(NSArray*) DrugIndicesA;

@end
