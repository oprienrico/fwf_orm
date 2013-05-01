//
//  FWF
//  common class Extensions for FWF
//
//  Created by Enrico Opri
//  Copyright (c) 2013 Enrico Opri. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (ext1)

- (void) removeObjectForKeyIfExists:(id) key;
- (void) removeObjectsForKeysIfExists:(NSArray *) keyArray;

@end
