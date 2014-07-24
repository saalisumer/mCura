//
//  PatientComplaint+Parse.m
//  3GMDoc
//
//  Created by Aakash Chaudhary on 05/02/12.
//  Copyright (c) 2012 aakash272@gmail.com. All rights reserved.
//

#import "PatientComplaint+Parse.h"

@implementation PatientComplaint (Parse)

+(PatientComplaint*) PatientComplaintDetailsFromDictionary:(NSDictionary*)PatientComplaintsD{
	if (!PatientComplaintsD) {
		return Nil;
	}
	
	PatientComplaint *app = [[[PatientComplaint alloc] init] autorelease];
    
    app.associatedSymptoms = [PatientComplaintsD objectForKey:@"Associatedsymptoms"];
    app.cheifComp = [PatientComplaintsD objectForKey:@"CheifComp"];
    app.complaintId = [PatientComplaintsD objectForKey:@"ComplaintId"];
    app.duration = [PatientComplaintsD objectForKey:@"Duration"];
    app.episodesInPast = [PatientComplaintsD objectForKey:@"Episodesinpast"];
    app.onset = [PatientComplaintsD objectForKey:@"Onset"];
    app.otherSymptoms = [PatientComplaintsD objectForKey:@"Othersymptoms"];
    app.progression = [PatientComplaintsD objectForKey:@"Progression"];
    app.regression = [PatientComplaintsD objectForKey:@"Regression"];
    app.severityId = [PatientComplaintsD objectForKey:@"SeverityId"];
    
	return app;
}

+(NSArray*) PatientComplaintsFromArray:(NSDictionary*) PatientComplaintsA{
    if (!PatientComplaintsA || [PatientComplaintsA isKindOfClass:[NSNull class]]) {
        return Nil;
    }
    
    NSMutableArray *PatientComplaintsArr = [[[NSMutableArray alloc] init] autorelease];
    PatientComplaint *sch = [PatientComplaint PatientComplaintDetailsFromDictionary:PatientComplaintsA];
    [PatientComplaintsArr addObject:sch];
    
    return PatientComplaintsArr;
}
@end
