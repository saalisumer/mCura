//
//  JSONUtils.m
//  IdeaScale
//
//  Created by Jeremy Przasnyski on 1/3/11.
//  Copyright 2011 Cavoort, LLC. All rights reserved.
//

#import "JSONUtils.h"
#import "ISO8601DateFormatter.h"

ISO8601DateFormatter* gJSONUtilsTimeFormatter = nil;
NSDateFormatter* gJSONUtilsDateFormatter = nil;
@implementation JSONUtils
+(ISO8601DateFormatter*)timeFormatter {
	if (!gJSONUtilsTimeFormatter) {
		gJSONUtilsTimeFormatter = [[ISO8601DateFormatter alloc] init];
		[gJSONUtilsTimeFormatter setIncludeTime:YES];
		[gJSONUtilsTimeFormatter setDefaultTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
	}
	return gJSONUtilsTimeFormatter;
}
+(NSDateFormatter*)dateFormatter {
	if (!gJSONUtilsDateFormatter) {
		gJSONUtilsDateFormatter = [[NSDateFormatter alloc] init];
		[gJSONUtilsDateFormatter setDateFormat:@"yyyy-MM-dd"];
	}
	return gJSONUtilsDateFormatter;
}
+(NSDate*)dateFromTimeString:(NSString*)string {
	return [[JSONUtils timeFormatter] dateFromString:string];
}
+(NSDate*)dateFromDateString:(NSString*)string {
	return [[JSONUtils dateFormatter] dateFromString:string];
}
+(NSString*)dateString:(NSDate*)date {
	return [[JSONUtils dateFormatter] stringFromDate:date];
}
+(NSString*)timeString:(NSDate*)time {
	return [[JSONUtils timeFormatter] stringFromDate:time];
}
/*
+(NSString*)newwuid {
	CFUUIDRef newuuid = CFUUIDCreate(NULL);
	NSString* newuuidstr = (NSString*)CFUUIDCreateString(NULL,newuuid);
	CFRelease(newuuid);
	return newuuidstr;
}
 */
@end