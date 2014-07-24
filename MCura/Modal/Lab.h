//
//  Lab.h
//  3GMDoc
//
//  Created by Aakash Chaudhary on 07/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Foundation/NSDictionary.h>
#import <Foundation/NSArray.h>

@interface Lab : NSObject

@property(nonatomic, retain) NSNumber *SubTenantId;
@property(nonatomic, retain) NSString *SubTenantName;
@property(nonatomic, assign) NSInteger PriorityIndex;

@end
