//
//  Appointment+Parse.h
//  3GMDoc

#import "Appointment.h"

@interface Appointment (Parse)

+(Appointment*) AppointmentsFromDictionary:(NSDictionary*)Appointmentsd;
+(NSArray*) AppointmentsFromArray:(NSArray*) AppointmentsA;

@end
