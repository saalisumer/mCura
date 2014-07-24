//
//  Utilities.h
//  3GMDoc
//
//  Created by Saffron Tech on 14/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Utilities : NSObject {
    
}
+(void)setHeader:(UIView *)view andTitle:(NSString *)titleStr;
+(NSString *)baseURL;
+(BOOL)isConnectedToNetwork;
+(NSString *) urlEncode: (NSString *) url;
+(NSString *)urlRemoveWhiteSpace: (NSString *) url;
+(void)setFooter:(UIView *)view andImage:(UIImage *)footerImg;
+(BOOL)textFieldValidation:(UITextField *)textField label:(NSString *)name;
+(NSMutableString *)getSoapMessage:(NSString *)body;
+(BOOL)textViewValidation:(UITextView *)textView label:(NSString *)name;
+(BOOL)emailValidation:(UITextField *)textField label:(NSString *)email;
+(NSString *)currentDate;
+(NSString *)current_Date;
//+(NSString *)getDeviceID;
+(UIImage*) resizedImage:(UIImage *)inImage andRect:(CGRect)thumbRect;
/* +(NSString *)financialYear;
 +(void)loginAlert;

 +(BOOL)isCalender;
 +(void)sessionAlert;
 
 +(NSMutableString *)getSoapMessage:(NSString *)body;
 +(NSMutableArray *)GetCountryFromDatabase;
 +(NSString *)GetConnectToDatabase;*/
+(NSDate *)convertStringToDate:(NSString *)dateStr;
+(NSInteger)age:(NSDate *)dateOfBirth;
@end
