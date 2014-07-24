//
//  PatientAddress+Parse.h
//  3GMDoc

#import "PatientAddress.h"

@interface PatientAddress (Parse)

+(PatientAddress*) PatientAddressFromDictionary:(NSDictionary*)PatientAddresssd;
+(NSArray*) PatientAddressFromArray:(NSDictionary*) PatientAddressA;

@end
