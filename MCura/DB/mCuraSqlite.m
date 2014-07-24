//
//  mCuraSqlite.m
//  mCura
//
//  Created by Kanav Gupta on 7/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "mCuraSqlite.h"
#import "PriceObject.h"
#import <sqlite3.h>

static sqlite3 *database = nil;
static sqlite3_stmt *addStmtGenericNewAudit=nil;
sqlite3_stmt *addStmtBrandNewAudit=nil;
@implementation mCuraSqlite


+ (NSString *)getDBPath {
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
	NSString *documentsDir = [paths objectAtIndex:0];
	return [documentsDir stringByAppendingPathComponent:DATABASE_NAME];
}

+(BOOL)openDatabase:(NSString*)dbPath{
	BOOL openT=FALSE;
	if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) {
		openT=TRUE;
	}
    else
        sqlite3_close(database);
	return openT;
}

+ (void) copyDatabaseIfNeeded {
	//Using NSFileManager we can perform many file system operations.
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSError *error;
	NSString *dbPath = [self getDBPath];
	NSLog(@"dbPath=%@",dbPath);
	
	BOOL success = [fileManager fileExistsAtPath:dbPath]; 
	
	if(!success) {
		NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:DATABASE_NAME];
		NSLog(@"defaultDBPath=%@",defaultDBPath);
		success = [fileManager copyItemAtPath:defaultDBPath toPath:dbPath error:&error];
		
		if (!success) 
			NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
	}	
}


+(NSArray*)returnAllValidGenericRecords:(NSString*)searchString{
    sqlite3_stmt *SimplinicTableActivityGetStmt;
    
	//const char *sqlSerialQuery = "select * from GenericsTable";  //VINAY
      const char *sqlSerialQuery = "select * from tbl_drugs";
	
	if(sqlite3_prepare_v2(database, sqlSerialQuery, -1, &SimplinicTableActivityGetStmt, NULL)!=SQLITE_OK){
		NSAssert1(0,@"Error while updating From sqlLevelQues5.'%s'",sqlite3_errmsg(database));
	}
    NSMutableArray* temp = [[[NSMutableArray alloc] init]autorelease];
    while(sqlite3_step(SimplinicTableActivityGetStmt)==SQLITE_ROW){
        Generic *record=[[[Generic alloc] init]autorelease];
       // record.Generic=[NSString stringWithUTF8String:(char *)sqlite3_column_text(SimplinicTableActivityGetStmt, 2)]; //VINAY
       // NSNumber *genericid=[NSNumber numberWithInt:sqlite3_column_int(SimplinicTableActivityGetStmt, 1)]; //VINAY
        
        record.Generic=[NSString stringWithUTF8String:(char *)sqlite3_column_text(SimplinicTableActivityGetStmt,1)];
        NSNumber *genericid=[NSNumber numberWithInt:sqlite3_column_int(SimplinicTableActivityGetStmt,0)];
        
        record.GenericId = [NSNumber numberWithInt:[genericid integerValue]];
        while ([[record.Generic substringToIndex:1] isEqualToString:@" "]) {
            record.Generic = [NSString stringWithFormat:@"%@",[record.Generic substringToIndex:1]];
        }
        if(searchString==Nil || searchString.length==0)
            [temp addObject:record];
        else if(searchString.length > record.Generic.length)
            continue;
        else if([[record.Generic substringToIndex:searchString.length] compare:searchString options:NSCaseInsensitiveSearch]==0)
            [temp addObject:record];
    }
    return temp;
}

