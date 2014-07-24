//
//  PriceObject.h
//  mCura
//
//  Created by Aakash Chaudhary on 21/07/12.
//  Copyright (c) 2012 aakash272@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PriceObject : NSObject

@property(nonatomic, retain) NSString *DosageForm;
@property(nonatomic, retain) NSString *PackSize;
@property(nonatomic, retain) NSString *RetailPrice;
@property(nonatomic, retain) NSString *Strength;

@property(nonatomic, retain) NSNumber *PGenericId;
@property(nonatomic, retain) NSString *PGenericName;

@end
