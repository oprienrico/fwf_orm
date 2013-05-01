//
//  FWF
//  added Object Data Types based
//  object models of non object datatypes
//
//  Created by Enrico Opri.
//  Copyright (c) 2013 Enrico Opri. All rights reserved.
//

#import "OBJBool.h"

@implementation OBJBool

@synthesize boolValue = _boolValue;

+ (id) objboolWithBool:(BOOL) value{
    return [[OBJBool alloc] initWithBool: value];
}

- (id)initWithBool:(BOOL) value {
    self = [super init];
	if (self) {
		_boolValue = value;
	}
	return self;
}

- (NSComparisonResult)compare:(OBJBool *) anOBJBool {
	NSAssert(anOBJBool != nil, @"OBJBool cannot compare to nil");
    
	if (_boolValue == NO && anOBJBool.boolValue == YES) {
		return NSOrderedAscending;
	} else if (_boolValue == anOBJBool.boolValue) {
		return NSOrderedSame;
	} else {
		return NSOrderedDescending;
	}
}

- (NSString *)description {
	return [NSString stringWithFormat:@"<OBJBool: %@>", _boolValue ? @"YES" : @"NO"];
}


#pragma mark -
#pragma mark NSObject Protocol methods

- (NSUInteger)hash {
	return _boolValue == NO ? 0 : 1;
}

- (BOOL)isEqual:(id)anObject {
	if (self == anObject) {
		return YES;
	}
    
	if (!anObject) {
		// We know self isn't nil, so return NO
		return NO;
	}
    
	if (![anObject isKindOfClass:[OBJBool class]]) {
		return NO;
	}
    
	return _boolValue == ((OBJBool *)anObject).boolValue;
}


#pragma mark -
#pragma mark NSCopying Protocol methods

- (id)copyWithZone:(NSZone *)zone {
	OBJBool *newObject = [[OBJBool allocWithZone:zone] initWithBool:_boolValue];    
	return newObject;
}


#pragma mark -
#pragma mark NSCoding methods

- (id)initWithCoder:(NSCoder *)coder {
	if (self = [super init]) {
		_boolValue = [coder decodeBoolForKey:@"OBJBool.flag"];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
	[coder encodeBool:_boolValue forKey:@"OBJBool.flag"];
}

@end
