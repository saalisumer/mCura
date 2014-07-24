//
//  Patient+Parse.h
//  3GMDoc

#import "Patient.h"

@interface Patient (Parse)

+(Patient*) PatientsFromDictionary:(NSDictionary*)Patientsd;
+(NSArray*) PatientsFromArray:(NSArray*) PatientsA;

@end
