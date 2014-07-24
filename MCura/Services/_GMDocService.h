//
//  _GMDocService.h

#import <Foundation/Foundation.h>
#import "SAService.h"
#import "GetTabletInvocation.h"
#import "GetLoginInvocation.h"
#import "GetUserInvocation.h"
#import "GetScheduleInvocation.h"
#import "GetPatientInvocation.h"
#import "GetConnonInvocation.h"
#import "GetFreeSlotsInvocation.h"
#import "InsertAppointmentInvocation.h"
#import "AddPatientInvocation.h"
#import "PostMoveAppointmentInvocation.h"
#import "PostAppointmentInvocation.h"
#import "GetPatientContactDetail.h"
#import "GetAllergyInvocation.h"
#import "GetDosageInvocation.h"
#import "GetGenericInvocation.h"
#import "GetDosageFrmInvocation.h"
#import "GetFollowUpInvocation.h"
#import "GetPharmacyInvocation.h"
#import "GetInstructionInvocation.h"
#import "GetPatientAllergyInvocation.h"
#import "GetPatientHealthInvocation.h"
#import "GetPaientVitalsInvocation.h"
#import "GetBrandInvocation.h"
#import "GetBrandIDInvocation.h"
#import "GetPatComplaints.h"
#import "GetPatMedRecords.h"
#import "GetLabInvocation.h"
#import "GetSeverityInvocation.h"
#import "GetSubtenIdInvocation.h"
#import "GetLabGroupTestInvocation.h"
#import "GetLabPackageInvocation.h"
#import "GetLabTestListInvocation.h"
#import "GetLabOrPharmacyInvocation.h"
#import "PostUploadOrderTextInvocation.h"
#import "GetLabReportInvocation.h"
#import "GetVitalsInvocation.h"
#import "GetNotesInvocation.h"
#import "GetTemplateInvocation.h"
#import "GetMedRecNatureInvocation.h"
#import "GetCurrentVisitFileInvocation.h"
#import "GetDoctorReferralInvocation.h"
#import "GetDocAddrOrContInvocation.h"
#import "GetStringInvocation.h"
#import "GetDrugIndexInvocation.h"

@class Category;
@class Patient;
@interface _GMDocService : SAService {

}

-(void)GetTabletInvocation:(NSString*)serialNo delegate:(id<GetTabletInvocationDelegate>)delegate;

-(void)getLoginInvocation:(NSString*)username Password:(NSString*)password Type:(NSString*)type delegate:(id<GetLoginInvocationDelegate>)delegate;

-(void)getUserInvocation:(NSString*)userRollId Async:(BOOL)async delegate:(id<GetUserInvocationDelegate>)delegate;

-(void)getScheduleInvocation:(NSString*)userRollId CurrentDate:(NSString*)date Type:(NSString*)type delegate:(id<GetScheduleInvocationDelegate>)delegate;

-(void)getScheduleMoreActionInvocation:(NSString*)userRollId FromDate:(NSString*)dateFrom CurrentDate:(NSString*)date Type:(NSString*)type delegate:(id<GetScheduleInvocationDelegate>)delegate;

-(void)getSchedule2Invocation:(NSString*)userRollId SubTenantId:(NSString*)subTenId CurrentDate:(NSString*)date Type:(NSString*)type delegate:(id<GetScheduleInvocationDelegate>)delegate;

-(void)getAppointmentsInvocation:(NSString*)userRollId Time_Table_id:(NSString*)timeTableId Type:(NSString*)type delegate:(id<GetScheduleInvocationDelegate>)delegate;

-(void)getPatientInvocation:(NSString*)userRollId Searchkey:(NSString*)searchkey Sub_tenant_id:(NSString*)sub_tenant_id delegate:(id<GetPatientInvocationnDelegate>)delegate;

-(void)getConnonInvocation:(NSString*)type delegate:(id<GetConnonInvocationDelegate>)delegate;

-(void)getFreeSlotsInvocation:(NSString*)userRoleId TimeTableId:(NSString*)timeTableId delegate:(id<GetFreeSlotsInvocationDelegate>)delegate;

-(void)insertAppointmentInvocation:(NSNumber*)AppId AvailStatusId:(NSNumber*)AvlStatusId Mrno:(NSNumber*)mrno UserRollId:(NSString*)userRollId OthDetails:(NSString*)othDetails CurrentStatusId:(NSString*)currentStatusId AppNatureId:(NSString*)AppNatureId delegate:(id<InsertAppointmentDelegate>)delegate;

-(void)addPatientInvocation:(Patient*)pat UserRollId:(NSString*)userRollId SubTenantId:(NSString*)subtenantid delegate:(id<AddPatientInvocationDelegate>)delegate;

-(void)postMoveAppointmentInvocation:(NSString*)newAppId UserRoleId:(NSString*)userRollId OldAppId:(NSString*)oldAppId TimeTableId:(NSString*)timeTableId delegate:(id<PostMoveAppointmentDelegate>)delegate;

-(void)postUploadOrderTextInvocation:(NSString*)AppId AvlStatusId:(NSString*)AvlStatusId delegate:(id<PostUploadOrderTextDelegate>)delegate;

-(void)postAppointmentInvocation:(NSString*)type UserRollId:(NSString*)userRollId AppId:(NSNumber*)appId delegate:(id<PostAppointmentDelegate>)delegate;

-(void)getPatientContactInvocation:(NSString*)userRollId Contact_id:(NSString*)contactId delegate:(id<GetPatientContactDetailDelegate>)delegate;

