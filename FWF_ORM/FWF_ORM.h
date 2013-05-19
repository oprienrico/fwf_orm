//
//  FWF
//
//  Created by Enrico Opri.
//  Copyright (c) 2013 Enrico Opri. All rights reserved.
//

@interface FWF : NSObject

+ (void) resetStorage;
+ (void) shrinkDownStorage;

+ (NSArray *) listClassesOfStoredEntities;
+ (NSArray *) listNamesOfStoredEntities;

@end
