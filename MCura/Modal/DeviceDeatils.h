//
//  DeviceDeatils.h
//  3GMDoc

#import <Foundation/Foundation.h>
#import <Foundation/NSDictionary.h>
#import <Foundation/NSArray.h>

@interface DeviceDeatils : NSObject {
	
}

@property(nonatomic, retain) NSNumber *ActivationDate;
@property(nonatomic, retain) NSNumber *ActivationId;
@property(nonatomic, retain) NSString *Make;
@property(nonatomic, retain) NSString *Os;
@property(nonatomic, retain) NSString *SerialNo;
@property(nonatomic, retain) NSNumber *TabletId;
@property(nonatomic, retain) NSString *TabletOwnerType;
@property(nonatomic, retain) NSNumber *TabletOwnerTypeId;


@end
