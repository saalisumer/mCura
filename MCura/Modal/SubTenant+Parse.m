//
//  SubTenant+Parse.m
//  3GMDoc
//
//  Created by Aakash Chaudhary on 09/02/12.
//  Copyright (c) 2012 aakash272@gmail.com. All rights reserved.
//

#import "SubTenant+Parse.h"

@implementation SubTenant (Parse)

+(SubTenant*) subTenantsFromDictionary:(NSDictionary*)subTenantd{
	if (!subTenantd) {
		return Nil;
	}
	
	SubTenant *usr = [[[SubTenant alloc] init] autorelease];
    usr.SubTenantId   = [subTenantd objectForKey:@"SubTenantId"];        
	usr.SubTenantName = [subTenantd objectForKey:@"SubTenantName"];
    
    NSLog(@"SubTenantId--> %@",usr.SubTenantId);
	return usr;
}

+(NSArray*) subTenantsFromArray:(NSArray*) subTenantA{
	if (!subTenantA || [subTenantA isKindOfClass:[NSNull class]]) {
		return Nil;
	}
	
	NSMutableArray *subTenants = [[[NSMutableArray alloc] init] autorelease];
    for (int i = 0; i < subTenantA.count; i++) {
        SubTenant *sch = [SubTenant subTenantsFromDictionary:[subTenantA objectAtIndex:i]];
        if (sch) {
            [subTenants addObject:sch];
        }
    }    
	
	return subTenants;	
}

@end
