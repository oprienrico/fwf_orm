//
//  FWF
//  generic utils
//
//  Created by Enrico Opri.
//  Copyright (c) 2013 Enrico Opri. All rights reserved.
//

#import "DateUtils.h"


@implementation NSDate (TimeConversion_Varius)

+ (NSDate *) dateFromString:(NSString *) dateString withFormat:(NSString *) format{
    // Convert string to date object
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    
    return [dateFormatter dateFromString:dateString];    
}

+ (NSDate *) dateFromUTCString:(NSString *) dateString withFormat:(NSString *) format{
    // Convert string to date object
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    //setting to UTC
    /*NSTimeZone *timeZone = [NSTimeZone timeZoneForSecondsFromGMT:-[[NSTimeZone localTimeZone] secondsFromGMT]];
    NSLog(@"local time zone %@", timeZone);
	[dateFormatter setTimeZone:timeZone];*/
    
    NSLog(@"retrieved date string %@", dateString);
    NSLog(@"converted date: %@", [dateFormatter dateFromString:dateString]);
    [dateFormatter dateFromString:dateString];
    return [dateFormatter dateFromString:dateString];
}

+ (NSDate *) dateFromUTCStringWithStandardFormat:(NSString *) dateString{
    return [[self class] dateFromUTCString:dateString withFormat:[[self class] STANDARD_DATE_FORMAT]];
}

- (NSString *) stringUTCValueWithFormat:(NSString *) format{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:format];
    /*NSTimeZone *timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
	[dateFormatter setTimeZone:timeZone];*/
    
	NSString *formattedDateString = [dateFormatter stringFromDate:self];
    return formattedDateString;
}

- (NSString *) stringUTCValueWithStandardFormat{
    NSLog(@"to string value %@", [self stringUTCValueWithFormat:[[self class] STANDARD_DATE_FORMAT]]);
    return [self stringUTCValueWithFormat:[[self class] STANDARD_DATE_FORMAT]];
}

+ (NSString *) STANDARD_DATE_FORMAT{
    return @"yyyy-MM-dd HH:mm:ss.SSSSZ";
}

/////////////
//  c_Like
/////////////

+ (NSDate *)dateFromISO8601String:(NSString *)string {
    if (!string) {
        return nil;
    }
    
    struct tm tm;
    time_t t;    
    
    strptime([string cStringUsingEncoding:NSUTF8StringEncoding], "%Y-%m-%dT%H:%M:%S%z", &tm);
    tm.tm_isdst = -1;
    t = mktime(&tm);
    
    return [NSDate dateWithTimeIntervalSince1970:(t + [[NSTimeZone localTimeZone] secondsFromGMT])];
}

- (NSString *)ISO8601String {
    struct tm *timeinfo;
    char buffer[80];
    
    time_t rawtime = [self timeIntervalSince1970] - [[NSTimeZone localTimeZone] secondsFromGMT];
    timeinfo = localtime(&rawtime);
    
    strftime(buffer, 80, "%Y-%m-%dT%H:%M:%S%z", timeinfo);
    
    return [NSString stringWithCString:buffer encoding:NSUTF8StringEncoding];
}


@end

