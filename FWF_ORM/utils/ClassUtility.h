//
//  FWF
//  generic utils
//
//  Created by Enrico Opri.
//  Copyright (c) 2013 Enrico Opri. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "objc/runtime.h"

@interface ClassUtility : NSObject

+ (NSDictionary *)getAttributesTypeFromClass:(Class)klass;
+ (NSDictionary *)getAttributesTypeFromObject:(NSObject *) obj;
+ (NSString *) getClassNameFromObject:(id) obj;
+ (NSString *) getClassNameFromObject:(Class) objectClass WithAttributeName:(NSString *) attributeName;

@end
