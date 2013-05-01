//
//  FWF
//  common class Extensions for FWF
//
//  Created by Enrico Opri
//  Copyright (c) 2013 Enrico Opri. All rights reserved.
//

#import "NSDate-ext.h"
/*
*   NSDate saved as unix timestamp, localized UTC as standard
*/

@implementation NSDate(FWF)

+ (NSString *) sqlType{
    return @"REAL";
}

- (id) fmdbCompatibleValue{
    return [NSNumber numberWithDouble:[self timeIntervalSince1970]];
	//return [self stringUTCValueWithStandardFormat];
}

+ (id)objectWithFMDBCompatibleType:(id) value{
    if (value == nil)
		return nil;
    
    //check if is NSNumber
    if (![value isKindOfClass:[NSNumber class]])
        return nil;
	
    return [NSDate dateWithTimeIntervalSince1970:[value doubleValue]];
    //return [self dateFromUTCStringWithStandardFormat:value];
}
@end
