//
//  Brand.h
//  3GMDoc
//
//  Created by sandeep agrawal on 18/01/12.
//  Copyright (c) 2012 student.san1986@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Foundation/NSDictionary.h>
#import <Foundation/NSArray.h>

@interface Brand : NSObject{
    
}
@property(nonatomic, retain) NSNumber *BrandId;
@property(nonatomic, retain) NSString *BrandName;
@property(nonatomic, retain) NSString *BrandComposition;
@property(nonatomic, retain) NSString *BrandDosage;
@property(nonatomic, retain) NSString *BrandManufacturer;

@property(nonatomic, retain) NSMutableArray* arrayPrices;
@property(nonatomic, retain) NSMutableArray* arrayGeneric;

@end
