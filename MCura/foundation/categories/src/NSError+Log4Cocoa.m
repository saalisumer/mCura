//
//  NSError+Log4Cocoa.m

#import "NSError+Log4Cocoa.h"
#import <CoreData/CoreData.h>

@implementation NSError (Log4Cocoa)
-(void)log4Error {
	/*NSArray* detailedErrors = [[self userInfo] objectForKey:NSDetailedErrorsKey];
	if(detailedErrors != nil && [detailedErrors count] > 0) {
		for(NSError* detailedError in detailedErrors) {
			[detailedError log4Error];
		}
	} else {
		for (id key in [[self userInfo] allKeys]) {
			id value = [[self userInfo] objectForKey:key];
			//NSString* desc = [value description];
			NSLog(@" %@ => %@", key, value,nil);
			
		}
	}*/
}
@end
