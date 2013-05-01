//
//  FWF
//  common class Extensions for FWF
//
//  Created by Enrico Opri
//  Copyright (c) 2013 Enrico Opri. All rights reserved.
//

#import "OBJUInteger-ext.h"
#import "NSObject-ext.h"

@implementation OBJUInteger (FWF)

+ (NSString *) sqlType{
    return @"INTEGER";
}

- (id) fmdbCompatibleValue{
	return [self numberValue];
}

+ (id)objectWithFMDBCompatibleType:(id) value{
    if (value == nil)
		return nil;
    
    //check if is NSNumber
    if (![value isKindOfClass:[NSNumber class]])
        return nil;
	
    return [self objuintegerWithNumber:value];
}
@end
