//
//  FWF
//  common class Extensions for FWF
//
//  Created by Enrico Opri
//  Copyright (c) 2013 Enrico Opri. All rights reserved.
//

#import "NSData-ext.h"
#import "FWF_Utils.h"

@implementation NSData(FWF)

+ (NSString *) sqlType{
    return @"BLOB";
}

- (NSString *) sqlType{
    return [[self class] sqlType];
}

- (id) fmdbCompatibleValue{
    if ([self length]<1000) {
        return [self copy];
    }else{
        return [self copy];
    }
}

+ (id)objectWithFMDBCompatibleType:(id) value{
	if (value == nil)
		return nil;
    
    //check if is NSData
    if (!([value isKindOfClass:[NSData class]]||[value isKindOfClass:[NSString class]]))
		return nil;//maybe it's better to throw an exception
    if ([value length] == 0)
		return nil;
    if ([value isKindOfClass:[NSData class]]) {
        return [value copy];
    }else{
        //get the file
    }
}

@end
