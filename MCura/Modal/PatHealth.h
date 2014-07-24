//
//  PatHealth.h
//  mCura
//
//  Created by Aakash Chaudhary on 02/04/12.
//  Copyright (c) 2012 aakash272@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Foundation/NSDictionary.h>
#import <Foundation/NSArray.h>

@interface PatHealth : NSObject {
	
}

@property(nonatomic, retain) NSNumber *HConId;
@property(nonatomic, retain) NSNumber *HConTypeId;
@property(nonatomic, retain) NSString *Existsfrom;
@property(nonatomic, retain) NSString *EnteredOn;
@property(nonatomic, retain) NSNumber *Mrno;
@property(nonatomic, retain) NSString *HConTypeProperty;
@property(nonatomic, retain) NSString *HCondition;

@end
