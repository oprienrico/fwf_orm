//
//  FWF
//  common class Extensions for FWF
//
//  Created by Enrico Opri
//  Copyright (c) 2013 Enrico Opri. All rights reserved.
//

#import "NSData-ext.h"


@implementation NSData(FWF)

+ (NSString *) sqlType{
    return @"BLOB";
}

- (NSString *) sqlType{
    return [[self class] sqlType];
}

- (id) fmdbCompatibleValue{
	return [self copy];
}


+ (id)objectWithFMDBCompatibleType:(id) value{
	if (value == nil)
		return nil;
    
    //check if is NSData
    if (![value isKindOfClass:[NSData class]])
		return nil;//maybe it's better to throw an exception
    if ([value length] == 0)
		return nil;

	return [value copy];
}

@end