+(NSArray*)returnSelectedGenericID:(NSString*)Genericname{
   sqlite3_stmt *SimplinicTableActivityGetStmt;
    
       const char *sqlSerialQuery ="select * from tbl_drugs where drug_name=?";
    if(sqlite3_prepare_v2(database, sqlSerialQuery, -1, &SimplinicTableActivityGetStmt, NULL)!=SQLITE_OK){
		NSAssert1(0,@"Error while updating From sqlLevelQues5.'%s'",sqlite3_errmsg(database));
	}
    sqlite3_bind_text(SimplinicTableActivityGetStmt, 1, [Genericname UTF8String], -1, SQLITE_TRANSIENT);
    NSMutableArray* temp = [[[NSMutableArray alloc] init]autorelease];
      while(sqlite3_step(SimplinicTableActivityGetStmt)==SQLITE_ROW){
          Generic *record=[[[Generic alloc] init]autorelease];

        // record.Generic=[NSString stringWithUTF8String:(char *)sqlite3_column_text(SimplinicTableActivityGetStmt, 2)]; //VINAY
        // NSNumber *genericid=[NSNumber numberWithInt:sqlite3_column_int(SimplinicTableActivityGetStmt, 1)]; //VINAY
        
         NSNumber *genericid=[NSNumber numberWithInt:sqlite3_column_int(SimplinicTableActivityGetStmt,0)];
         record.Generic=[NSString stringWithUTF8String:(char *)sqlite3_column_text(SimplinicTableActivityGetStmt,1)];
        record.GenericId = [NSNumber numberWithInt:[genericid integerValue]];
    
        while ([[record.Generic substringToIndex:1] isEqualToString:@" "]) {
            record.Generic = [NSString stringWithFormat:@"%@",[record.Generic substringToIndex:1]];
        }
          /*
        if(Genericname==Nil || Genericname.length==0)
            [temp addObject:record];
        else if(Genericname.length > record.Generic.length)
            continue;
        else if([[record.Generic substringToIndex:Genericname.length] compare:Genericname options:NSCaseInsensitiveSearch]==0)
            [temp addObject:record];
           */
          if(Genericname!=Nil)
        [temp addObject:record];
    }
    return temp;
     
}


+(NSArray*)returnAllValidBrandRecords:(NSString*)searchString{
    sqlite3_stmt *SimplinicTableActivityGetStmt;
    
	const char *sqlSerialQuery = "select * from BrandsTable";
	
	if(sqlite3_prepare_v2(database, sqlSerialQuery, -1, &SimplinicTableActivityGetStmt, NULL)!=SQLITE_OK){
		NSAssert1(0,@"Error while updating From sqlLevelQues5.'%s'",sqlite3_errmsg(database));
	}
    NSMutableArray* temp = [[[NSMutableArray alloc] init]autorelease];
    while(sqlite3_step(SimplinicTableActivityGetStmt)==SQLITE_ROW){
        Brand *record=[[[Brand alloc] init]autorelease];
        record.BrandName=[NSString stringWithUTF8String:(char *)sqlite3_column_text(SimplinicTableActivityGetStmt, 1)];
        NSNumber *brandid=[NSNumber numberWithInt:sqlite3_column_int(SimplinicTableActivityGetStmt, 2)];
        record.BrandId = [NSNumber numberWithInt:[brandid integerValue]];
        while ([[record.BrandName substringToIndex:1] isEqualToString:@" "]) {
            record.BrandName = [NSString stringWithFormat:@"%@",[record.BrandName substringToIndex:1]];
        }
        record.BrandDosage=[NSString stringWithUTF8String:(char *)sqlite3_column_text(SimplinicTableActivityGetStmt, 4)];
        record.BrandManufacturer=[NSString stringWithUTF8String:(char *)sqlite3_column_text(SimplinicTableActivityGetStmt, 5)];
        record.BrandComposition=[NSString stringWithUTF8String:(char *)sqlite3_column_text(SimplinicTableActivityGetStmt, 6)];
        PriceObject* tempPriceObj = [[[PriceObject alloc] init]autorelease];
        tempPriceObj.DosageForm = [NSString stringWithUTF8String:(char *)sqlite3_column_text(SimplinicTableActivityGetStmt, 7)];
        tempPriceObj.PackSize = [NSString stringWithUTF8String:(char *)sqlite3_column_text(SimplinicTableActivityGetStmt, 8)];
        tempPriceObj.RetailPrice = [NSString stringWithUTF8String:(char *)sqlite3_column_text(SimplinicTableActivityGetStmt, 9)];
        tempPriceObj.Strength = [NSString stringWithUTF8String:(char *)sqlite3_column_text(SimplinicTableActivityGetStmt, 10)];
        record.arrayPrices = [[NSMutableArray alloc] initWithObjects:tempPriceObj, nil];
        if(searchString==Nil || searchString.length==0)
            [temp addObject:record];
        else if(searchString.length > record.BrandName.length)
            continue;
        else if([[record.BrandName substringToIndex:searchString.length] compare:searchString options:NSCaseInsensitiveSearch]==0)
            [temp addObject:record];
    }
    return temp;
}

