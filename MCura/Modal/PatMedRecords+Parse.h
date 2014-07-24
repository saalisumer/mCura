//
//  PatMedRecords+Parse.h
//  3GMDoc
//
//  Created by Aakash Chaudhary on 05/02/12.
//  Copyright (c) 2012 aakash272@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PatMedRecords.h"

@interface PatMedRecords (Parse)

+(NSArray*) PatMedRecordsFromArray:(NSArray*) PatMedRecordsA;
+(PatMedRecords*) PatMedRecordsFromDictionary:(NSDictionary*)PatMedRecordsD;

@end