-(void)getAllergyInvocation:(NSString*)userRollId delegate:(id<GetAllergyInvocationDelegate>)delegate;

-(void)getPatientDosageInvocation:(NSString*)userRollId delegate:(id<GetDosageInvocationDelegate>)delegate;

-(void)getDosageFromInvocation:(NSString*)userRollId delegate:(id<GetDosageFrmInvocationDelegate>)delegate;

-(void)getGenericInvocation:(NSString*)userRollId delegate:(id<GetGenericInvocationDelegate>)delegate;

-(void)getPharmacyInvocation:(NSString*)userRollId SchedulesId:(NSString*)str forType:(NSInteger)type delegate:(id<GetPharmacyInvocationDelegate>)delegate;

-(void)getLabInvocation:(NSString*)userRollId SchedulesId:(NSString*)schedulesId forType:(NSInteger)type delegate:(id<GetLabInvocationDelegate>)delegate;

-(void)getInstructionInvocation:(NSString*)userRollId delegate:(id<GetInstructionInvocationDelegate>)delegate;

-(void)getFollowUpInvocation:(NSString*)userRollId delegate:(id<GetFollowUpInvocationDelegate>)delegate;

-(void)getPatientAllergyInvocation:(NSString*)userRollId AllergyId:(NSString*)allergyId delegate:(id<GetPatientAllergyInvocationDelegate>)delegate;

-(void)getPatientVitalsInvocation:(NSString*)userRollId Mrno:(NSString*)mrno delegate:(id<GetPaientVitalsInvocationDelegate>)delegate;

-(void)getBrandsInvocation:(NSString*)userRollId GenericId:(NSString*)genericId delegate:(id<GetBrandInvocationDelegate>)delegate;
-(void)getBrandsIDInvocation:(NSString*)userRollId BrandId:(NSString*)brandId delegate:(id<GetBrandIDDelegate>)delegate;

-(void)getPatientComplaintsInvocation:(NSString*)userRollId RecordId:(NSString*)recordId delegate:(id<GetPatComplaintsInvocationDelegate>)delegate;

-(void)getPatMedRecordsInvocation:(NSString*)userRollId mrNo:(NSString*)mrNo subTenantId:(NSString*)subTenId delegate:(id<GetPatMedRecordsInvocationDelegate>)delegate;

-(void)getSeverityInvocationWithdelegate:(id<GetSeverityInvocationDelegate>)delegate;

-(void)getSubTenantIdInvocation:(NSString*)userRollId delegate:(id<GetSubtenIdInvocationDelegate>)delegate;

-(void)getSubTenantId2Invocation:(NSString*)userRollId SubTenantId:(NSString*)subTenId IsSecond:(BOOL)isSecond delegate:(id<GetSubtenIdInvocationDelegate>)delegate;

-(void)getLabPackageInvocation:(NSString*)userRollId SubTenantId:(NSString*)subTenantId delegate:(id<GetLabPackageInvocationDelegate>)delegate;

-(void)getLabGroupTestInvocation:(NSString*)userRollId PackageId:(NSString*)packageId delegate:(id<GetLabGroupTestInvocationDelegate>)delegate;

-(void)getLabTestListInvocation:(NSString*)userRollId PackageId:(NSString*)packageId GroupId:(NSString*)groupId delegate:(id<GetLabTestListInvocationDelegate>)delegate;

-(void)getLabOrPharmacyInvocation:(NSString*)userRoleId RecordId:(NSString*)recordId LabOrPharmacy:(BOOL)labOrPharmacy delegate:(id<GetLabOrPharmacyInvocationDelegate>)delegate;

-(void)getLabReportInvocation:(NSString*)userRoleId RecordId:(NSString*)recordId delegate:(id<GetLabReportInvocationDelegate>)delegate;

-(void)getVitalsInvocation:(NSString*)userRollId delegate:(id<GetVitalsInvocationDelegate>)delegate;

-(void)getNotesInvocation:(NSString*)userRoleId RecordId:(NSString*)recordId delegate:(id<GetNotesInvocationDelegate>)delegate;

-(void)getTemplateInvocation:(NSString*)userRoleId TemplateId:(NSString*)templateId TemplateOrMedicine:(BOOL)templateOrMedicine delegate:(id<GetTemplateInvocationDelegate>)delegate;

-(void)getMedRecNatureInvocationWithdelegate:(id<GetSeverityInvocationDelegate>)delegate;

-(void)getCurrentVisitFileInvocation:(NSString*)userRoleId Mrno:(NSString*)mrno delegate:(id<GetCurrentVisitFileInvocationDelegate>)delegate;

-(void)getDoctorReferralInvocation:(NSString*)userRollId SubTenantId:(NSString*)subTenantId delegate:(id<GetDoctorReferralInvocationDelegate>)delegate;

-(void)getPatientHealthInvocation:(NSString*)userRollId Mrno:(BOOL)conditionOrType delegate:(id<GetPatientHealthInvocationDelegate>)delegate;

-(void)getDocConOrAddInvocation:(NSString*)userRoleId AddrOrContId:(NSString*)addrOrContId AddrOrCont:(BOOL)addrOrCont delegate:(id<GetDocAddrOrContInvocationDelegate>)delegate;

-(void)getStringResponseInvocation:(NSString*)urlString Identifier:(NSString*)identifier delegate:(id<GetStringInvocationDelegate>)delegate;

-(void)getDrugIndexInvocation:(NSInteger)GenericId BrandId:(NSInteger)brandId Type:(NSInteger)type delegate:(id<GetDrugIndexInvocationDelegate>)delegate;

@end

