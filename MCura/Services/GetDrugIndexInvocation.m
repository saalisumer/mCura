//
//  GetDrugIndexInvocation.m
//  mCura
//
//  Created by Aakash Chaudhary on 21/07/12.
//  Copyright (c) 2012 aakash272@gmail.com. All rights reserved.
//

#import "GetDrugIndexInvocation.h"
#import "JSON.h"
#import "DrugIndex.h"
#import "DrugIndex+Parse.h"
#import "DataExchange.h"
#import "Generic.h"

@implementation GetDrugIndexInvocation

@synthesize genericId,brandId,type;

-(void)dealloc {	
	[super dealloc];
}

-(void)invoke {
    if(self.type == 1){
        NSString *a= [NSString stringWithFormat:@"%@DrugIndex_Drugs",[DataExchange getbaseUrl]];
        [self get:a];
    }
    else if(self.type == 2){
        NSString *a= [NSString stringWithFormat:@"%@DrugIndex_Drug?genericid=%d",[DataExchange getbaseUrl],self.genericId];
        NSLog(@"%@",a);
        [self get:a];
    }
    else {
        NSString *a= [NSString stringWithFormat:@"%@DrugIndex_Brand?BrandID=%d",[DataExchange getbaseUrl],self.brandId];
        [self get:a];
    }
}

-(BOOL)handleHttpOK:(NSMutableData *)data {
    NSArray* resultsd = [[[[NSString alloc] initWithData:data
                                                encoding:NSUTF8StringEncoding] autorelease] JSONValue];
    if(self.type==1){
        NSArray *response = [DrugIndex DrugIndicesFromArray:resultsd];
        NSMutableArray* temp = [[NSMutableArray alloc] init];
        for (int i=0; i<response.count; i++) {
            Generic* gen = [[Generic alloc] init];
            gen.Generic = [(DrugIndex*)[response objectAtIndex:i] Name];
            gen.GenericId = [(DrugIndex*)[response objectAtIndex:i] Id];
            [temp addObject:gen];
        }
        [self.delegate GetDrugIndexInvocationDidFinish:self withDrugIndices:temp withError:nil];
    }
    else{
        [self.delegate GetDrugIndexInvocationDidFinish:self withString:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] withType:self.type withError:nil];
    }
	return YES;
}

-(BOOL)handleHttpError:(NSInteger)code {
    [self.delegate GetDrugIndexInvocationDidFinish:self withDrugIndices:nil withError:[NSError errorWithDomain:@"Drug Index" code:[[self response] statusCode] userInfo:[NSDictionary dictionaryWithObject:@"Failed to get Drug Index. Please try again later" forKey:@"message"]]];
	return YES;
}

@end
