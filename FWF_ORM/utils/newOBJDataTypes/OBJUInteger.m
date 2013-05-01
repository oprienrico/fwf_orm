//
//  FWF
//  added Object Data Types based
//  object models of non object datatypes
//
//  Created by Enrico Opri.
//  Copyright (c) 2013 Enrico Opri. All rights reserved.
//

#import "OBJUInteger.h"

@implementation OBJUInteger

@synthesize unsignedIntegerValue = _unsignedIntegerValue;


+ (id)objuintegerWithUInteger:(NSUInteger) value {
    return [[OBJUInteger alloc] initWithUInteger: value];
}

- (id)init
{
    self = [super init];
    if (self) {
        _unsignedIntegerValue = 0;
    }
    return self;
}

- (id)initWithUInteger:(NSUInteger) value {
    self = [super init];
	if (self) {
		_unsignedIntegerValue = value;
	}
	return self;
}

+ (id)objuintegerWithNumber:(NSNumber *)value {
    return [[OBJUInteger alloc] initWithUInteger: [value unsignedIntegerValue]];
}

- (id)initWithNumber:(NSNumber *)value {
    self = [super init];
	if (self) {
		_unsignedIntegerValue = [value unsignedIntegerValue];
	}
	return self;
}


- (NSString *) stringValue{
    return [NSString stringWithFormat:@"%lu", (long)_unsignedIntegerValue];
}

- (NSNumber *) numberValue{
    return [NSNumber numberWithInteger: _unsignedIntegerValue];
}


- (NSComparisonResult)compare:(OBJUInteger *)anOBJInteger {
	NSAssert(anOBJInteger != nil, @"OBJUInteger cannot compare to nil");
    
	if (_unsignedIntegerValue < anOBJInteger.unsignedIntegerValue) {
		return NSOrderedAscending;
	} else if (_unsignedIntegerValue == anOBJInteger.unsignedIntegerValue) {
		return NSOrderedSame;
	} else {
		return NSOrderedDescending;
	}
}

//used when printed
- (NSString *)description {
	return [NSString stringWithFormat:@"<OBJUInteger: %lu>", (long)_unsignedIntegerValue];
}

#pragma mark -
#pragma mark NSObject Protocol methods

- (NSUInteger)hash {
	return (NSUInteger) _unsignedIntegerValue;
}

- (BOOL)isEqual:(id)anObject {
	if (self == anObject) {
		return YES;
	}
    
	if (!anObject) {
		// We know self isn't nil, so return NO
		return NO;
	}
    
	if (![anObject isKindOfClass:[OBJUInteger class]]) {
		return NO;
	}
    
	return _unsignedIntegerValue == ((OBJUInteger *)anObject).unsignedIntegerValue;
}

#pragma mark -
#pragma mark NSCopying Protocol methods

- (id)copyWithZone:(NSZone *)zone {
	OBJUInteger *newObject = [[OBJUInteger allocWithZone:zone] initWithUInteger:_unsignedIntegerValue];
	return newObject;
}

#pragma mark -
#pragma mark NSCoding methods

- (id)initWithCoder:(NSCoder *)coder {
	if (self = [super init]) {
        _unsignedIntegerValue = [coder decodeIntegerForKey:@"OBJUInteger.value"];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
	[coder encodeInteger:_unsignedIntegerValue forKey:@"OBJUInteger.value"];
}


@end
