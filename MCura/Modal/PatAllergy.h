//
//  PatAllergy.h
//  mCura
//
//  Created by Aakash Chaudhary on 02/04/12.
//  Copyright (c) 2012 aakash272@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Foundation/NSDictionary.h>
#import <Foundation/NSArray.h>

@interface PatAllergy : NSObject {
	
}

@property(nonatomic, retain) NSNumber *AllergyTypeId;
@property(nonatomic, retain) NSString *AllergyTypeProperty;
@property(nonatomic, retain) NSNumber *AllergyId;
@property(nonatomic, retain) NSString *AllergyName;
@property(nonatomic, retain) NSNumber *CurrentStatusId;
@property(nonatomic, retain) NSString *Existsfrom;
@property(nonatomic, retain) NSNumber *Mrno;

@end