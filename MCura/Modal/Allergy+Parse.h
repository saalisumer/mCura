//
//  Allergy+Parse.h
//  3GMDoc
//
//  Created by sandeep agrawal on 17/01/12.
//  Copyright (c) 2012 student.san1986@gmail.com. All rights reserved.
//

#import "Allergy.h"

@interface Allergy (Parse)

+(Allergy*) AllergysFromDictionary:(NSDictionary*)Allergysd;
+(NSArray*) AllergysFromArray:(NSArray*) AllergysA;

+(Allergy*) AllergyTypesFromDictionary:(NSDictionary*)Allergysd;
+(NSArray*) AllergyTypesFromArray:(NSArray*) AllergysA;

@end
