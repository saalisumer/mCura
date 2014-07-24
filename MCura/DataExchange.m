//
//  DataExchange.m
//  3GMDoc

#import "DataExchange.h"


@implementation DataExchange


//Device ID Varification
static NSArray *deviceDetails;
+(void)setDeviceDetails:(NSArray *)_data{
    deviceDetails = [[NSArray alloc]autorelease];
    deviceDetails = [_data copy];
    
}
+(NSArray *)getDeviceDetails{
    return deviceDetails;
}

static NSArray *dosageData;
+(void)setDosageResponse:(NSArray *)_data{
    dosageData = [[[NSArray alloc]init] autorelease];
    dosageData = [_data copy];
    
}
+(NSArray *)getDosageReponse{
    return dosageData;    
}

static NSArray *ganaricData;
+(void)setGenericResponse:(NSArray *)_data{
    ganaricData = [[[NSArray alloc]init] autorelease];
    ganaricData = [_data copy];
    
}
+(NSArray *)getGenericReponse{
    return ganaricData;    
}

static NSArray *brandData;
+(void)setBrandResponse:(NSArray *)_data{
    brandData = [[[NSArray alloc]init] autorelease];
    brandData = [_data copy];
    
}
+(NSArray *)getBrandReponse{
    return brandData;    
}

static NSArray *dosageFrmData;
+(void)setDosagesFromResponse:(NSArray *)_data{
    dosageFrmData = [[[NSArray alloc]init] autorelease];
    dosageFrmData = [_data copy];
    
}
+(NSArray *)getDosagesFromReponse{
    return dosageFrmData;    
}

static NSArray *instructionData;
+(void)setInstructionsFromResponse:(NSArray *)_data{
    instructionData = [[[NSArray alloc]init] autorelease];
    instructionData = [_data copy];
    
}
+(NSArray *)getInstructionsFromReponse{
    return instructionData;    
}

static NSArray *followupData;
+(void)setFollowupFromResponse:(NSArray *)_data{
    followupData = [[[NSArray alloc]init] autorelease];
    followupData = [_data copy];
    
}
+(NSArray *)getFollowupFromReponse{
    return followupData;    
}

static NSArray *medicineData;
+(void)setMedicinesFromResponse:(NSArray *)_data{
    medicineData = [[[NSArray alloc]init] autorelease];
    medicineData = [_data copy];
    
}
+(NSArray *)getMedicinesFromReponse{
    return medicineData;    
}

static NSArray *pharmacyData;
+(void)setPharmacyFromResponse:(NSArray *)_data{
    pharmacyData = [[[NSArray alloc]init] autorelease];
    pharmacyData = [_data copy];
    
}
+(NSArray *)getPharmacyFromReponse{
    return pharmacyData;    
}

static NSArray *labData;
+(void)setLabFromResponse:(NSArray *)_data{
    labData = [[[NSArray alloc]init] autorelease];
    labData = [_data copy];
    
}
+(NSArray *)getLabFromReponse{
    return labData;    
}

static NSArray *loginData;
+(void)setLoginResponse:(NSArray *)_data{
    loginData = [[[NSArray alloc]init] autorelease];
    loginData = [_data copy];
    
}
+(NSArray *)getLoginResponse{
    return loginData;    
}

//Appointment Response
static NSArray *natureData;
+(void)setNatureResponse:(NSArray *)_data{
    natureData = [[NSArray alloc]init];
    natureData = [_data copy];
    
}
+(NSArray *)getNatureReponse{
    return natureData;
}

//Scheduler Data
static NSArray *schedulerData;
+(void)setSchedulerResponse:(NSArray *)_data{
    schedulerData = [[NSArray alloc]init];
    schedulerData = [_data copy];
    
}
+(NSArray *)getSchedulerReponse{
    return schedulerData;
}

//Schedule Day
static NSInteger schedulerDayIndex;
+(void)setScheduleDayIndex:(NSInteger)day{
    schedulerDayIndex = day;
}
+(NSInteger)getScheduleDayIndex{
    return schedulerDayIndex;
}

//USer Result
static NSArray *userResult; 
+(void)setUserResult :(NSArray *)_data{
    userResult = [[[NSArray alloc]init] autorelease];
    userResult = [_data copy];
    
}
+(NSArray *)getUserResult{
    return userResult;
}

