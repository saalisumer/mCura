//
//  _GMDocService.m

#import "_GMDocService.h"


@implementation _GMDocService

-(id)retain {	
	return [super retain];
}

-(void)dealloc {	
	[super dealloc];
}

#pragma mark -
#pragma mark Invocations


-(void)GetTabletInvocation:(NSString*)serialNo delegate:(id<GetTabletInvocationDelegate>)delegate{
	GetTabletInvocation *invocation = [[[GetTabletInvocation alloc] init] autorelease];
	invocation.serialNo = serialNo;
	[self invoke:invocation withDelegate:delegate];
}

-(void)getLoginInvocation:(NSString*)username Password:(NSString*)password Type:(NSString*)type delegate:(id<GetLoginInvocationDelegate>)delegate{
    GetLoginInvocation *invocation = [[[GetLoginInvocation alloc] init] autorelease];
    invocation.username = username;
    invocation.password = password;
    invocation.type = type;
    [self invoke:invocation withDelegate:delegate];
}

-(void)getUserInvocation:(NSString*)userRollId Async:(BOOL)async delegate:(id<GetUserInvocationDelegate>)delegate{
    GetUserInvocation *invocation = [[[GetUserInvocation alloc] init] autorelease];
    invocation.async = async;
    invocation.userRollId = userRollId;
    [self invoke:invocation withDelegate:delegate];
}

-(void)getScheduleInvocation:(NSString*)userRollId CurrentDate:(NSString*)date Type:(NSString*)type delegate:(id<GetScheduleInvocationDelegate>)delegate{
    GetScheduleInvocation *invocation = [[[GetScheduleInvocation alloc] init] autorelease];
    invocation.userRollId = userRollId;
    invocation.currentDate = date;
    invocation.type = type;
    [self invoke:invocation withDelegate:delegate];
}

-(void)getScheduleMoreActionInvocation:(NSString*)userRollId FromDate:(NSString*)dateFrom CurrentDate:(NSString*)date Type:(NSString*)type delegate:(id<GetScheduleInvocationDelegate>)delegate{
    GetScheduleInvocation *invocation = [[[GetScheduleInvocation alloc] init] autorelease];
    invocation.userRollId = userRollId;
    invocation.fromDate = dateFrom;
    invocation.currentDate = date;
    invocation.type = type;
    [self invoke:invocation withDelegate:delegate];
}

-(void)getSchedule2Invocation:(NSString*)userRollId SubTenantId:(NSString*)subTenId CurrentDate:(NSString*)date Type:(NSString*)type delegate:(id<GetScheduleInvocationDelegate>)delegate{
    GetScheduleInvocation *invocation = [[[GetScheduleInvocation alloc] init] autorelease];
    invocation.userRollId = userRollId;
    invocation.subTenId = subTenId;
    invocation.currentDate = date;
    invocation.type = type;
    [self invoke:invocation withDelegate:delegate];
}

-(void)getAppointmentsInvocation:(NSString*)userRollId Time_Table_id:(NSString*)timeTableId Type:(NSString*)type delegate:(id<GetScheduleInvocationDelegate>)delegate{
    GetScheduleInvocation *invocation = [[[GetScheduleInvocation alloc] init] autorelease];
    invocation.userRollId = userRollId;
    invocation.time_table_id = timeTableId;
    invocation.type = type;
    [self invoke:invocation withDelegate:delegate];
}

-(void)getPatientInvocation:(NSString*)userRollId Searchkey:(NSString*)searchkey Sub_tenant_id:(NSString*)sub_tenant_id delegate:(id<GetPatientInvocationnDelegate>)delegate{
    GetPatientInvocation *invocation = [[[GetPatientInvocation alloc] init] autorelease];
    invocation.userRollId = userRollId;
    invocation.searchkey = searchkey;
    invocation.sub_tenant_id = sub_tenant_id;
    [self invoke:invocation withDelegate:delegate];
}

-(void)getConnonInvocation:(NSString*)type delegate:(id<GetConnonInvocationDelegate>)delegate{
    GetConnonInvocation *invocation = [[[GetConnonInvocation alloc] init] autorelease];
    invocation.type = type;
    [self invoke:invocation withDelegate:delegate];
}

