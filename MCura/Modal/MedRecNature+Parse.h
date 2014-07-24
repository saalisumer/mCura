//
//  MedRecNature+Parse.h
//  mCura
//
//  Created by Aakash Chaudhary on 27/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MedRecNature.h"

@interface MedRecNature (Parse)

+(MedRecNature*) MedRecNatureFromDictionary:(NSDictionary*)MedRecNatured;
+(NSArray*) MedRecNatureFromArray:(NSArray*) MedRecNatureA;

@end