+(NSArray*)returnAllBrandRecords:(NSString*)searchString{
    sqlite3_stmt *SimplinicTableActivityGetStmt;
   NSString *bindParam = [NSString stringWithFormat:@"%@%%", searchString];
	
    const char *sqlSerialQuery = "select * from tbl_brand where brand_name like ?";
	
	if(sqlite3_prepare_v2(database, sqlSerialQuery, -1, &SimplinicTableActivityGetStmt, NULL)!=SQLITE_OK){
		NSAssert1(0,@"Error while updating From sqlLevelQues5.'%s'",sqlite3_errmsg(database));
	}
    sqlite3_bind_text(SimplinicTableActivityGetStmt,1, [bindParam UTF8String], -1, SQLITE_TRANSIENT);
    NSMutableArray* temp = [[[NSMutableArray alloc] init]autorelease];
    while(sqlite3_step(SimplinicTableActivityGetStmt)==SQLITE_ROW){
        Brand *record=[[[Brand alloc] init]autorelease];
        record.BrandName=[NSString stringWithUTF8String:(char *)sqlite3_column_text(SimplinicTableActivityGetStmt,1)];
        NSNumber *brandid=[NSNumber numberWithInt:sqlite3_column_int(SimplinicTableActivityGetStmt,0)];
        record.BrandId = [NSNumber numberWithInt:[brandid integerValue]];
        while ([[record.BrandName substringToIndex:1] isEqualToString:@" "]) {
            record.BrandName = [NSString stringWithFormat:@"%@",[record.BrandName substringToIndex:1]];
        }
        
        if(searchString==Nil || searchString.length==0)
            [temp addObject:record];
        else if(searchString.length > record.BrandName.length)
            continue;
        else if([[record.BrandName substringToIndex:searchString.length] compare:searchString options:NSCaseInsensitiveSearch]==0)
            [temp addObject:record];
         
          }
    return temp;

}

+(void)InsertANewGenericRecord:(Generic*)genericRecord{

    if(addStmtGenericNewAudit == nil) {
        const char *sqlNewAudit = "INSERT OR REPLACE INTO GenericsTable(genericId,genericName) Values(?,?)";
        int error = sqlite3_prepare_v2(database, sqlNewAudit, -1, &addStmtGenericNewAudit, NULL);
        if(error != SQLITE_OK)
            NSAssert1(0, @"Error while creating add statement. '%s'", sqlite3_errmsg(database));
    }
    sqlite3_bind_int(addStmtGenericNewAudit, 1, [genericRecord.GenericId integerValue]);
    sqlite3_bind_text(addStmtGenericNewAudit, 2, [genericRecord.Generic UTF8String], -1, SQLITE_TRANSIENT);
    
    if(SQLITE_DONE != sqlite3_step(addStmtGenericNewAudit))
        NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(database));
    
    sqlite3_reset(addStmtGenericNewAudit);
}


