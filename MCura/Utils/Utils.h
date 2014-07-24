//
//  Utils.h
//  3GMDoc

#import <Foundation/Foundation.h>

@interface Utils : NSObject

+(void)showAlert:(NSString*)msg Title:(NSString *)title;
+(BOOL)textFieldValidation:(UITextField *)textField label:(NSString *)name;
+(BOOL)isConnectedToNetwork;
+(NSDate *)convertStringToDate:(NSString *)dateStr;
+(NSInteger)age:(NSDate *)dateOfBirth;

@end
