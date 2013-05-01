//
//  FWF
//  common class Extensions for FWF
//
//  Created by Enrico Opri
//  Copyright (c) 2013 Enrico Opri. All rights reserved.
//

#import "NSMutableDictionary-ext1.h"

@implementation NSMutableDictionary (ext1)

- (void) removeObjectForKeyIfExists:(id) key{
    if([self objectForKey:key])
        [self removeObjectForKey:key];
}

- (void) removeObjectsForKeysIfExists:(NSArray *) keyArray{
    [keyArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [self removeObjectForKeyIfExists:obj];
    }];
}

@end
