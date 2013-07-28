//
//  FWF
//  added Object Data Types based
//  object models of non object datatypes
//
//  Created by Enrico Opri.
//  Copyright (c) 2013 Enrico Opri. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OBJUInteger : NSObject <NSCopying, NSCoding>{
    NSInteger unsignedIntegerValue;
}

@property (readonly, nonatomic, assign) NSInteger unsignedIntegerValue;

+ (id)objuintegerWithUInteger:(NSUInteger) value;
- (id)initWithUInteger:(NSUInteger) value;
+ (id)objuintegerWithNumber:(NSNumber *) value;
- (id)initWithNumber:(NSNumber*) value;

- (NSString *) stringValue;
- (NSNumber *) numberValue;

- (NSComparisonResult)compare:(OBJUInteger *)anOBJUInteger;
@end
