//
//  FWF
//
//  Created by Enrico Opri.
//  Copyright (c) 2013 Enrico Opri. All rights reserved.
//

#import "FWFRelationship_ManyToMany.h"
#import "ClassUtility.h"
#import "commonClassExtensions.h"
#import "newOBJDataTypes.h"
#import "FWF_Costants.h"
#import "FWFEntity.h"
#import "FWFList.h"
#import "FWF_Utils.h"

#import "FWFRelationship_XToOne.h"

@interface FWFRelationship_ManyToMany(){
    id delegate;
}

@property (nonatomic, weak) id delegate;

- (void) setDelegate:(id)del;
@end

@implementation FWFRelationship_ManyToMany

- (id) initWithClass:(Class)cl{
    self = [super initWithClass:cl];
    
    return self;
}

- (id) initWithClass:(Class)cl andDelegate:(id) del{
    if(self = [super initWithClass:cl])
        delegate = del;
    return self;
}

- (void) setDelegate:(id)del{
    delegate = del;
}

- (FWFList *) objects{
    FWFList *listObjs = [[FWFList alloc] initWithClass:[self referencedEntityClass]];

        [listObjs setValue:[NSString stringWithFormat:@"SELECT %@.* FROM %@ INNER JOIN %@ AS lutb ON %lu=lutb.%@ AND lutb.%@ = %@.pk WHERE 1=1 ", [self referencedEntityName], [self referencedEntityName], [self getLookupTableName], (long)[delegate pk], [delegate entityName], [self referencedEntityName], [self referencedEntityName]] forKey:@"baseSQL"];
    
    return listObjs;
}

+ (NSString *) buildLookupTableNameWithClassName1:(NSString *) name1 andClassName2:(NSString *) name2{
    if ([name1 compare:name2] > 0) {
        return [NSString stringWithFormat:@"fwflu_%@_%@", name1, name2];
    }else{
        return [NSString stringWithFormat:@"fwflu_%@_%@", name2, name1];
    }
}

- (NSString *) getLookupTableName{        
    return [[self class] buildLookupTableNameWithClassName1:[delegate entityName] andClassName2:[self referencedEntityName]];
}

/*- (void) addObjectWithPkOBJUInteger:(OBJUInteger *) pk{
    if (pk == nil) {
        //
        return;
    }else if((NSNull *)pk == [NSNull null]){
        //
        return;
    }
}*/

- (bool) addObjectWithPk:(NSUInteger) pk{
    FMDbWrapper *db = FWF_STD_DB_ENGINE;
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@ VALUES (%lu, %lu)",[self getLookupTableName], (long)[delegate pk], (long)pk];
    if (![db executeUpdate:sql]) {
        //close the open connection
        [db close];
        //if query fails is because one of the object referenced does not exists
        #ifdef FWF_LAZY_ERRORS
            #if FWF_LAZY_ERRORS == false
                @throw (FWF_EXCEPTION_REFERENCED_OBJECT_NOT_EXIST_OR_IS_NOT_SAVED);
            #endif
        #else
            @throw (FWF_EXCEPTION_REFERENCED_OBJECT_NOT_EXIST_OR_IS_NOT_SAVED);
        #endif
        
        return false;
    };
    [db close];
    return true;
}

- (bool) removeObjectWithPk:(NSUInteger) pk{
    FMDbWrapper *db = FWF_STD_DB_ENGINE;
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@=%lu AND %@=%lu", [self getLookupTableName], [delegate entityName], (long)[delegate pk], [self referencedEntityName], (long) pk];
    if (![db executeUpdate:sql]) {
        //close the open connection
        [db close];
        //if query fails is because one of the object referenced does not exists
        #ifdef FWF_LAZY_ERRORS
            #if FWF_LAZY_ERRORS == false
                @throw (FWF_EXCEPTION_REFERENCED_OBJECT_NOT_EXIST_OR_IS_NOT_SAVED);
            #endif
        #else
            @throw (FWF_EXCEPTION_REFERENCED_OBJECT_NOT_EXIST_OR_IS_NOT_SAVED);
        #endif
        return false;
    };
    [db close];
    return true;
}

