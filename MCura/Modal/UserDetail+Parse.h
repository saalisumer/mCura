//
//  UserDetail+Parse.h
//  3GMDoc

#import "UserDetail.h"


@interface UserDetail (Parse)

+(UserDetail*) userDetailsFromDictionary:(NSDictionary*)userDetailsd;
+(NSArray*) userDetailsFromArray:(NSArray*) userDetailsA;

@end