+(void)InsertANewBrandRecord:(Brand*)brandRecord ForGenericId:(NSInteger)genericId{

    if(addStmtBrandNewAudit == nil) {
        
        const char *sqlNewAudit = "INSERT OR REPLACE INTO BrandsTable(brandName,brandId,genericId,Dosage,CompanyName,Composition,DosageForm,PackSize,RetailPrice,Strength) Values(?,?,?,?,?,?,?,?,?,?)";
        int error = sqlite3_prepare_v2(database, sqlNewAudit, -1, &addStmtBrandNewAudit, NULL);
        if(error != SQLITE_OK)
            NSAssert1(0, @"Error while creating add statement. '%s'", sqlite3_errmsg(database));
    }
    sqlite3_bind_text(addStmtBrandNewAudit, 1, [brandRecord.BrandName UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_int(addStmtBrandNewAudit, 2, [brandRecord.BrandId integerValue]);
    sqlite3_bind_int(addStmtBrandNewAudit, 3, genericId);
    sqlite3_bind_text(addStmtBrandNewAudit, 4, [brandRecord.BrandDosage UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(addStmtBrandNewAudit, 5, [brandRecord.BrandManufacturer UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(addStmtBrandNewAudit, 6, [brandRecord.BrandComposition UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(addStmtBrandNewAudit, 7, [[(PriceObject*)[brandRecord.arrayPrices objectAtIndex:0] DosageForm] UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(addStmtBrandNewAudit, 8, [[(PriceObject*)[brandRecord.arrayPrices objectAtIndex:0] PackSize] UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(addStmtBrandNewAudit, 9, [[(PriceObject*)[brandRecord.arrayPrices objectAtIndex:0] RetailPrice] UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(addStmtBrandNewAudit, 10, [[(PriceObject*)[brandRecord.arrayPrices objectAtIndex:0] Strength] UTF8String], -1, SQLITE_TRANSIENT);
    
    if(SQLITE_DONE != sqlite3_step(addStmtBrandNewAudit))
        NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(database));
    
    sqlite3_reset(addStmtBrandNewAudit);
}


+(void)DeleteAllGenerics{
    sqlite3_stmt *deleteStmtRecord=nil;
	if(deleteStmtRecord == nil) {
		
		NSString *str_queryLevel2 = [NSString stringWithFormat:@"delete from GenericsTable"];
		const char *sql = [str_queryLevel2 UTF8String];
		
		
		if(sqlite3_prepare_v2(database, sql, -1, &deleteStmtRecord, NULL) != SQLITE_OK)
			NSAssert1(0, @"Error while creating delete statement. '%s'", sqlite3_errmsg(database));
	}
	
	if (SQLITE_DONE != sqlite3_step(deleteStmtRecord)) 
		NSAssert1(0, @"Error while deleting. '%s'", sqlite3_errmsg(database));
	
	sqlite3_reset(deleteStmtRecord);
}


+(void)DeleteAllBrands{
    sqlite3_stmt *deleteStmtRecord=nil;
	if(deleteStmtRecord == nil) {
		
		NSString *str_queryLevel2 = [NSString stringWithFormat:@"delete from BrandsTable"];
		const char *sql = [str_queryLevel2 UTF8String];
		
		
		if(sqlite3_prepare_v2(database, sql, -1, &deleteStmtRecord, NULL) != SQLITE_OK)
			NSAssert1(0, @"Error while creating delete statement. '%s'", sqlite3_errmsg(database));
	}
	
	if (SQLITE_DONE != sqlite3_step(deleteStmtRecord)) 
		NSAssert1(0, @"Error while deleting. '%s'", sqlite3_errmsg(database));
	
	sqlite3_reset(deleteStmtRecord);
}

+(BOOL)doGenericsExist{
    sqlite3_stmt *SimplinicTableActivityGetStmt;
    
	const char *sqlSerialQuery = "SELECT * FROM GenericsTable";
	
	if(sqlite3_prepare_v2(database, sqlSerialQuery, -1, &SimplinicTableActivityGetStmt, NULL)!=SQLITE_OK){
		NSAssert1(0,@"Error while updating From sqlLevelQues5.'%s'",sqlite3_errmsg(database));
	}
    NSInteger num=0;
    while(sqlite3_step(SimplinicTableActivityGetStmt)==SQLITE_ROW){
        num++;
        num=sqlite3_column_int(SimplinicTableActivityGetStmt, 1);
    }
    if(num>0)
        return TRUE;
    else
        return FALSE;
}

+(BOOL)doBrandsExist{
    sqlite3_stmt *SimplinicTableActivityGetStmt;
    
	const char *sqlSerialQuery = "SELECT * FROM BrandsTable";
	
	if(sqlite3_prepare_v2(database, sqlSerialQuery, -1, &SimplinicTableActivityGetStmt, NULL)!=SQLITE_OK){
		NSAssert1(0,@"Error while updating From sqlLevelQues5.'%s'",sqlite3_errmsg(database));
	}
    NSInteger num=0;
    while(sqlite3_step(SimplinicTableActivityGetStmt)==SQLITE_ROW){
        num++;
        num=sqlite3_column_int(SimplinicTableActivityGetStmt, 1);
    }
    if(num>0)
        return TRUE;
    else
        return FALSE;
}

@end