- (bool) addObject:(FWFEntity *) obj{
    //check if obj passed is instance of the correct class
    if (![obj isKindOfClass:[self referencedEntityClass]]) {
        #ifdef FWF_LAZY_ERRORS
            #if FWF_LAZY_ERRORS == false
                @throw (FWF_EXCEPTION_OBJECT_NOT_ISTANCE_OF_REFERENCED_CLASS_IN_RELATIONSHIP);
            #endif
        #else
            @throw (FWF_EXCEPTION_OBJECT_NOT_ISTANCE_OF_REFERENCED_CLASS_IN_RELATIONSHIP);
        #endif
        return false;
    }
    
    return [self addObjectWithPk:[obj pk]];
}

- (bool) addObjects:(FWFList *)entitylist{
    return [self addObjectsWithArray:[entitylist listEntities]];
}

- (bool) addObjectsWithArray:(NSArray *)list{
    FMDbWrapper *db = FWF_STD_DB_ENGINE;
    [db beginTransaction];
    
    __block bool no_error = true;
    [list enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        //iterate through each object to create update query
        
        if (![db executeUpdate:[NSString stringWithFormat:@"INSERT INTO %@ VALUES (%lu, %lu)", [self getLookupTableName], (long)[delegate pk], (long)[obj pk]]]) {
            //close the open connection and revert changes
            [db rollback];
            [db close];
            //if query fails is because one of the object referenced does not exists
            #ifdef FWF_LAZY_ERRORS
                #if FWF_LAZY_ERRORS == false
                    @throw (FWF_EXCEPTION_REFERENCED_OBJECT_NOT_EXIST_OR_IS_NOT_SAVED);
                #endif
            #else
                @throw (FWF_EXCEPTION_REFERENCED_OBJECT_NOT_EXIST_OR_IS_NOT_SAVED);
            #endif
            
            no_error = false;
            *stop = false;
            return;
        };
    }];
    
    if (no_error) {
        [db commit];
        [db close];
        return true;
    }else{
        return false;
    }
}

- (bool) removeObject:(FWFEntity *) obj{
    //check if obj passed is instance of the correct class
    if (![obj isKindOfClass:[self referencedEntityClass]]) {
        #ifdef FWF_LAZY_ERRORS
            #if FWF_LAZY_ERRORS == false
                @throw (FWF_EXCEPTION_OBJECT_NOT_ISTANCE_OF_REFERENCED_CLASS_IN_RELATIONSHIP);
            #endif
        #else
            @throw (FWF_EXCEPTION_OBJECT_NOT_ISTANCE_OF_REFERENCED_CLASS_IN_RELATIONSHIP);
        #endif
        return false;
    }
    return [self removeObjectWithPk:[obj pk]];
}

- (bool) setObjects:(FWFList *)entitylist{
    return [self setObjectsWithArray:[entitylist listEntities]];
}

- (bool) setObjectsWithArray:(NSArray *)list{
    FMDbWrapper *db = FWF_STD_DB_ENGINE;
    
    [db beginTransaction];
    //delete all objects
    [db executeUpdate:[NSString stringWithFormat:@"DELETE FROM %@ WHERE %@=%lu", [self getLookupTableName], [delegate entityName], (long)[delegate pk]]];
    
    __block bool no_error = true;
    [list enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        //iterate through each object to create update query
        
        if (![db executeUpdate:[NSString stringWithFormat:@"INSERT INTO %@ VALUES (%lu, %lu)", [self getLookupTableName], (long)[delegate pk], (long)[obj pk]]]) {
            //close the open connection
            [db rollback];
            [db close];
            //if query fails is because one of the object referenced does not exists
            #ifdef FWF_LAZY_ERRORS
                #if FWF_LAZY_ERRORS == false
                    @throw (FWF_EXCEPTION_REFERENCED_OBJECT_NOT_EXIST_OR_IS_NOT_SAVED);
                #endif
            #else
                @throw (FWF_EXCEPTION_REFERENCED_OBJECT_NOT_EXIST_OR_IS_NOT_SAVED);
            #endif
            
            no_error = false;
            *stop = false;
            return;
        };
    }];
    
    if (no_error) {
        [db commit];
        [db close];
        return true;
    }else{
        return false;
    }
}

- (NSString *)description {
	return [NSString stringWithFormat:@"<FWFRelationship_ManyToMany: linked to %@>", [self referencedEntityName]];
}

@end