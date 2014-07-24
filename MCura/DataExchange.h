//
//  DataExchange.h
//  3GMDoc

#import <Foundation/Foundation.h>
#import "Patient.h"

@interface DataExchange : NSObject {
    
}
//Device ID Varification
+(void)setDeviceDetails:(NSArray *)_data;
+(NSArray *)getDeviceDetails;
//Login Response
+(void)setLoginResponse:(NSArray *)_data;
+(NSArray *)getLoginResponse;
//Scheduler Response
+(void)setSchedulerResponse:(NSArray *)_data;
+(NSArray *)getSchedulerReponse;

//Schedule Day
+(void)setScheduleDayIndex:(NSInteger)day;
+(NSInteger)getScheduleDayIndex;

//Nature Response
+(void)setNatureResponse:(NSArray *)_data;
+(NSArray *)getNatureReponse;

//Dosage Response
+(void)setDosageResponse:(NSArray *)_data;
+(NSArray *)getDosageReponse;

//Generic Response
+(void)setGenericResponse:(NSArray *)_data;
+(NSArray *)getGenericReponse;

//Brand Response
+(void)setBrandResponse:(NSArray *)_data;
+(NSArray *)getBrandReponse;

//DosagesFrom Response
+(void)setDosagesFromResponse:(NSArray *)_data;
+(NSArray *)getDosagesFromReponse;

//Instructions Response
+(void)setInstructionsFromResponse:(NSArray *)_data;
+(NSArray *)getInstructionsFromReponse;

//Followup Response
+(void)setFollowupFromResponse:(NSArray *)_data;
+(NSArray *)getFollowupFromReponse;

//Medicine Response
+(void)setMedicinesFromResponse:(NSArray *)_data;
+(NSArray *)getMedicinesFromReponse;

//Pharmacy Response
+(void)setPharmacyFromResponse:(NSArray *)_data;
+(NSArray *)getPharmacyFromReponse;

//Lab Response
+(void)setLabFromResponse:(NSArray *)_data;
+(NSArray *)getLabFromReponse;

//USer Result
+(void)setUserResult :(NSArray *)_data;
+(NSArray *)getUserResult;

//USer role ID
+(void)setUserRoleId :(NSString *)userRoleId;
+(NSString *)getUserRoleId;

//Schedule Image Name
+(void)setScheduleImageName:(NSMutableString *)name;
+(NSMutableString *)getScheduleImageName;

//PatientSearch Result
+(void)setPatientSearch:(NSMutableArray *)patientList;
+(NSMutableArray *)getPatientSearched;

+(void)setHospitalName:(NSString *)_hosp;
+(NSString *)getHospitalName;

//AppointmentUpdateStatus;
+(void)setUpdateAppointmentStatus:(NSMutableString *)_status;
+(NSMutableString *)getUpdateAppointmentStatus;

//Contact ID
+(void)setContactID:(NSString *)_cntID;
+(NSString *)getContactID;

//Address ID
+(void)setAddressID:(NSString *)_addID;
+(NSString *)getAddressID;

//Area ID
+(void)setAreaID:(NSString *)_addID;
+(NSString *)getAreaID;

//Patient MRNNumber
+(void)setPatientMRNNumber:(NSString *)mrnNumber;
+(NSString *)getsetPatientMRNNumber;

//Appointment NatureList
+(void)setAppointmentNatureList:(NSMutableArray *)_data;
+(NSMutableArray *)getAppointmentNature;

//Get Selected Date
+(void)setSelectedDate:(NSString *)_date;
+(NSMutableString *)getSelectedDate;

//Setter and Getter for schedule time
+(void)setScheduleTime:(NSMutableDictionary *)_data;
+(NSMutableDictionary *)getScheduleTime;

//setter and getter for sub tenant IDs array
+(void)setSubTenantIds:(NSArray *)_ids;
+(NSArray *)getSubTenantIds;

//setter and getter for current sub tenant ID index
+(void)setSubTenantIdIndex:(NSInteger)_index;
+(NSInteger)getSubTenantIdIndex;

//setter and getter for current sub tenant ID
+(void)setSubTenantId:(NSInteger)_index;
+(NSInteger)getSubTenantId;

//setter and getter for pat img address
+(void)setPatImage:(NSData *)imgData;
+(NSData *)getPatImage;

//setter and getter for pat img address
+(void)setScheduleData:(NSArray *)imgData;
+(NSArray *)getScheduleData;

//service base url
+(void)setbaseUrl:(NSString *)baseUrl;
+(NSString *)getbaseUrl;

//service base url
+(void)setDomainUrl:(NSString *)baseUrl;
+(NSString *)getDomainUrl;

//setter and getter for doc display data
+(void)setDocDisplayData:(NSMutableArray *)dispData;
+(NSMutableArray *)getDocDisplayData;

//setter and getter for Refreshing Appointments
+(void)setAppointmentRefreshIndex:(NSInteger)_index;
+(NSInteger)getAppointmentRefreshIndex;

//setter and getter for added patient
+(void)setAddPatient:(Patient*)pat;
+(Patient*)getAddPatient;

+(void)setTotalBytes:(long)_bytes;
+(long)getTotalBytes;

//setter and getter for current bytes
+(void)setcurrentBytes:(long)_bytes;
+(long)getcurrentBytes;

+(NSString*)militaryToTwelveHr:(NSString*)time;
@end
