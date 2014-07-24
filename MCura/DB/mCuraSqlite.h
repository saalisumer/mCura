//
//  mCuraSqlite.h
//  mCura
//
//  Created by Kanav Gupta on 7/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Generic.h"
#import "Brand.h"

@interface mCuraSqlite : NSObject{
    
}

+(BOOL)openDatabase:(NSString*)dbPath;
+(void)copyDatabaseIfNeeded;
+(NSString*)getDBPath;
+(NSArray*)returnAllValidGenericRecords:(NSString*)searchString;
+(NSArray*)returnAllValidBrandRecords:(NSString*)searchString;
+(NSArray*)returnAllBrandRecords:(NSString*)searchString;
+(NSArray*)returnSelectedGenericID:(NSString*)Genericname;
+(void)InsertANewGenericRecord:(Generic*)genericRecord;
+(void)InsertANewBrandRecord:(Brand*)brandRecord ForGenericId:(NSInteger)genericId;
+(void)DeleteAllGenerics;
+(void)DeleteAllBrands;
+(BOOL)doBrandsExist;
+(BOOL)doGenericsExist;

@end
