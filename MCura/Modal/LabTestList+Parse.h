//
//  LabTestList+Parse.h
//  3GMDoc
//
//  Created by Aakash Chaudhary on 15/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LabTestList.h"

@interface LabTestList (Parse)

+(LabTestList*) LabTestListFromDictionary:(NSDictionary*)LabTestListD;
+(NSArray*) LabTestListFromArray:(NSArray*) LabTestListA;

@end
