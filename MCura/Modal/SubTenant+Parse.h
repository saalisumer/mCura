//
//  SubTenant+Parse.h
//  3GMDoc
//
//  Created by Aakash Chaudhary on 09/02/12.
//  Copyright (c) 2012 aakash272@gmail.com. All rights reserved.
//

#import "SubTenant.h"

@interface SubTenant (Parse)

+(SubTenant*) subTenantsFromDictionary:(NSDictionary*)subTenantd;
+(NSArray*) subTenantsFromArray:(NSArray*) subTenantA;

@end
