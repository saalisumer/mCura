//
//  UserDetail+Parse.m
//  3GMDoc

#import "UserDetail+Parse.h"
#import "UserDetail.h"
#import "JSON.h"

@implementation UserDetail (Parse)

+(UserDetail*) userDetailsFromDictionary:(NSDictionary*)userDetailsd{
	if (!userDetailsd) {
		return Nil;
	}
	
	UserDetail *usr = [[[UserDetail alloc] init] autorelease];
    usr.userId      = [userDetailsd objectForKey:@"UserId"];        
	usr.genderId    = [userDetailsd objectForKey:@"GenderId"];
	usr.u_name      = [userDetailsd objectForKey:@"Uname"];
	usr.dob			= [userDetailsd objectForKey:@"Dob"];
	usr.addressId        = [userDetailsd objectForKey:@"AddressId"];
	usr.contactId		 = [userDetailsd objectForKey:@"ContactId"];
	usr.currentStatusId	 = [userDetailsd objectForKey:@"CurrentStatusId"];
    
	return usr;
}

+(NSArray*) userDetailsFromArray:(NSDictionary*) userDetailsA{
	if (!userDetailsA) {
		return Nil;
	}
	
	NSMutableArray *res = [[[NSMutableArray alloc] init] autorelease];

    UserDetail *u = [UserDetail userDetailsFromDictionary:userDetailsA];
    if (u) {
        [res addObject:u];
    }
	
	return res;	
}

@end
