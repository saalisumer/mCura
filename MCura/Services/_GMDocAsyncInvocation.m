//
//  3GMDocAsyncInvocation.m


#import "_GMDocAsyncInvocation.h"


@implementation _GMDocAsyncInvocation

-(id)init {
	self = [super init];
	if (self) {
		self.clientVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleVersionKey];
		self.clientVersionHeaderName = @"ProductStore-Client-Version";
	}
	return self;
}

@end