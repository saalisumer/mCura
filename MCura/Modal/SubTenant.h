//
//  SubTenant.h
//  3GMDoc
//
//  Created by Aakash Chaudhary on 09/02/12.
//  Copyright (c) 2012 aakash272@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SubTenant : NSObject

@property(nonatomic, assign) NSNumber *SubTenantId;
@property(nonatomic, retain) NSString *SubTenantName;
@property(nonatomic, assign) NSInteger PriorityIndex;
@property(nonatomic, assign) NSInteger SubTenantIdInteger;

@end
