//
//  FWF
//  common class Extensions for FWF
//
//  Created by Enrico Opri
//  Copyright (c) 2013 Enrico Opri. All rights reserved.
//

#import "OBJBool-ext.h"

@implementation OBJBool (FWF)

+ (NSString *) sqlType{
    return @"INTEGER";
}

- (id) fmdbCompatibleValue{
	return [NSNumber numberWithBool:[self boolValue]];
}

+ (id)objectWithFMDBCompatibleType:(id) value{
    if (value == nil)
		return nil;
    
    //check if is NSNumber
    if (![value isKindOfClass:[NSNumber class]])
        return nil;

    return [self objboolWithBool:[value boolValue]];;
}
@end
