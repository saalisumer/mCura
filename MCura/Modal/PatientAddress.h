//
//  PatientAddress.h
//  3GMDoc

#import <Foundation/Foundation.h>
#import <Foundation/NSDictionary.h>
#import <Foundation/NSArray.h>

@interface PatientAddress : NSObject {
	
}

@property(nonatomic, retain) NSString *Address1;
@property(nonatomic, retain) NSString *Address2;
@property(nonatomic, retain) NSNumber *AddressId;
@property(nonatomic, retain) NSNumber *AreaId;
@property(nonatomic, retain) NSString *Zipcode;

@end