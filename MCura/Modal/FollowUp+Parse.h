//
//  FollowUp+Parse.h
//  3GMDoc
//
//  Created by sandeep agrawal on 18/01/12.
//  Copyright (c) 2012 student.san1986@gmail.com. All rights reserved.
//

#import "FollowUp.h"

@interface FollowUp (Parse)

+(FollowUp*) FollowUpsFromDictionary:(NSDictionary*)FollowUpsd;
+(NSArray*) FollowUpsFromArray:(NSArray*) FollowUpsA;

@end
