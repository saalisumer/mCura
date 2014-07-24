//
//  Patient.h
//  3GMDoc

#import <Foundation/Foundation.h>
#import <Foundation/NSDictionary.h>
#import <Foundation/NSArray.h>

@interface Patient : NSObject {
	
}

@property(nonatomic, retain) NSNumber *AddressId;
@property(nonatomic, retain) NSNumber *ContactId;
@property(nonatomic, retain) NSString *Patname;
@property(nonatomic, retain) NSString *dob;
@property(nonatomic, retain) NSNumber *GenderId;
@property(nonatomic, retain) NSNumber *PatDemoid;
@property(nonatomic, retain) NSNumber *EntryTypeId;
@property(nonatomic, retain) NSNumber *MRNO;
@property(nonatomic, retain) NSArray *PatientAddress;
@property(nonatomic, retain) NSArray *PatientContactDetails;
@property(nonatomic, retain) NSNumber *RecNatureId;
@property(nonatomic, retain) NSNumber *sub_tenant_id;
@property(nonatomic, retain) NSString *imagepath;
@property(nonatomic, retain) NSString *patmedrecords;
@property(nonatomic, retain) NSString *recimages;

@end