-(void)getFreeSlotsInvocation:(NSString*)userRoleId TimeTableId:(NSString*)timeTableId delegate:(id<GetFreeSlotsInvocationDelegate>)delegate{
    GetFreeSlotsInvocation* invocation = [[[GetFreeSlotsInvocation alloc] init] autorelease];
    invocation.userRoleId = userRoleId;
    invocation.timeTableId = timeTableId;
    [self invoke:invocation withDelegate:delegate];
}

-(void)insertAppointmentInvocation:(NSNumber*)AppId AvailStatusId:(NSNumber*)AvlStatusId Mrno:(NSNumber*)mrno UserRollId:(NSString*)userRollId OthDetails:(NSString*)othDetails CurrentStatusId:(NSString*)currentStatusId AppNatureId:(NSString*)AppNatureId delegate:(id<InsertAppointmentDelegate>)delegate{
    InsertAppointmentInvocation *invocation = [[[InsertAppointmentInvocation alloc] init] autorelease];
    invocation.AppId = AppId;
    invocation.AvlStatusId = AvlStatusId;
    invocation.mrno = mrno;
    invocation.userRollId = userRollId;
    invocation.othDetails = othDetails;
    invocation.currentStatusId = currentStatusId;
    invocation.AppNatureId = AppNatureId;
    [self invoke:invocation withDelegate:delegate];
}

-(void)addPatientInvocation:(Patient*)pat UserRollId:(NSString*)userRollId SubTenantId:(NSString*)subtenantid delegate:(id<AddPatientInvocationDelegate>)delegate{
    AddPatientInvocation *invocation = [[[AddPatientInvocation alloc] init] autorelease];
    invocation.pat = pat;
	invocation.userRollId = userRollId;
    invocation.subTenantId = subtenantid;
	[self invoke:invocation withDelegate:delegate];
}

-(void)postUploadOrderTextInvocation:(NSString*)AppId AvlStatusId:(NSString*)AvlStatusId delegate:(id<PostUploadOrderTextDelegate>)delegate{
    PostUploadOrderTextInvocation *invocation = [[[PostUploadOrderTextInvocation alloc] init] autorelease];
    invocation.AppId = AppId;
    invocation.AvlStatusId = AvlStatusId;
    [self invoke:invocation withDelegate:delegate];

}

-(void)postMoveAppointmentInvocation:(NSString*)newAppId UserRoleId:(NSString*)userRollId OldAppId:(NSString*)oldAppId TimeTableId:(NSString*)timeTableId delegate:(id<PostMoveAppointmentDelegate>)delegate{
    PostMoveAppointmentInvocation *invocation = [[[PostMoveAppointmentInvocation alloc] init] autorelease];
    invocation.oldAppId = oldAppId;
    invocation.NewAppId = newAppId;
    invocation.userRollId = userRollId;
    invocation.TimeTableId = timeTableId;
    [self invoke:invocation withDelegate:delegate];
}

-(void)postAppointmentInvocation:(NSString*)type UserRollId:(NSString*)userRollId AppId:(NSNumber*)appId delegate:(id<PostAppointmentDelegate>)delegate{
    PostAppointmentInvocation *invocation = [[[PostAppointmentInvocation alloc] init] autorelease];
    invocation.type = type;
    invocation.AppId = appId;
    invocation.userRollId = userRollId;
    [self invoke:invocation withDelegate:delegate];
}

-(void)getPatientContactInvocation:(NSString*)userRollId Contact_id:(NSString*)contactId delegate:(id<GetPatientContactDetailDelegate>)delegate{
    GetPatientContactDetail *invocation = [[[GetPatientContactDetail alloc] init] autorelease];
    invocation.contactId = contactId;
    invocation.userRollId = userRollId;
    [self invoke:invocation withDelegate:delegate];
}

-(void)getAllergyInvocation:(NSString*)userRollId delegate:(id<GetAllergyInvocationDelegate>)delegate{
    GetAllergyInvocation *invocation = [[[GetAllergyInvocation alloc] init] autorelease];
    invocation.userRollId = userRollId;
    [self invoke:invocation withDelegate:delegate];
}

-(void)getPatientDosageInvocation:(NSString*)userRollId delegate:(id<GetDosageInvocationDelegate>)delegate{
    GetDosageInvocation *invocation = [[[GetDosageInvocation alloc] init] autorelease];
    invocation.userRollId = userRollId;
    [self invoke:invocation withDelegate:delegate];
}

