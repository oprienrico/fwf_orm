//
//  FWF
//  added Object Data Types based
//  object models of non object datatypes
//
//  Created by Enrico Opri.
//  Copyright (c) 2013 Enrico Opri. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OBJBool : NSObject <NSCopying, NSCoding>{
    BOOL boolValue;
}

@property (readonly, nonatomic, assign) BOOL boolValue;

+ (id) objboolWithBool:(BOOL) value;
- (id)initWithBool:(BOOL) value;

- (NSComparisonResult)compare:(OBJBool *) anOBJBool;

@end
