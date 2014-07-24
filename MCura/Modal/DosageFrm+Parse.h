//
//  DosageFrm+Parse.h
//  3GMDoc
//
//  Created by sandeep agrawal on 18/01/12.
//  Copyright (c) 2012 student.san1986@gmail.com. All rights reserved.
//

#import "DosageFrm.h"

@interface DosageFrm (Parse)

+(DosageFrm*) DosageFrmsFromDictionary:(NSDictionary*)DosageFrmsd;
+(NSArray*) DosageFrmsFromArray:(NSArray*) DosageFrmsA;

@end
