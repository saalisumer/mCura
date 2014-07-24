//
//  Response+Parse.h
//  3GMDoc

#import "Response.h"


@interface Response (Parse)

+(Response*) responsesFromDictionary:(NSDictionary*)responsesd;
+(NSArray*) responsesFromArray:(NSArray*) responsesA;

@end
