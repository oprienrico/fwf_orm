//
//  FWF
//  added Object Data Types based
//  object models of non object datatypes
//
//  Created by Enrico Opri.
//  Copyright (c) 2013 Enrico Opri. All rights reserved.
//

#import "OBJInteger.h"

@implementation OBJInteger

@synthesize integerValue = _integerValue;


+ (id)objintegerWithInteger:(NSInteger) value {
    return [[OBJInteger alloc] initWithInteger: value];
}

- (id)init
{
    self = [super init];
    if (self) {
        _integerValue = 0;
    }
    return self;
}

- (id)initWithInteger:(NSInteger) value {
    self = [super init];
	if (self) {
		_integerValue = value;
	}
	return self;
}

+ (id)objintegerWithNumber:(NSNumber *)value {
    return [[OBJInteger alloc] initWithInteger: [value integerValue]];
}

- (id)initWithNumber:(NSNumber *)value {
    self = [super init];
	if (self) {
		_integerValue = [value integerValue];
	}
	return self;
}


- (NSString *) stringValue{
    return [NSString stringWithFormat:@"%ld", (long)_integerValue];
}

- (NSNumber *) numberValue{
    return [NSNumber numberWithInteger: _integerValue];
}


- (NSComparisonResult)compare:(OBJInteger *)anOBJInteger {
	NSAssert(anOBJInteger != nil, @"OBJInteger cannot compare to nil");
    
	if (self.integerValue < anOBJInteger.integerValue) {
		return NSOrderedAscending;
	} else if (self.integerValue == anOBJInteger.integerValue) {
		return NSOrderedSame;
	} else {
		return NSOrderedDescending;
	}
}

//used when printed
- (NSString *)description {
	return [NSString stringWithFormat:@"<OBJInteger: %ld>", (long)_integerValue];
}

#pragma mark -
#pragma mark NSObject Protocol methods

- (NSUInteger)hash {
	return (NSUInteger) _integerValue;
}

- (BOOL)isEqual:(id)anObject {
	if (self == anObject) {
		return YES;
	}
    
	if (!anObject) {
		// We know self isn't nil, so return NO
		return NO;
	}
    
	if (![anObject isKindOfClass:[OBJInteger class]]) {
		return NO;
	}
    
	return self.integerValue == ((OBJInteger *)anObject).integerValue;
}

#pragma mark -
#pragma mark NSCopying Protocol methods

- (id)copyWithZone:(NSZone *)zone {
	OBJInteger *newObject = [[OBJInteger allocWithZone:zone] initWithInteger:_integerValue];
	return newObject;
}

#pragma mark -
#pragma mark NSCoding methods

- (id)initWithCoder:(NSCoder *)coder {
	if (self = [super init]) {
        _integerValue = [coder decodeIntegerForKey:@"OBJInteger.value"];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
	[coder encodeInteger:_integerValue forKey:@"OBJInteger.value"];
}


@end
