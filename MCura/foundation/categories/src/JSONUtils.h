//
//  JSONUtils.h
//  IdeaScale
//
//  Created by Jeremy Przasnyski on 1/3/11.
//  Copyright 2011 Cavoort, LLC. All rights reserved.
//

@class ISO8601DateFormatter;

@interface JSONUtils : NSObject { }
+(ISO8601DateFormatter*)timeFormatter;
+(NSDateFormatter*)dateFormatter;
+(NSDate*)dateFromTimeString:(NSString*)string;
+(NSDate*)dateFromDateString:(NSString*)string;
+(NSString*)dateString:(NSDate*)date;
+(NSString*)timeString:(NSDate*)time;
//+(NSString*)newwuid;
@end