-(void)getDosageFromInvocation:(NSString*)userRollId delegate:(id<GetDosageFrmInvocationDelegate>)delegate{
    GetDosageFrmInvocation *invocation = [[[GetDosageFrmInvocation alloc] init] autorelease];
    invocation.userRollId = userRollId;
    [self invoke:invocation withDelegate:delegate];
}

-(void)getGenericInvocation:(NSString*)userRollId delegate:(id<GetGenericInvocationDelegate>)delegate{
    GetGenericInvocation *invocation = [[[GetGenericInvocation alloc] init] autorelease];
    invocation.userRollId = userRollId;
    [self invoke:invocation withDelegate:delegate];
}

-(void)getPharmacyInvocation:(NSString*)userRollId SchedulesId:(NSString*)str forType:(NSInteger)type delegate:(id<GetPharmacyInvocationDelegate>)delegate{
    GetPharmacyInvocation *invocation = [[[GetPharmacyInvocation alloc] init] autorelease];
    invocation.schedulesID = str;
    invocation.type = type;
    invocation.userRollId = userRollId;
    [self invoke:invocation withDelegate:delegate];
}

-(void)getLabInvocation:(NSString*)userRollId SchedulesId:(NSString*)schedulesId forType:(NSInteger)type delegate:(id<GetLabInvocationDelegate>)delegate{
    GetLabInvocation *invocation = [[[GetLabInvocation alloc] init] autorelease];
    invocation.userRollId = userRollId;
    invocation.type = type;
    invocation.schedulesId = schedulesId;
    [self invoke:invocation withDelegate:delegate];
}

-(void)getInstructionInvocation:(NSString*)userRollId delegate:(id<GetInstructionInvocationDelegate>)delegate{
    GetInstructionInvocation *invocation = [[[GetInstructionInvocation alloc] init] autorelease];
    invocation.userRollId = userRollId;
    [self invoke:invocation withDelegate:delegate];
}

-(void)getFollowUpInvocation:(NSString*)userRollId delegate:(id<GetFollowUpInvocationDelegate>)delegate{
    GetFollowUpInvocation *invocation = [[[GetFollowUpInvocation alloc] init] autorelease];
    invocation.userRollId = userRollId;
    [self invoke:invocation withDelegate:delegate];
}

-(void)getPatientAllergyInvocation:(NSString*)userRollId AllergyId:(NSString*)allergyId delegate:(id<GetPatientAllergyInvocationDelegate>)delegate{
    GetPatientAllergyInvocation *invocation = [[[GetPatientAllergyInvocation alloc] init] autorelease];
    invocation.userRollId = userRollId;
    invocation.allergyId = allergyId;
    [self invoke:invocation withDelegate:delegate];
}

-(void)getPatientHealthInvocation:(NSString*)userRollId Mrno:(BOOL)conditionOrType delegate:(id<GetPatientHealthInvocationDelegate>)delegate{
    GetPatientHealthInvocation *invocation = [[[GetPatientHealthInvocation alloc] init] autorelease];
    invocation.userRollId = userRollId;
    invocation.conditionOrType = conditionOrType;
    [self invoke:invocation withDelegate:delegate];
}

-(void)getPatientVitalsInvocation:(NSString*)userRollId Mrno:(NSString*)mrno delegate:(id<GetPaientVitalsInvocationDelegate>)delegate{
    GetPaientVitalsInvocation *invocation = [[[GetPaientVitalsInvocation alloc] init] autorelease];
    invocation.userRollId = userRollId;
    invocation.mrno = mrno;
    [self invoke:invocation withDelegate:delegate];
}

-(void)getBrandsInvocation:(NSString*)userRollId GenericId:(NSString*)genericId delegate:(id<GetBrandInvocationDelegate>)delegate{
    GetBrandInvocation *invocation = [[[GetBrandInvocation alloc] init] autorelease];
    invocation.userRollId = userRollId;
    invocation.genericId = genericId;
    [self invoke:invocation withDelegate:delegate];
}
-(void)getBrandsIDInvocation:(NSString*)userRollId BrandId:(NSString*)brandId delegate:(id<GetBrandIDDelegate>)delegate{
    GetBrandIDInvocation *invocation = [[[GetBrandIDInvocation alloc] init] autorelease];
    invocation.userRollId = userRollId;
    invocation.brandId = brandId;
    [self invoke:invocation withDelegate:delegate];
    
    
}
-(void)getPatientComplaintsInvocation:(NSString*)userRollId RecordId:(NSString*)recordId delegate:(id<GetPatComplaintsInvocationDelegate>)delegate{
    GetPatComplaints *invocation = [[[GetPatComplaints alloc] init] autorelease];
    invocation.userRoleId = userRollId;
    invocation.RecordId = recordId;
    [self invoke:invocation withDelegate:delegate];
}

