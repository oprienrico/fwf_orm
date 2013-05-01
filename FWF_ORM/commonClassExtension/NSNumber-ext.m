//
//  FWF
//  common class Extensions for FWF
//
//  Created by Enrico Opri
//  Copyright (c) 2013 Enrico Opri. All rights reserved.
//

#import "NSNumber-ext.h"


@implementation NSNumber(FWF)
+ (NSString *) sqlType{
    return @"REAL";
}

- (id) fmdbCompatibleValue{
	return [self copy];
}

+ (id)objectWithFMDBCompatibleType:(id) value{
    if (value == nil)
		return nil;
    
    //check if is NSNumber
    if (![value isKindOfClass:[NSNumber class]])
        return nil;
	
    return [value copy];
}
@end
