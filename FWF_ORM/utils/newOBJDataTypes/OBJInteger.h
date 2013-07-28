//
//  FWF
//  added Object Data Types based
//  object models of non object datatypes
//
//  Created by Enrico Opri.
//  Copyright (c) 2013 Enrico Opri. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OBJInteger : NSObject <NSCopying, NSCoding>{
    NSInteger integerValue;
}

@property (readonly, nonatomic, assign) NSInteger integerValue;

+ (id)objintegerWithInteger:(NSInteger) value;
- (id)initWithInteger:(NSInteger) value;
+ (id)objintegerWithNumber:(NSNumber *) value;
- (id)initWithNumber:(NSNumber*) value;

- (NSString *) stringValue;
- (NSNumber *) numberValue;

- (NSComparisonResult)compare:(OBJInteger *)anOBJInteger;
@end
