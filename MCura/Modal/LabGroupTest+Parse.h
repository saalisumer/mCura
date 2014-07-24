//
//  LabGroupTest+Parse.h
//  3GMDoc
//
//  Created by Aakash Chaudhary on 15/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LabGroupTest.h"

@interface LabGroupTest (Parse)

+(LabGroupTest*) LabGroupTestFromDictionary:(NSDictionary*)LabGroupTestD;
+(NSArray*) LabGroupTestFromArray:(NSArray*) LabGroupTestA;

@end
