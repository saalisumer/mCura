//
//  PatMedRecords+Parse.m
//  3GMDoc
//
//  Created by Aakash Chaudhary on 05/02/12.
//  Copyright (c) 2012 aakash272@gmail.com. All rights reserved.
//

#import "PatMedRecords+Parse.h"
#import "DataExchange.h"

@implementation PatMedRecords (Parse)

+(NSArray*) PatMedRecordsFromArray:(NSDictionary*) PatMedRecordsA{
    if (!PatMedRecordsA || [PatMedRecordsA isKindOfClass:[NSNull class]]) {
        return Nil;
    }
    NSMutableArray *PatientComplaintsArr = [[[NSMutableArray alloc] init] autorelease];
    NSArray *abc = [PatMedRecordsA objectForKey:@"patmedrecords"];
    if(abc.count==0){
        PatMedRecords *sch = [[PatMedRecords alloc] init];
        sch.ImagePath = [NSString stringWithFormat:@"http://%@/%@",[DataExchange getDomainUrl],[PatMedRecordsA objectForKey:@"imagepath"]];
        [PatientComplaintsArr addObject:sch];
    }
    for (int i = 0; i < abc.count; i++) {
        PatMedRecords *sch = [PatMedRecords PatMedRecordsFromDictionary:[abc objectAtIndex:i]];
        if (sch) {
            sch.ImagePath = [NSString stringWithFormat:@"http://%@/%@",[DataExchange getDomainUrl],[PatMedRecordsA objectForKey:@"imagepath"]];
            [PatientComplaintsArr addObject:sch];
        }
    }    
    
    return PatientComplaintsArr;
}

+(PatMedRecords*) PatMedRecordsFromDictionary:(NSDictionary*)PatMedRecordsD{
    if (!PatMedRecordsD) {
		return Nil;
	}

	PatMedRecords *app = [[[PatMedRecords alloc] init] autorelease];
    app.Date = [PatMedRecordsD objectForKey:@"Date"];
    app.EntryTypeId = [PatMedRecordsD objectForKey:@"EntryTypeId"];
    app.Mrno = [PatMedRecordsD objectForKey:@"Mrno"];
    app.RecordId = [PatMedRecordsD objectForKey:@"RecordId"];
    app.RecNatureId = [PatMedRecordsD objectForKey:@"RecNatureId"];
    app.UserRoleId = [PatMedRecordsD objectForKey:@"UserRoleId"];

	return app;
}

@end
