//
//  FWF
//
//  Created by Enrico Opri.
//  Copyright (c) 2013 Enrico Opri. All rights reserved.
//

#import "FWFForeignKey.h"
@class FWFList;
@class FWFEntity;

@interface FWFForeignKey_ManyToMany : FWFForeignKey

- (id) initWithClass:(Class)cl andDelegate:(id) del;

- (FWFList *) objects;

- (bool) addObjectWithPk:(NSUInteger) pk;
- (bool) removeObjectWithPk:(NSUInteger) pk;
- (bool) addObject:(FWFEntity *) obj;
- (bool) addObjectsWithArray:(NSArray *)list;
- (bool) addObjects:(FWFList *)entitylist;
- (bool) removeObject:(FWFEntity *) obj;
//overwrite referenced objects
- (bool) setObjectsWithArray:(NSArray *)list;
- (bool) setObjects:(FWFList *)entitylist;

- (NSString *) getLookupTableName;
+ (NSString *) buildLookupTableNameWithClassName1:(NSString *) name1 andClassName2:(NSString *) name2;
@end
