//
//  DeviceDeatils+Parse.m
//  3GMDoc

#import "DeviceDeatils+Parse.h"
#import "DeviceDeatils.h"
#import "JSON.h"

@implementation DeviceDeatils (Parse)

+(DeviceDeatils*) DeviceDeatilsFromDictionary:(NSDictionary*)DeviceDeatilsd{
	if (!DeviceDeatilsd) {
		return Nil;
	}
	
	DeviceDeatils *d = [[[DeviceDeatils alloc] init] autorelease];
    d.ActivationDate = [DeviceDeatilsd objectForKey:@"ActivationDate"];
	d.ActivationId	 = [DeviceDeatilsd objectForKey:@"ActivationId"];
	d.Make			 = [DeviceDeatilsd objectForKey:@"Make"];
	d.Os			 = [DeviceDeatilsd objectForKey:@"Os"];
	d.SerialNo		 = [DeviceDeatilsd objectForKey:@"SerialNo"];
	d.TabletId		 = [DeviceDeatilsd objectForKey:@"TabletId"];
	d.TabletOwnerType = [DeviceDeatilsd objectForKey:@"TabletOwnerType"];
	d.TabletOwnerTypeId = [DeviceDeatilsd objectForKey:@"TabletOwnerTypeId"];
	    
	return d;
}

+(NSArray*) DeviceDeatilsFromArray:(NSArray*) DeviceDeatilsA{
	if (!DeviceDeatilsA) {
		return Nil;
	}
	
	NSMutableArray *devices = [[[NSMutableArray alloc] init] autorelease];
	for (int i = 0; i < DeviceDeatilsA.count; i++) {
        DeviceDeatils *d = [DeviceDeatils DeviceDeatilsFromDictionary:[DeviceDeatilsA objectAtIndex:i]];
        if (d) {
            [devices addObject:d];
        }
    }
	
	return devices;	
}


@end

