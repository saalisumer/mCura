//
//  PatientComplaint.h
//  3GMDoc
//
//  Created by Aakash Chaudhary on 05/02/12.
//  Copyright (c) 2012 aakash272@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Foundation/NSDictionary.h>
#import <Foundation/NSArray.h>

@interface PatientComplaint : NSObject{
    
}

@property(nonatomic, retain) NSString* associatedSymptoms;
@property(nonatomic, retain) NSString* cheifComp;
@property(nonatomic, retain) NSString* complaintId;
@property(nonatomic, retain) NSString* duration;
@property(nonatomic, retain) NSString* episodesInPast;
@property(nonatomic, retain) NSString* onset;
@property(nonatomic, retain) NSString* otherSymptoms;
@property(nonatomic, retain) NSString* progression;
@property(nonatomic, retain) NSString* regression;
@property(nonatomic, retain) NSString* severityId;

@end