-(void)getPatMedRecordsInvocation:(NSString*)userRollId mrNo:(NSString*)mrNo subTenantId:(NSString*)subTenId delegate:(id<GetPatMedRecordsInvocationDelegate>)delegate{
    GetPatMedRecords *invocation = [[[GetPatMedRecords alloc] init] autorelease];
    invocation.UserRoleID = userRollId;
    invocation.MRNO = mrNo;
    invocation.subTenantId = subTenId;
    [self invoke:invocation withDelegate:delegate];
}

-(void)getSeverityInvocationWithdelegate:(id<GetSeverityInvocationDelegate>)delegate{
    GetSeverityInvocation *invocation = [[[GetSeverityInvocation alloc] init] autorelease];
    [self invoke:invocation withDelegate:delegate];    
}

-(void)getSubTenantIdInvocation:(NSString*)userRollId delegate:(id<GetSubtenIdInvocationDelegate>)delegate{
    GetSubtenIdInvocation* invocation = [[[GetSubtenIdInvocation alloc] init] autorelease];
    invocation.userRoleId = userRollId;
    [self invoke:invocation withDelegate:delegate];
}

-(void)getSubTenantId2Invocation:(NSString*)userRollId SubTenantId:(NSString*)subTenId IsSecond:(BOOL)isSecond delegate:(id<GetSubtenIdInvocationDelegate>)delegate{
    GetSubtenIdInvocation* invocation = [[[GetSubtenIdInvocation alloc] init] autorelease];
    invocation.userRoleId = userRollId;
    invocation.subTenantId = subTenId;
    invocation.isSecondService = isSecond;
    [self invoke:invocation withDelegate:delegate];
}

-(void)getLabPackageInvocation:(NSString*)userRollId SubTenantId:(NSString*)subTenantId delegate:(id<GetLabPackageInvocationDelegate>)delegate{
    GetLabPackageInvocation *invocation = [[[GetLabPackageInvocation alloc] init] autorelease];
    invocation.userRoleId = userRollId;
    invocation.subTenId = subTenantId;
    [self invoke:invocation withDelegate:delegate];
}

-(void)getLabGroupTestInvocation:(NSString*)userRollId PackageId:(NSString*)packageId delegate:(id<GetLabGroupTestInvocationDelegate>)delegate{
    GetLabGroupTestInvocation *invocation = [[[GetLabGroupTestInvocation alloc] init] autorelease];
    invocation.userRoleId = userRollId;
    invocation.packageId = packageId;
    [self invoke:invocation withDelegate:delegate];
}

-(void)getLabTestListInvocation:(NSString*)userRollId PackageId:(NSString*)packageId GroupId:(NSString*)groupId delegate:(id<GetLabTestListInvocationDelegate>)delegate{
    GetLabTestListInvocation *invocation = [[[GetLabTestListInvocation alloc] init] autorelease];
    invocation.userRoleId = userRollId;
    invocation.labGrpId = groupId;
    invocation.packageId = packageId;
    [self invoke:invocation withDelegate:delegate];
}

-(void)getLabOrPharmacyInvocation:(NSString*)userRoleId RecordId:(NSString*)recordId LabOrPharmacy:(BOOL)labOrPharmacy delegate:(id<GetLabOrPharmacyInvocationDelegate>)delegate{
    GetLabOrPharmacyInvocation *invocation = [[[GetLabOrPharmacyInvocation alloc] init] autorelease];
    invocation.labOrPharmacy = labOrPharmacy;
    invocation.userRoleId = userRoleId;
    invocation.recordId = recordId;
    [self invoke:invocation withDelegate:delegate];
}

