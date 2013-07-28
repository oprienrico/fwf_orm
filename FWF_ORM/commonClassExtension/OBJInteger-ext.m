//
//  FWF
//  common class Extensions for FWF
//
//  Created by Enrico Opri
//  Copyright (c) 2013 Enrico Opri. All rights reserved.
//

#import "OBJInteger-ext.h"
#import "NSObject-ext.h"

@implementation OBJInteger (FWF)

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
	
    return [self objintegerWithNumber:value];
}
@end
