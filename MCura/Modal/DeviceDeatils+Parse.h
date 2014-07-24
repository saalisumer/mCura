//
//  DeviceDeatils+Parse.h
//  3GMDoc


#import "DeviceDeatils.h"


@interface DeviceDeatils (Parse)

+(DeviceDeatils*) DeviceDeatilsFromDictionary:(NSDictionary*)DeviceDeatilsd;
+(NSArray*) DeviceDeatilsFromArray:(NSArray*) DeviceDeatilsA;

@end