//
//  LabGroupTest.h
//  3GMDoc
//
//  Created by Aakash Chaudhary on 15/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LabGroupTest : NSObject

@property(nonatomic, retain) NSNumber *Cost;
@property(nonatomic, retain) NSNumber *LabGrpId;
@property(nonatomic, retain) NSString *LabGrpName;
@property(nonatomic, retain) NSNumber *SubTenantId;
@property(nonatomic, retain) NSNumber *TestInsId;
@property(nonatomic, retain) NSMutableArray *arrayOfTests;

@end
