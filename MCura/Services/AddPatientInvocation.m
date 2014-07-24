//
//  AddPatientInvocation.m
//  3GMDoc

#import "AddPatientInvocation.h"
#import "JSON.h"
#import "Patient.h"
#import "PatientContactDetails.h"
#import "PatientAddress.h"

@interface AddPatientInvocation (private)
-(NSString*)body;
@end

@implementation AddPatientInvocation

@synthesize pat, userRollId, subTenantId, addressId, contactId, imagePathId;

int request_num;

-(void)dealloc {
	[super dealloc];
}

-(void)invoke {
	
	request_num = 1;
    
    NSString *a= [NSString stringWithFormat:@"%@PostAddress",[DataExchange getbaseUrl]];
    
	[self post:a body:[self body]];
}

- (void) postContactDetail{

	request_num = 2;
    
    NSString *a= [NSString stringWithFormat:@"%@PostContactDetails",[DataExchange getbaseUrl]];
    
	[self post:a body:[self body]];

}

- (void) postPatientDetail{

	request_num = 3;
    
    NSString *a= [NSString stringWithFormat:@"%@PostPatient2",[DataExchange getbaseUrl]];
    
	[self post:a body:[self body]];

}

-(NSString*)body {
    	
	PatientContactDetails *patCont = [self.pat.PatientContactDetails objectAtIndex:0];
	PatientAddress *patAdrs = [self.pat.PatientAddress objectAtIndex:0];
	NSString *bodyData = nil;
	
	if(request_num == 1){
		
		bodyData = [NSString stringWithFormat:@"{\"_add\":{\"Address1\":\"%@\",\"Address2\":\"%@\",\"AreaId\":%d,\"Zipcode\":\"%@\"},\"UserRoleID\":%@}", patAdrs.Address1, patAdrs.Address2,[patAdrs.AreaId integerValue],patAdrs.Zipcode, self.userRollId];
	}
	else if(request_num == 2){
		
		bodyData = [NSString stringWithFormat:@"{\"cd\":{\"Mobile\":\"%@\",\"Optmobile\":\"%@\",\"FixLine\":\"%@\",\"FixLineExtn\":\"\",\"Skypeid\":\"\",\"Email\":\"%@\",\"Optemail\":\"\"},\"UserRoleID\":%@}",patCont.Mobile, patCont.Optmobile, patCont.FixLine, patCont.Email, self.userRollId];
    }
	else if(request_num == 3){
		
		bodyData = [NSString stringWithFormat:@"{\"Pt\":{\"Patname\":\"%@\",\"Dob\":\"%@\",\"GenderId\":%@,\"AddressId\":%@,\"ContactId\":%@},\"UserRoleID\":\"%@\",\"sub_tenant_id\":\"%@\",\"EntryTypeId\":\"1\",\"RecNatureId\":\"1\",\"ImagePathId\":\"0\"}", self.pat.Patname, self.pat.dob, [self.pat.GenderId stringValue],  self.addressId, self.contactId, self.userRollId, self.subTenantId];
		
  }
    return [bodyData stringByReplacingOccurrencesOfString:@"\\u00a0" withString:@""];
	
}

-(BOOL)handleHttpOK:(NSMutableData *)data {
    NSString* str = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    if([str rangeOfString:@"Input string was not"].location!=NSNotFound){
        [self.delegate addPatientInvocationDidFinish:self withPatDemoId:@"" withError:[NSError errorWithDomain:@"Patient" code:[[self response] statusCode] userInfo:[NSDictionary dictionaryWithObject:@"Post comment failed. Incorrect Data entered" forKey:@"message"]]];
        return YES;
    }
	if([data length] > 0){
        if(request_num == 1){
			[self postContactDetail];
		}
		else if(request_num == 2){
				
			NSString *res = [[[NSString alloc] initWithData:data
												encoding:NSUTF8StringEncoding] autorelease];
		
			NSArray *splitRes = [res componentsSeparatedByString:@"\"\""];
			
			self.addressId = [[splitRes objectAtIndex:0] stringByReplacingOccurrencesOfString:@"\"" withString:@""];
			self.contactId = [[splitRes objectAtIndex:1] stringByReplacingOccurrencesOfString:@"\"" withString:@""];
			[self postPatientDetail];
		}
        else if(request_num == 3){
            NSString* patDemoId = [[[str componentsSeparatedByString:@"\"\""] objectAtIndex:2] stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            NSLog(@"%@,%@",str,patDemoId);
            Patient* temp = [DataExchange getAddPatient];
            if(!temp.MRNO){
                NSInteger mrno=0;
                str = [str substringToIndex:(str.length-1)];
                str = [str substringFromIndex:1];
                NSArray* strings = [str componentsSeparatedByString:@"\"\""];
                mrno = [[strings objectAtIndex:2] integerValue];
                temp.AddressId = [NSNumber numberWithInt:[self.addressId integerValue]];
                temp.ContactId = [NSNumber numberWithInt:[self.contactId integerValue]];
                temp.MRNO = [NSNumber numberWithInt:mrno];
                [DataExchange setAddPatient:temp];
            }
            [self.delegate addPatientInvocationDidFinish:self withPatDemoId:patDemoId withError:nil];
        }
    }
	
	return YES;
}

-(BOOL)handleHttpError:(NSInteger)code {
	
	[self.delegate addPatientInvocationDidFinish:self withPatDemoId:@"" withError:[NSError errorWithDomain:@"Patient" code:[[self response] statusCode] userInfo:[NSDictionary dictionaryWithObject:@"Post comment failed. Please try again later" forKey:@"message"]]];
	return YES;
}

@end

