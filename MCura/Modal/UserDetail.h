//
//  UserDetail.h
//  3GMDoc

#import <Foundation/Foundation.h>
#import <Foundation/NSDictionary.h>
#import <Foundation/NSArray.h>

@interface UserDetail : NSObject {
	
}

@property(nonatomic, retain) NSNumber *userId;
@property(nonatomic, retain) NSNumber *genderId;
@property(nonatomic, retain) NSString *u_name;
@property(nonatomic, retain) NSString *dob;
@property(nonatomic, retain) NSNumber *addressId;
@property(nonatomic, retain) NSNumber *contactId;
@property(nonatomic, retain) NSNumber *currentStatusId;


@end
