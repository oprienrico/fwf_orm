//
//  FMDB extensions
//
//  Created by Enrico Opri.
//  Copyright (c) 2013 Enrico Opri. All rights reserved.
//

#import "FMResultSet.h"


@interface FMResultSet (FMResultSetAddOn)

- (id)objectForColumnIndex:(int)columnIdx withOverridedTypes:(NSString *) overridedType;

- (NSDictionary*)resultDictionaryWithOverridedTypes:(NSArray *) overridedTypes;

- (NSArray *)getResultArrayOfDictio;
- (NSArray *)getResultArrayOfDictioWithOverridedTypes:(NSArray *) overridedTypes;

@end
