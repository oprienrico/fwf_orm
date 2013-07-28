//
//  FWF
//
//  Created by Enrico Opri.
//  Copyright (c) 2013 Enrico Opri. All rights reserved.
//

@interface FWF

+ (bool) resetStorage;
+ (void) shrinkDownStorage;

+ (NSArray *) listClassesOfStoredEntities;
+ (NSArray *) listNamesOfStoredEntities;

@end
