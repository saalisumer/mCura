//
//  PatientContactDetails+Parse.h
//  3GMDoc

#import "PatientContactDetails.h"

@interface PatientContactDetails (Parse)

+(PatientContactDetails*) PatientContactDetailsFromDictionary:(NSDictionary*)PatientContactDetailsd;
+(NSArray*) PatientContactDetailsFromArray:(NSDictionary*) PatientContactDetailsA;

@end
