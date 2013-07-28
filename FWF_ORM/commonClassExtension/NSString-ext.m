//
//  FWF
//  common class Extensions for FWF
//
//  Created by Enrico Opri
//  Copyright (c) 2013 Enrico Opri. All rights reserved.
//

#import "NSString-ext.h"

@implementation NSString (FWF)

+ (NSString *) sqlType{
    return @"TEXT";
}

- (id) fmdbCompatibleValue{
	return [self copy];
}

+ (id)objectWithFMDBCompatibleType:(id) value{
    if (value == nil)
		return nil;
    
    //check if is NSString
    if (![value isKindOfClass:[NSString class]])
        return nil;
	
    return [value copy];
}
@end
