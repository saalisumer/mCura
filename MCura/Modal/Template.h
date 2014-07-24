//
//  Template.h
//  mCura
//
//  Created by Aakash Chaudhary on 24/03/12.
//  Copyright (c) 2012 aakash272@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Template : NSObject

@property(nonatomic, retain) NSNumber *TemplateId;
@property(nonatomic, retain) NSNumber *UserRoleId;
@property(nonatomic, retain) NSString *TemplateName;
@property(nonatomic, retain) NSString *ConnectionString;

@end
