//
//  Nature+Parse.m
//  3GMDoc

#import "Nature+Parse.h"
#import "JSON.h"

@implementation Nature (Parse)

+(Nature*) NaturesFromDictionary:(NSDictionary*)Naturesd{
	if (!Naturesd) {
		return Nil;
	}
	
	Nature *app = [[[Nature alloc] init] autorelease];
    
    app.AppNatureIdProperty = [Naturesd objectForKey:@"AppNatureIdProperty"];
    app.AppNature = [Naturesd objectForKey:@"AppNature"];
    
	return app;
    
}

+(NSArray*) NaturesFromArray:(NSArray*) NaturesA{
	if (!NaturesA || [NaturesA isKindOfClass:[NSNull class]]) {
		return Nil;
	}
	
	NSMutableArray *appointments = [[[NSMutableArray alloc] init] autorelease];
    for (int i = 0; i < NaturesA.count; i++) {
        Nature *sch = [Nature NaturesFromDictionary:[NaturesA objectAtIndex:i]];
        if (sch) {
            [appointments addObject:sch];
        }
    }
    
	return appointments;	
}

@end

