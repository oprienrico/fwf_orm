//
//  FWF
//
//  Created by Enrico Opri.
//  Copyright (c) 2013 Enrico Opri. All rights reserved.
//

#pragma GCC diagnostic ignored "-Wobjc-autosynthesis-property-ivar-name-match"

#import <Foundation/Foundation.h>

#import "FMDbWrapper.h"

@interface FWFList : NSObject <NSCopying>

-(id) initWithClass:(Class) cl;

- (FWFList *) beginSQLChainedFiltering;
- (FWFList *) executeSQLChainedFiltering;
- (FWFList *) all;
- (FWFList *) filterWithSQLPredicate:(NSString *)predicate;// chained filtering if you use only sql (SQLPredicate overwrites Predicate filtering)
- (void) resetSQLPredicateList;
- (FWFList *) filterWithPredicate:(NSString *)predicate;// chained o meglio consecutive filter yei!

- (id) getFirstOrNilWithSQLPredicate:(NSString *)predicate;

- (void) deleteFromStorage;

- (NSUInteger) count;

- (id) objectWithListIndex:(NSUInteger) index;
- (id) objectWithPk:(NSUInteger) index;

- (NSArray *) serializeWithDictionary;
- (NSArray *) listEntities;


@end
