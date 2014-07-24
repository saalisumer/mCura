//
//  LabPackage+Parse.h
//  3GMDoc
//
//  Created by Aakash Chaudhary on 15/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LabPackage.h"

@interface LabPackage (Parse)

+(LabPackage*) LabPackagesFromDictionary:(NSDictionary*)LabPackagesD;
+(NSArray*) LabPackagesFromArray:(NSArray*) LabPackagesA;

@end
