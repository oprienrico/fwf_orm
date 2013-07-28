//
//  FWF
//
//  Created by Enrico Opri.
//  Copyright (c) 2013 Enrico Opri. All rights reserved.
//

#import "FWFList.h"

#import "ClassUtility.h"
#import "newOBJDataTypes.h"
#import "commonClassExtensions.h"

#import "FWFEntity.h"
#import "FWF_Costants.h"
#import "FWFRelationship_XToOne.h"
#import "FWFRelationship_OneToMany.h"
#import "FWF_Utils.h"

@interface FWFList (){
    Class entity_class;
    NSString *baseSQL;
    
    NSMutableArray *list;
    
    bool _wasLoadedDataFromDb;
    bool _isChainedFilter;
    
    NSMutableArray *searchSQLANDList;
}

@end

@implementation FWFList

//remember to ALWAYS init with initWithClass
-(id)initWithClass:(Class)cl{
    if (self = [super init]){
        entity_class = cl;
        baseSQL = [[NSString alloc] initWithFormat:@"SELECT * FROM %@ WHERE 1=1",[self entityName]];
        [self resetSQLPredicateList];
        _isChainedFilter = false;
    }
    return self;
}

- (NSString *) entityName{
    return NSStringFromClass(entity_class);
}

- (void) cleanList{
    NSMutableIndexSet *indexes = [[NSMutableIndexSet alloc] init];
    for( int i = 0; i < [list count]; i ++ )
        if([[list objectAtIndex:i] __deleted])
            [indexes addIndex : i];
    
    [list removeObjectsAtIndexes:indexes];
}

- (id) listOBJ{
    //because we don't want to reflect changes in the array in the internal attributes of FWFList (list)
    return [self copy];
}

- (NSMutableArray *) populateListWithSQL:(NSString *) sql{
    FWFORMDbWrapper *db = FWF_STD_DB_ENGINE_NO_FK; //fk support not needed because we do only select queries (and not complex ones)
    FWFLog(@"sql query:%@",sql);
    FMResultSet *result = [db executeQuery:sql];

    if (result == nil) {
        [db close];
        @throw FWF_EXCEPTION_PERSISTENCE;
    }
    
    NSArray *tempList = [result listAllResultsAsArrayOfDictio];
    NSMutableArray *tempEntityList = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dictio in tempList) {
        [tempEntityList addObject:[FWF_Utils setItemFromFMDBDictio:dictio withClass:entity_class]];
    }
    
    [db close];

    
    return tempEntityList;
    
}

- (bool) wasLoadedDataFromDb{
    return (_wasLoadedDataFromDb || [searchSQLANDList count]>0);
}

- (void) setWasLoadedDataFromDb:(BOOL) flag{
    _wasLoadedDataFromDb = flag;
}

- (void) setIsChainedFilter:(bool) flag{
    _isChainedFilter = flag;
}
- (FWFList *) beginSQLChainedFiltering{
    _isChainedFilter = true;
    return [self listOBJ];
}

- (FWFList *) executeSQLChainedFiltering{
    if (!_isChainedFilter) {
        
        return nil;
    }
    list = [self populateListWithSQL:[baseSQL stringByAppendingFormat:@" AND %@", [searchSQLANDList componentsJoinedByString:@" AND "]]];
    
    return [self listOBJ];
}

- (FWFList *) all{
    [self setWasLoadedDataFromDb:true];
    [self resetSQLPredicateList];

    list=[self populateListWithSQL:baseSQL];
    
    return [self listOBJ];
}

- (void) resetSQLPredicateList{
    searchSQLANDList = [[NSMutableArray alloc] init];//reset seach query
}

