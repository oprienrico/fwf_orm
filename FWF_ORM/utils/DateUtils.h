//
//  FWF
//  generic utils
//
//  Created by Enrico Opri.
//  Copyright (c) 2013 Enrico Opri. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <time.h>


@interface NSDate (TimeConversion_Varius)
+ (NSDate *) dateFromString:(NSString *) dateString withFormat:(NSString *) format;
+ (NSDate *) dateFromUTCString:(NSString *) dateString withFormat:(NSString *) format;
+ (NSDate *) dateFromUTCStringWithStandardFormat:(NSString *) dateString;

- (NSString *) stringUTCValueWithStandardFormat;
- (NSString *) stringUTCValueWithFormat:(NSString *) format;
+ (NSString *) STANDARD_DATE_FORMAT;



/////////////
//  c_Like
/////////////

+ (NSDate *)dateFromISO8601String:(NSString *)string;

- (NSString *)ISO8601String;

@end
