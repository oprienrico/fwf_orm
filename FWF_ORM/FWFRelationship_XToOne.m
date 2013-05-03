//
//  FWF
//
//  Created by Enrico Opri.
//  Copyright (c) 2013 Enrico Opri. All rights reserved.
//

#import "FWFRelationship_XToOne.h"

#import "ClassUtility.h"
#import "commonClassExtensions.h"
#import "newOBJDataTypes.h"
#import "FMDbWrapper.h"
#import "FWFEntity.h"
#import "FWF_Utils.h"


@implementation FWFRelationship_XToOne{
    FWF_FK_ACTION _actionOnDelete;    
}

- (id) initWithClass:(Class)cl{
    if(self = [super initWithClass:cl]){
        _referencedEntityPk = 0;
        _actionOnDelete = 0;
    }
    
    return self;
}

- (id) object{
    if (self->_referencedEntityPk == 0) {
        return nil;
    }
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE pk = %lu", [self referencedEntityName], (long)_referencedEntityPk];
    NSArray *arr = [self populateListWithSQL:sql];
    if ([arr count] > 0)
        return [arr objectAtIndex:0];
    
    //if it's empty (no object referenced) return null
    return nil;
}

- (bool) setObject:(FWFEntity *) obj{
    //check if obj passed is instance of the correct class
    if (![obj isKindOfClass:[self referencedEntityClass]]) {
        self->_referencedEntityPk = 0;
        #ifdef FWF_LAZY_ERRORS
            #if FWF_LAZY_ERRORS == false
                @throw (FWF_EXCEPTION_OBJECT_NOT_ISTANCE_OF_REFERENCED_CLASS_IN_RELATIONSHIP);
            #endif
        #else
            @throw (FWF_EXCEPTION_OBJECT_NOT_ISTANCE_OF_REFERENCED_CLASS_IN_RELATIONSHIP);
        #endif
        return false;
    }
    //check if exist
    FMDbWrapper *db = FWF_STD_DB_ENGINE_NO_FK;

    if([db intForQuery:[NSString stringWithFormat:@"select count(pk) FROM %@ WHERE pk = %lu", [self referencedEntityName], (long)[obj pk]]]<1){
        //close the open connection
        [db close];
        #ifdef FWF_LAZY_ERRORS
            #if FWF_LAZY_ERRORS == false
                @throw (FWF_EXCEPTION_REFERENCED_OBJECT_NOT_EXIST_OR_IS_NOT_SAVED);
            #endif
        #else
            @throw (FWF_EXCEPTION_REFERENCED_OBJECT_NOT_EXIST_OR_IS_NOT_SAVED);
        #endif
        return false;
    }
    
    self->_referencedEntityPk = [obj pk];
    
    [db close];
    return true;
}

- (void) setObjectWithPkNumber:(NSNumber *) pk{
    if (pk == nil) {
        _referencedEntityPk = 0;
        return;
    }else if((NSNull *)pk == [NSNull null]){
        _referencedEntityPk = 0;
        return;
    }
        
    _referencedEntityPk = [pk unsignedIntegerValue];
}

- (void) setObjectWithPkOBJInteger:(OBJUInteger *) pk{
    if (pk == nil) {
        referencedEntityPk = 0;
        return;
    } if((NSNull *)pk == [NSNull null]){
        _referencedEntityPk = 0;
        return;
    }
    
    _referencedEntityPk = [pk unsignedIntegerValue];
}

- (void) setNoObject{
    _referencedEntityPk = 0;
}


+ (NSString *) sqlType{
    return @"INTEGER";
}

- (id) fmdbCompatibleValue{
    if (_referencedEntityPk > 0) {
        return [NSNumber numberWithUnsignedInteger:_referencedEntityPk];
    }else{
        return [NSNull null];
    }
}

- (NSString *)description {
    if (_referencedEntityPk > 0) {
        return [NSString stringWithFormat:@"<FWFRelationship_XToOne: linked to %@, pk %lu>", [self referencedEntityName], (long)_referencedEntityPk];
    }
	return [NSString stringWithFormat:@"<FWFRelationship_XToOne: linked to %@, no referenced entity>", [self referencedEntityName]];
}

- (void) setActionOnDelete:(FWF_FK_ACTION) action{
    _actionOnDelete = action;
}

- (NSString *) actionOnDelete{
    if(_actionOnDelete==FWF_FK_ACTION_SET_NULL){
        return @"SET NULL";
    }else if (_actionOnDelete==FWF_FK_ACTION_CASCADE){
        return @"CASCADE";
    }
    //default
    return @"SET NULL";
}

- (NSMutableArray *) populateListWithSQL:(NSString *) sql{
    NSArray *tempList = nil;
    
    FMDbWrapper *db = FWF_STD_DB_ENGINE_NO_FK;
    
    tempList = [db getArrayFromExecutingSQL:sql];
    
    NSMutableArray *tempEntityList = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dictio in tempList) {
        [tempEntityList addObject:[FWF_Utils setItemFromDictio:dictio withClass:[self referencedEntityClass]]];
    }
    
    [db close];
    
    return tempEntityList;
}

@end