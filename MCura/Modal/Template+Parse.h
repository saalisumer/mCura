//
//  Template+Parse.h
//  mCura
//
//  Created by Aakash Chaudhary on 24/03/12.
//  Copyright (c) 2012 aakash272@gmail.com. All rights reserved.
//

#import "Template.h"

@interface Template (Parse)

+(Template*) TemplatesFromDictionary:(NSDictionary*)Templatesd;
+(NSArray*) TemplatesFromArray:(NSArray*) TemplatesA;

@end
