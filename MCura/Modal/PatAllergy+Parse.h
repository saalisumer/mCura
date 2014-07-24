//
//  PatAllergy+Parse.h
//  mCura
//
//  Created by Aakash Chaudhary on 02/04/12.
//  Copyright (c) 2012 aakash272@gmail.com. All rights reserved.
//

#import "PatAllergy.h"

@interface PatAllergy (Parse)

+(PatAllergy*) PatAllergysFromDictionary:(NSDictionary*)PatAllergysd;
+(NSArray*) PatAllergysFromArray:(NSArray*) PatAllergysA;

@end