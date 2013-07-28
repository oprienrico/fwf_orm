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

+ (NSDictionary *)attributesTypeFromClass:(Class)klass;
+ (NSDictionary *)attributesTypeFromObject:(NSObject *) obj;
+ (NSString *) classNameFromObject:(id) obj;
+ (NSString *) classNameFromObject:(Class) objectClass WithAttributeName:(NSString *) attributeName;

@end