- (FWFList *) filterWithSQLPredicate:(NSString *)predicate {
    if (!_isChainedFilter) {
        if ([self wasLoadedDataFromDb]){
            //if predicate is empty return the actual list
            if([predicate length]<1)
            return [self listOBJ];
        }else{
            if([predicate length]<1)
            return [self all];//init with all the Entities if never filtered before
        }
        
        [searchSQLANDList addObject:predicate];

        list = [self populateListWithSQL:[baseSQL stringByAppendingFormat:@" AND %@", [searchSQLANDList componentsJoinedByString:@" AND "]]];
    }else{
        [searchSQLANDList addObject:predicate];
    }
    return [self listOBJ];
}

- (id) firstObjOrNilWithSQLPredicate:(NSString *)predicate {
    if ([self wasLoadedDataFromDb]){
        //if predicate is empty return the actual list
        if([predicate length]<1)
            return [[self listOBJ] objectWithListIndex:0];
    }else{
        if([predicate length]<1)
            return [[self filterWithSQLPredicate:@" 1=1 LIMIT 1"] objectWithListIndex:0];//search from all the Entities if never filtered before
    }
    
    [searchSQLANDList addObject:predicate];
    
    list = [self populateListWithSQL:[baseSQL stringByAppendingFormat:@" AND %@ LIMIT 1", [searchSQLANDList componentsJoinedByString:@" AND "]]];
    
    return [[self listOBJ] objectWithListIndex:0];
}
  
- (FWFList *) filterWithPredicate:(NSString *)predicate {
    if ([self wasLoadedDataFromDb]){
        //if predicate is empty return the actual list
        if([predicate length]<1)
            return [self listOBJ];
    }else{
        if([predicate length]<1)
            return [self all];//init with all the Entities if never filtered before
        else
            [self all];
    }
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:predicate];
    list = [[list filteredArrayUsingPredicate:pred] mutableCopy];
    
    return [self listOBJ];
}

//delete selected elements
- (void) deleteFromStorage{
    FWFORMDbWrapper *db = FWF_STD_DB_ENGINE;
    [db beginTransaction];

    for( int i = 0; i < [list count]; i ++ ){
        [[list objectAtIndex:i] set__deleted:TRUE];
        if(![[list objectAtIndex:i] deleteWithDbObj:db]){
            [db rollback];
            [db close];
            @throw FWF_EXCEPTION_PERSISTENCE;
            break;
        }
    }
    [db commit];
    [db close];
    
    [self cleanList];//remove deleted items from list, now list can be used safely
}

- (NSUInteger) count{
    return [list count];
}

//search into the ArrayList
- (id) objectWithListIndex:(NSUInteger) index{
    //if index is inside array bounds
    if ([self count]>index) {
        return [list objectAtIndex:index];
    }
    return nil;
}

//search in sql
- (id) objectWithPk:(NSUInteger) index{
    __block id found_obj = nil;
    [list enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if([obj pk] == index){
            found_obj = obj;
            *stop = YES;
        }
    }];
    return found_obj;
}

- (NSArray *) serializeWithDictionary{
    //obtain value from object attributes
    __block NSMutableArray *tempArr = [[NSMutableArray alloc] init];
    
    [list enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [tempArr addObject:[obj serializeWithDictionary]];
    }];
    
    return (NSArray *) tempArr;
}

- (NSArray *) listEntities{
    return [list copy];//return a copy not the same object, because we don't want to reflect changes in the array in the internal list of FWFList
}

- (void) enumerateObjectsUsingBlock:(void (^)(id obj, NSUInteger idx, BOOL *stop)) block {
    [list enumerateObjectsUsingBlock:block];
}

// In the implementation
-(id)copyWithZone:(NSZone *)zone{
    // We'll ignore the zone for now
    FWFList *another = [[FWFList allocWithZone:zone] init];

    [another setValue:entity_class forKey:@"entity_class"];
    [another setValue:list forKey:@"list"];
    [another setWasLoadedDataFromDb:_wasLoadedDataFromDb];
    [another setValue:searchSQLANDList forKey:@"searchSQLANDList"];
    [another setValue:baseSQL forKey:@"baseSQL"];
    [another setIsChainedFilter:_isChainedFilter];

    return another;
}

@end
