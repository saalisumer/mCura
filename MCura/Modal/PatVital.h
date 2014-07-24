//
//  PatVital.h
//  mCura
//
//  Created by Aakash Chaudhary on 02/04/12.
//  Copyright (c) 2012 aakash272@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Foundation/NSDictionary.h>
#import <Foundation/NSArray.h>

@interface PatVital : NSObject {
	
}

@property(nonatomic, retain) NSString *Date_;
@property(nonatomic, retain) NSString *Units;
@property(nonatomic, retain) NSString *VitalName;
@property(nonatomic, retain) NSNumber *VitalNatureId;
@property(nonatomic, retain) NSNumber *PatReadingsId;
@property(nonatomic, retain) NSNumber *PatVitalId;
@property(nonatomic, retain) NSNumber *Mrno;
@property(nonatomic, retain) NSNumber *Reading;

@end

