//
//  GetBrandIDInvocation.h
//  mCura
//
//  Created by Vinay Kumar on 27/11/12.
//
//

#import "SAServiceAsyncInvocation.h"
#import "_GMDocAsyncInvocation.h"

@class GetBrandIDInvocation;

@protocol GetBrandIDDelegate

-(void) getBrandIDDidFinish:(GetBrandIDInvocation*)invocation
                         withBrands:(NSArray*)brands
                          withError:(NSError*)error;

@end

@interface GetBrandIDInvocation : _GMDocAsyncInvocation {
}

@property (nonatomic, retain) NSString *userRollId;
@property (nonatomic, retain) NSString *brandId;


@end



