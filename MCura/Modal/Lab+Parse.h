//
//  Lab+Parse.h
//  3GMDoc
//
//  Created by Aakash Chaudhary on 07/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Lab.h"

@interface Lab (Parse)

+(Lab*) LabsFromDictionary:(NSDictionary*)Labsd;
+(NSArray*) LabsFromArray:(NSArray*) LabsA;

@end