//USer role ID
static NSString *userRoleId;
+(void)setUserRoleId :(NSString *)_data{
    userRoleId = [[[NSString alloc] init] autorelease];
    userRoleId = [_data copy];
}

+(NSString *)getUserRoleId{
    return userRoleId;
}

//PatientSearch Result
static NSMutableArray *_patientList;
+(void)setPatientSearch:(NSMutableArray *)patientList{
    _patientList = [[[NSMutableArray alloc]init] autorelease];
    _patientList = [patientList copy];
    
}
+(NSMutableArray *)getPatientSearched{
    return _patientList;
}

//Schedule Image Name
static NSMutableString *imgName;
+(void)setScheduleImageName:(NSMutableString *)name{
    imgName = [[[NSMutableString alloc]init ] autorelease];
    imgName = [name copy];
    
}
+(NSMutableString *)getScheduleImageName{
    return imgName;
    
}

//AppointmentUpdateStatus;
static NSMutableString *status;
+(void)setUpdateAppointmentStatus:(NSMutableString *)_status{
    status = [[[NSMutableString alloc]init ] autorelease];
    status = [_status copy];
    
}
+(NSMutableString *)getUpdateAppointmentStatus{
    return status;
}

//Contact ID
static NSString *cntID;
+(void)setContactID:(NSString *)_cntID{
    cntID = [[[NSString alloc]init] autorelease];
    cntID = [_cntID copy];
    
}
+(NSString *)getContactID{
    return cntID;
}

//Address ID
static NSString *addID;
+(void)setAddressID:(NSString *)_addID{
    addID = [[[NSString alloc]init] autorelease];
    addID = [_addID copy];
}
+(NSString *)getAddressID{
    return addID;
}

//Area ID
static NSString *areaID;
+(void)setAreaID:(NSString *)_addID{
    areaID = [[[NSString alloc]init] autorelease];
    areaID = [_addID copy];
}
+(NSString *)getAreaID{
    return areaID;
}

//Patient MRNNumber

static NSString *mrnNumber;
+(void)setPatientMRNNumber:(NSString *)_mrnNumber{
    mrnNumber = [[[NSString alloc]init] autorelease];
    mrnNumber = [_mrnNumber copy];
    
}
+(NSString *)getsetPatientMRNNumber{
    return mrnNumber;
}
//Appointment NatureList
static NSMutableArray *apptNature;
+(void)setAppointmentNatureList:(NSMutableArray *)_data{
    apptNature = [[[NSMutableArray alloc]init] autorelease];
    apptNature = [_data copy];

    
    
}
+(NSMutableArray *)getAppointmentNature{
    return apptNature;
}


//Get Selected Date
static NSMutableString *date;
+(void)setSelectedDate:(NSString *)_date{
    date = [[NSMutableString alloc]init];
    [date appendString:_date];
    
}
+(NSMutableString *)getSelectedDate{
    return date;
}

//Setting getter for schedule time
static NSMutableDictionary *scheduleTime;
+(void)setScheduleTime:(NSMutableDictionary *)_data{
    scheduleTime = [[NSMutableDictionary alloc]init];
    scheduleTime = [_data copy];
    
    
}
+(NSMutableDictionary *)getScheduleTime{
    return scheduleTime;
    
}


//setter and getter for PatImageID
static NSString *patImgID;
+(void)setPatImageID:(NSString *)_patImgID{
    patImgID = [[NSString alloc] init];
    patImgID = [_patImgID copy];
}
+(NSString *)getPAtImageID{
    return patImgID;
}

//setter and getter for current hospital name
static NSString *hospitalName;
+(void)setHospitalName:(NSString *)_hosp{
    hospitalName = [[NSString alloc] init];
    hospitalName = [_hosp copy];
}
+(NSString *)getHospitalName{
    return hospitalName;
}

//setter and getter for sub tenant IDs array
static NSArray * subTenantIds;
+(void)setSubTenantIds:(NSArray *)_ids{
    subTenantIds = [[[NSArray alloc] init] autorelease];
    subTenantIds = [_ids copy];
}
+(NSArray *)getSubTenantIds{
    return subTenantIds;
}