-(void)getLabReportInvocation:(NSString*)userRoleId RecordId:(NSString*)recordId delegate:(id<GetLabReportInvocationDelegate>)delegate{
    GetLabReportInvocation *invocation = [[[GetLabReportInvocation alloc] init] autorelease];
    invocation.userRoleId = userRoleId;
    invocation.recordId = recordId;
    [self invoke:invocation withDelegate:delegate];
}

-(void)getVitalsInvocation:(NSString*)userRollId delegate:(id<GetVitalsInvocationDelegate>)delegate{
    GetVitalsInvocation *invocation = [[[GetVitalsInvocation alloc] init] autorelease];
    invocation.userRoleId = userRollId;
    [self invoke:invocation withDelegate:delegate];
}

-(void)getNotesInvocation:(NSString*)userRoleId RecordId:(NSString*)recordId delegate:(id<GetNotesInvocationDelegate>)delegate{
    GetNotesInvocation *invocation = [[[GetNotesInvocation alloc] init] autorelease];
    invocation.userRoleId = userRoleId;
    invocation.recordId = recordId;
    [self invoke:invocation withDelegate:delegate];
}

-(void)getTemplateInvocation:(NSString*)userRoleId TemplateId:(NSString*)templateId TemplateOrMedicine:(BOOL)templateOrMedicine delegate:(id<GetTemplateInvocationDelegate>)delegate{
    GetTemplateInvocation *invocation = [[[GetTemplateInvocation alloc] init] autorelease];
    invocation.userRoleId = userRoleId;
    invocation.templateOrMedicine = templateOrMedicine;
    invocation.templateId = templateId;
    [self invoke:invocation withDelegate:delegate];
}

-(void)getMedRecNatureInvocationWithdelegate:(id<GetSeverityInvocationDelegate>)delegate{
    GetMedRecNatureInvocation *invocation = [[[GetMedRecNatureInvocation alloc] init] autorelease];
    [self invoke:invocation withDelegate:delegate]; 
}

-(void)getCurrentVisitFileInvocation:(NSString*)userRoleId Mrno:(NSString*)mrno delegate:(id<GetCurrentVisitFileInvocationDelegate>)delegate{
    GetCurrentVisitFileInvocation *invocation = [[[GetCurrentVisitFileInvocation alloc] init] autorelease];
    invocation.userRoleId = userRoleId;
    invocation.mrNo = mrno;
    [self invoke:invocation withDelegate:delegate];
}

-(void)getDoctorReferralInvocation:(NSString*)userRollId SubTenantId:(NSString*)subTenantId delegate:(id<GetDoctorReferralInvocationDelegate>)delegate{
    GetDoctorReferralInvocation *invocation = [[[GetDoctorReferralInvocation alloc] init] autorelease];
    invocation.userRoleId = userRollId;
    invocation.subTenId = subTenantId;
    [self invoke:invocation withDelegate:delegate];
}

-(void)getDocConOrAddInvocation:(NSString*)userRoleId AddrOrContId:(NSString*)addrOrContId AddrOrCont:(BOOL)addrOrCont delegate:(id<GetDocAddrOrContInvocationDelegate>)delegate{
    GetDocAddrOrContInvocation* invocation = [[[GetDocAddrOrContInvocation alloc] init] autorelease];
    invocation.userRoleId = userRoleId;
    invocation.addressOrContactId = addrOrContId;
    invocation.addressOrContact = addrOrCont;
    [self invoke:invocation withDelegate:delegate];
}

-(void)getStringResponseInvocation:(NSString*)urlString Identifier:(NSString*)identifier delegate:(id<GetStringInvocationDelegate>)delegate{
    GetStringInvocation* invocation = [[[GetStringInvocation alloc] init] autorelease];
    invocation.urlString = urlString;
    invocation.identifier = identifier;
    [self invoke:invocation withDelegate:delegate];
}

-(void)getDrugIndexInvocation:(NSInteger)GenericId BrandId:(NSInteger)brandId Type:(NSInteger)type delegate:(id<GetDrugIndexInvocationDelegate>)delegate{
    GetDrugIndexInvocation* invocation = [[[GetDrugIndexInvocation alloc] init] autorelease];
    invocation.genericId = GenericId;
    invocation.brandId = brandId;
    invocation.type = type;
    [self invoke:invocation withDelegate:delegate];
}

@end
