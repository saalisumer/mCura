//
//  Severity+Parse.h
//  3GMDoc
//
//  Created by Aakash Chaudhary on 07/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Severity.h"

@interface Severity (Parse)

+(Severity*) SeverityFromDictionary:(NSDictionary*)Severityd;
+(NSArray*) SeverityFromArray:(NSArray*) SeverityA;

@end
