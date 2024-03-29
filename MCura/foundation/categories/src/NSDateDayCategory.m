//
//  NSDateDayCategory.m
//  MeasureMe
//
//  Created by Jeremy Przasnyski on 3/25/09.
//  Copyright 2009 Cavoort, LLC. All rights reserved.
//
#import "NSDateDayCategory.h"

@implementation NSDate (Day)

NSDateFormatter* _dayOfWeFormatter;
NSDateFormatter* _dayOfMoFormatter;

+(NSDate*)today {
	return [(NSDate*)[NSDate date] day];
}

+(NSDateFormatter*)dayOfWeFormatter {
	if (!_dayOfWeFormatter) {
		_dayOfWeFormatter = [[NSDateFormatter alloc] init];
		[_dayOfWeFormatter setDateFormat:@"EEE"];
	}
	return _dayOfWeFormatter;
}

+(NSDateFormatter*)dayOfMoFormatter {
	if (!_dayOfMoFormatter) {
		_dayOfMoFormatter = [[NSDateFormatter alloc] init];
		[_dayOfMoFormatter setDateFormat:@"dd"];
	}
	return _dayOfMoFormatter;
}

-(NSDate*)day {
	NSDateComponents *dc = [[NSCalendar currentCalendar] 
							components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit 
							  fromDate:self];
	return [[NSCalendar currentCalendar] dateFromComponents:dc];
}

-(NSDate*)deltaDays:(NSInteger)deltaDays {
	// 43200 = 12hrs * 60 mins/hr * 60 secs/min
	NSDate* noonish = [[[NSDate alloc] initWithTimeInterval:43200 sinceDate:[self day]] autorelease];
	// 86400 = 1 day * 24 hrs/day * 60 mins/hr * 60 secs/min 
//	NSDate* noonishOnTargetDay = [noonish addTimeInterval:(NSTimeInterval)(deltaDays * 86400)];
		NSDate* noonishOnTargetDay = [noonish dateByAddingTimeInterval:(NSTimeInterval)(deltaDays * 86400)];
	return [noonishOnTargetDay day];
}

-(NSString*)localizedShortDateString {
	CFLocaleRef locale = CFLocaleCopyCurrent();
	CFDateFormatterRef formatter = CFDateFormatterCreate(NULL,locale,kCFDateFormatterShortStyle,kCFDateFormatterNoStyle);
	CFStringRef formatted = CFDateFormatterCreateStringWithDate(NULL,formatter,(CFDateRef)self);
	CFRelease(locale);
	CFRelease(formatter);
	NSString* string = (NSString*)formatted;
	CFRelease(formatted);
	return string;
}

-(NSString*)localizedDayOfWeekString {
	return [[NSDate dayOfWeFormatter] stringFromDate:self];
}

-(NSString*)dayOfMonthString {
	return [[NSDate dayOfMoFormatter] stringFromDate:self];
}

-(NSInteger)deltaDate:(NSDate*)from {
	NSCalendar* cal = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
	NSDateComponents* comps = [cal components:(NSDayCalendarUnit) fromDate:from toDate:self options:0];
	NSInteger delta = [comps day];
	
	return delta;
}

@end

