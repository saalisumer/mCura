//
//  Patdemographics+Parse.h
//  3GMDoc

#import "Patdemographics.h"

@interface Patdemographics (Parse)

+(Patdemographics*) PatdemographicsFromDictionary:(NSDictionary*)Patdemographicsd;
+(NSArray*) PatdemographicsFromArray:(NSDictionary*) PatdemographicsA;

@end
