//
//  Nature+Parse.h
//  3GMDoc

#import "Nature.h"

@interface Nature (Parse)

+(Nature*) NaturesFromDictionary:(NSDictionary*)Naturesd;
+(NSArray*) NaturesFromArray:(NSArray*) NaturesA;

@end
