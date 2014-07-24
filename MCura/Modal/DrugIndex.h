//
//  DrugIndex.h
//  mCura
//
//  Created by Aakash Chaudhary on 20/07/12.
//  Copyright (c) 2012 aakash272@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DrugIndex : NSObject

@property(nonatomic, retain) NSNumber *Crossreaction;
@property(nonatomic, retain) NSArray *DrugBrands;
@property(nonatomic, retain) NSString *Modeofaction;
@property(nonatomic, retain) NSNumber *Id;
@property(nonatomic, retain) NSString *Name;
@property(nonatomic, retain) NSArray *Safety;
@property(nonatomic, retain) NSString *Sideeffect;

@end
