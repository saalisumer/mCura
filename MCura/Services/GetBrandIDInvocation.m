//
//  GetBrandIDInvocation.m
//  mCura
//
//  Created by Vinay Kumar on 27/11/12.
//
//

#import "JSON.h"
#import "GetBrandIDInvocation.h"
#import "Brand.h"
#import "Brand+Parse.h"

@implementation GetBrandIDInvocation
@synthesize userRollId,brandId;

-(void)dealloc {
	[super dealloc];
}

-(void)invoke {
    NSString *a= [NSString stringWithFormat:@"%@DrugIndex_Brand?BrandID=%@",[DataExchange getbaseUrl],self.brandId];
    //[self setUrl:a];
	[self get:a];
}

-(BOOL)handleHttpOK:(NSMutableData *)data {
    
	//NSDictionary* dict = [[[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease] JSONValue];
  //  NSArray* resultsd = [dict objectForKey:@"DrugsBrand"];
    NSString *stringresponse=[[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
   id resultsd= [stringresponse JSONValue];
   // NSLog(@"%@",resultsd);
    // refactor this
   // [[NSUserDefaults standardUserDefaults] setValue:[dict objectForKey:@"Crossreaction"] forKey:@"Crossreaction"];
 //   [[NSUserDefaults standardUserDefaults] setValue:[dict objectForKey:@"Modeofaction"] forKey:@"Modeofaction"];
 //   [[NSUserDefaults standardUserDefaults] setValue:[dict objectForKey:@"Safety"] forKey:@"Safety"];
 //   [[NSUserDefaults standardUserDefaults] setValue:[dict objectForKey:@"Sideeffect"] forKey:@"Sideeffect"];
    
    NSArray *response = [Brand BrandsFromArray:resultsd];
	[self.delegate getBrandIDDidFinish:self withBrands:response withError:Nil];
	return YES;
}

-(BOOL)handleHttpError:(NSInteger)code {
	[self.delegate getBrandIDDidFinish:self withBrands:nil withError:[NSError errorWithDomain:@"Brand" code:[[self response] statusCode] userInfo:[NSDictionary dictionaryWithObject:@"Failed to get brand details. Please try again later" forKey:@"message"]]];
	return YES;
}

@end
