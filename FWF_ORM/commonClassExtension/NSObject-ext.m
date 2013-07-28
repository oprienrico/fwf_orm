//
//  FWF
//  common class Extensions for FWF
//
//  Created by Enrico Opri
//  Copyright (c) 2013 Enrico Opri. All rights reserved.
//

#import "NSObject-ext.h"


@implementation NSObject(FWF)

/*+ (BOOL)canBeStoredAsBlob{
    return [self conformsToProtocol:@protocol(NSCoding)];
}

- (BOOL)canBeStoredAsBlob{
    return [self conformsToProtocol:@protocol(NSCoding)];
}*/

+ (NSString *) sqlType{
    return @"BLOB";
}

- (NSString *) sqlType{
    return [[self class] sqlType];
}

- (id) fmdbCompatibleValue{
    NSMutableData *data = [[NSMutableData alloc] init];
	NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
	[archiver encodeObject:self forKey:@"obj1"];
	[archiver finishEncoding];

	return data;
}


+ (id)objectWithFMDBCompatibleType:(id) value{
	if (value == nil)
		return nil;
    
    //check if is NSData
    if (![value isKindOfClass:[NSData class]])
		return nil;//maybe it's better to throw an exception
    if ([value length] == 0)
		return nil;
	//NSLog(@"blob field length %d", [value length]);
	NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:value];
	id ret = [unarchiver decodeObjectForKey:@"obj1"];
	[unarchiver finishDecoding];
	
	return ret;
}

@end