//setter and getter for current sub tenant ID index
static NSInteger selSubtenIndex;
+(void)setSubTenantIdIndex:(NSInteger)_index{
    selSubtenIndex = _index;
}
+(NSInteger)getSubTenantIdIndex{
    return selSubtenIndex;
}

//setter and getter for current sub tenant ID
static NSInteger subtenID;
+(void)setSubTenantId:(NSInteger)_index{
    subtenID = _index;
}
+(NSInteger)getSubTenantId{
    return subtenID;
}

//setter and getter for pat img address
static NSData* imgDataArray;
+(void)setPatImage:(NSData *)_imgData{
    imgDataArray = [[[NSData alloc] init] autorelease];
    imgDataArray = [_imgData copy];
}
+(NSData *)getPatImage{
    return imgDataArray;
}

//setter and getter for pat img address
static NSArray * scheduleArray;
+(void)setScheduleData:(NSArray*)scheduleData{
    scheduleArray = [[[NSArray alloc] init] autorelease];
    scheduleArray = [scheduleData copy];
}

+(NSArray *)getScheduleData{
    return scheduleArray;
}

//service base url setDomainUrl
static NSString *baseUrl;
+(void)setbaseUrl:(NSString *)_baseUrl{
    baseUrl = [[NSString alloc]init];
    baseUrl = [_baseUrl copy];
}
+(NSString *)getbaseUrl{
    return baseUrl;
}

//service domain url
static NSString *domainUrl;
+(void)setDomainUrl:(NSString *)_baseUrl{
    domainUrl = [[NSString alloc]init];
    domainUrl = [_baseUrl copy];
}
+(NSString *)getDomainUrl{
    return domainUrl;
}

//setter and getter for doc display data
static NSMutableArray * dispArray;
+(void)setDocDisplayData:(NSArray *)dispData{
    dispArray = [[[NSMutableArray alloc] init] autorelease];
    dispArray = [dispData copy];
}

+(NSMutableArray *)getDocDisplayData{
    return dispArray;
}

//setter and getter for Refreshing Appointments
static NSInteger appointmentRefreshIndex;
+(void)setAppointmentRefreshIndex:(NSInteger)_index{
    appointmentRefreshIndex = _index;
}

+(NSInteger)getAppointmentRefreshIndex{
    return appointmentRefreshIndex;
}

//setter and getter for added patient
static Patient* addedPatient;
+(void)setAddPatient:(Patient*)pat{
    addedPatient = [pat retain];
}

+(Patient*)getAddPatient{
    return addedPatient;
}

//setter and getter for total bytes
static long totalBytesToRead;
+(void)setTotalBytes:(long)_bytes{
    totalBytesToRead = _bytes;
}
+(long)getTotalBytes{
    return totalBytesToRead;
}

//setter and getter for current bytes
static long currentBytesToRead;
+(void)setcurrentBytes:(long)_bytes{
    currentBytesToRead = _bytes;
}
+(long)getcurrentBytes{
    return currentBytesToRead;
}

+(NSString*)militaryToTwelveHr:(NSString*)time{
    NSString* timeStr;
    NSInteger hourVal = [[[time componentsSeparatedByString:@":"] objectAtIndex:0] integerValue];
    NSInteger minutesValue = [[[time componentsSeparatedByString:@":"] objectAtIndex:1] integerValue];
    if(hourVal < 12){
        timeStr = [NSString stringWithFormat:@"%d:",hourVal];
        timeStr = [timeStr stringByAppendingFormat:@"%@%d",(minutesValue<10?@"0":@""),minutesValue];
        timeStr = [timeStr stringByAppendingFormat:@" am"];
    }
    else if(hourVal<13){
        timeStr = [NSString stringWithFormat:@"%d:",hourVal];
        timeStr = [timeStr stringByAppendingFormat:@"%@%d",(minutesValue<10?@"0":@""),minutesValue];
        timeStr = [timeStr stringByAppendingFormat:@" pm"];
    }
    else{
        timeStr = [NSString stringWithFormat:@"%d:",hourVal-12];
        timeStr = [timeStr stringByAppendingFormat:@"%@%d",(minutesValue<10?@"0":@""),minutesValue];
        timeStr = [timeStr stringByAppendingFormat:@" pm"];
    }
    return timeStr;
}

@end
